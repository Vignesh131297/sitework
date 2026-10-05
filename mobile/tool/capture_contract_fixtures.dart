// Records real API responses as contract fixtures for test/contract.
//
//   dart run tool/capture_contract_fixtures.dart [apiBaseUrl]
//
// Needs the dev API running on seed data (`npm run db:seed` in backend/).
// Signs in with the seeded development accounts, which exist only in dev data.
import 'dart:convert';
import 'dart:io';

const _fixtures = 'test/contract/fixtures';

Future<void> main(List<String> args) async {
  final base = Uri.parse(args.isNotEmpty ? args.first : 'http://127.0.0.1:3000/api/v1');
  final http = HttpClient();
  try {
    Future<Map<String, dynamic>> call(String method, String path, {Object? body, String? token}) async {
      final request = await http.openUrl(method, Uri.parse('$base$path'));
      request.headers.contentType = ContentType.json;
      if (token != null) request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      if (body != null) request.write(jsonEncode(body));
      final response = await request.close();
      final json = jsonDecode(await response.transform(utf8.decoder).join()) as Map<String, dynamic>;
      if (json['success'] != true) throw StateError('$method $path failed: ${json['code']} ${json['message']}');
      return json;
    }

    Future<String> signIn(String identifier, String password) async {
      final data =
          (await call('POST', '/auth/login', body: {'identifier': identifier, 'password': password}))['data']
              as Map<String, dynamic>;
      final tokens = (data['tokens'] ?? data) as Map<String, dynamic>;
      return tokens['accessToken'] as String;
    }

    Directory(_fixtures).createSync(recursive: true);

    /// Saves GET [path] as [name].json and returns the first record's id.
    Future<String?> save(String name, String path, String token) async {
      final json = await call('GET', path, token: token);
      File('$_fixtures/$name.json').writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(json)}\n');
      stdout.writeln('saved $name.json');
      final data = json['data'];
      final first = data is List && data.isNotEmpty ? data.first : data;
      return first is Map<String, dynamic> ? first['id'] as String? : null;
    }

    final admin = await signIn('+919000000001', 'Admin@123');
    await save('dashboard_admin', '/dashboard/admin', admin);
    await save('me_admin', '/me', admin);
    final siteId = await save('sites', '/sites?limit=5', admin);
    await save('site_detail', '/sites/$siteId', admin);
    final clientId = await save('clients', '/clients?limit=5', admin);
    await save('client_detail', '/clients/$clientId', admin);
    final engineerId = await save('engineers', '/engineers?limit=5', admin);
    await save('engineer_detail', '/engineers/$engineerId', admin);
    final staffId = await save('staff', '/staff?limit=5', admin);
    await save('staff_detail', '/staff/$staffId', admin);
    final staffUpdateId = await save('staff_updates', '/staff-updates?limit=5', admin);
    // Reading an update (or its photo link) records no view: only POST .../views does.
    await save('staff_update_detail', '/staff-updates/$staffUpdateId', admin);
    await save('attendance', '/attendance?limit=5', admin);
    await save('notifications', '/notifications?limit=5', admin);

    final issueId = await save('issues', '/issues?limit=5', admin);
    await save('issue_detail', '/issues/$issueId', admin);
    final engineerUpdateId = await save('engineer_updates', '/engineer-updates?limit=5', admin);
    await save('engineer_update_detail', '/engineer-updates/$engineerUpdateId', admin);
    await save('site_day', '/sites/$siteId/day', admin);
    await save('payments_summary', '/payments/summary', admin);
    await save('payments', '/payments?limit=5&includeVoided=true', admin);
    await save('site_money', '/sites/$siteId/money', admin);
    // The last 30 days, which the seed data covers.
    String day(DateTime d) => d.toIso8601String().substring(0, 10);
    final now = DateTime.now();
    final range = 'from=${day(now.subtract(const Duration(days: 30)))}&to=${day(now)}';
    await save('report_sites', '/reports/sites?$range', admin);
    await save('report_staff', '/reports/staff?$range', admin);
    await save('report_engineers', '/reports/engineers?$range', admin);
    await save('report_payments', '/reports/payments?$range', admin);

    final engineer = await signIn('+919000000011', 'Engineer@123');
    await save('dashboard_engineer', '/dashboard/engineer', engineer);
    await save('me_engineer', '/me', engineer);
    await save('report_sites_engineer', '/reports/sites?$range', engineer);

    final staff = await signIn('+919000000101', 'Staff@123');
    await save('staff_today', '/me/today', staff);
    await save('me_staff', '/me', staff);
  } finally {
    http.close();
  }
}
