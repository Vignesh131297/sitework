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
    await save('report_stock', '/reports/stock?$range', admin);

    // Stock: godowns, a site's and a godown's stock, entries and a material.
    await save('stock_overview', '/stock/overview', admin);
    final overview = (await call('GET', '/stock/overview', token: admin))['data'] as Map<String, dynamic>;
    String firstId(String list, String field) =>
        (((overview[list] as List<dynamic>).first as Map<String, dynamic>)[field] as Map<String, dynamic>)['id']
            as String;
    await save('godown_stock', '/stock/godowns/${firstId('godowns', 'godown')}', admin);
    await save('material_detail', '/materials/${firstId('materials', 'material')}', admin);
    await save('site_stock', '/sites/$siteId/stock', admin);
    final entryId = await save('stock_entries', '/stock/entries?limit=5', admin);
    await save('stock_entry_detail', '/stock/entries/$entryId', admin);

    // Material requests: the list, and one approved request with its deliveries.
    await save('material_requests', '/material-requests?limit=10', admin);
    final approved =
        (((await call('GET', '/material-requests?status=APPROVED&limit=5', token: admin))['data'] as List<dynamic>)
                .first
            as Map<String, dynamic>)['id'];
    await save('material_request_detail', '/material-requests/$approved', admin);

    // Godown managers and admins.
    final managerId = await save('godown_managers', '/godown-managers?limit=5', admin);
    await save('godown_manager_detail', '/godown-managers/$managerId', admin);
    await save('admins', '/admins?limit=5', admin);

    // Sign-up is closed once an admin exists (no token needed).
    await save('signup_status', '/auth/signup', admin);

    final engineer = await signIn('+919000000011', 'Engineer@123');
    await save('dashboard_engineer', '/dashboard/engineer', engineer);
    await save('me_engineer', '/me', engineer);
    await save('report_sites_engineer', '/reports/sites?$range', engineer);
    await save('report_stock_engineer', '/reports/stock?$range', engineer);
    await save('stock_overview_engineer', '/stock/overview', engineer);

    final staff = await signIn('+919000000101', 'Staff@123');
    await save('staff_today', '/me/today', staff);
    await save('me_staff', '/me', staff);
    final today = (await call('GET', '/me/today', token: staff))['data'] as Map<String, dynamic>;
    final staffSite = ((today['assignment'] as Map<String, dynamic>)['site'] as Map<String, dynamic>)['id'];
    await save('site_stock_staff', '/sites/$staffSite/stock', staff);

    final manager = await signIn('+919000000201', 'Godown@123');
    await save('dashboard_godown', '/dashboard/godown', manager);
    await save('me_godown_manager', '/me', manager);
    await save('stock_overview_godown', '/stock/overview', manager);
    await save('material_requests_godown', '/material-requests?limit=10', manager);
  } finally {
    http.close();
  }
}
