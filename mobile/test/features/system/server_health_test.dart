import 'package:flutter_test/flutter_test.dart';
import 'package:sitework/features/system/domain/server_health.dart';

void main() {
  test('parses the /health payload, ignoring fields the app does not use', () {
    final health = ServerHealth.fromJson({
      'status': 'ok',
      'database': 'up',
      'environment': 'development',
      'version': '0.1.0',
      'serverTime': '2026-10-04T04:08:09.743Z',
      'timeZone': 'Asia/Kolkata',
      'businessDate': '2026-10-04',
    });

    expect(health.serverTime, DateTime.utc(2026, 10, 4, 4, 8, 9, 743));
    expect(health.timeZone, 'Asia/Kolkata');
    expect(health.businessDate, '2026-10-04');
  });
}
