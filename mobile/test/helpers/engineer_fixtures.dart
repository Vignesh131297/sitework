import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:sitework/core/network/image_loader.dart';
import 'package:sitework/features/auth/domain/app_session.dart';
import 'package:sitework/features/auth/domain/auth_models.dart';
import 'package:sitework/features/auth/domain/user_role.dart';

import 'admin_fixtures.dart';
import 'fake_api.dart';
import 'fake_auth_repository.dart';
import 'staff_fixtures.dart';

// API answers shaped like the server's JSON, for engineer screens.

FakeAuthRepository signedInEngineer() => FakeAuthRepository(
  saved: const StoredSession(
    tokens: AuthTokens(accessToken: 'a', refreshToken: 'r'),
    user: AppSession(userId: 'eng-1', name: 'Arun Kumar', role: UserRole.engineer),
  ),
);

Map<String, Object?> engineerDashboardJson() => {
  'date': '2026-10-05',
  'isWorkingDay': true,
  'holiday': null,
  'updates': dayTotals(expected: 3, submitted: 1, missing: 0),
  'toReview': 1,
  'issues': {'open': 1, 'critical': 0},
  'attention': [
    {
      'type': 'NOT_CHECKED_IN',
      'site': abc,
      'count': 1,
      'staffNames': ['Kumar'],
    },
  ],
  'sites': [
    {
      'site': {'id': 'site-1', 'code': 'SITE-001', 'name': 'ABC Apartment Project', 'status': 'IN_PROGRESS'},
      'engineers': ['Arun Kumar'],
      'staffCount': 2,
      'updates': dayTotals(expected: 3, submitted: 1, missing: 0),
      'lastActivityAt': '2026-10-05T05:12:00.000Z',
    },
  ],
};

Map<String, Object?> engineerUpdateJson({String id = 'eu-1', String? adminViewedAt}) => {
  'id': id,
  'type': 'PROGRESS',
  'priority': 'MEDIUM',
  'title': null,
  'description': 'Slab concreting done',
  'progressPercent': 55,
  'site': abc,
  'engineer': arun,
  'createdAt': '2026-10-05T07:00:00.000Z',
  'adminViewedAt': adminViewedAt,
  'attachmentCount': 1,
  'attachments': [
    {
      'id': 'att-1',
      'mime': 'image/jpeg',
      'url': '/files/abc?expires=1&signature=x',
      'expiresAt': '2026-10-05T08:00:00.000Z',
    },
  ],
};

Map<String, Object?> issueJson({String status = 'OPEN', String? note}) => {
  'id': 'iss-1',
  'title': 'Seepage in basement',
  'description': 'North wall after rain',
  'priority': 'HIGH',
  'status': status,
  'site': abc,
  'reportedBy': {'id': 'eng-1', 'name': 'Arun Kumar', 'role': 'ENGINEER'},
  'createdAt': '2026-10-05T06:00:00.000Z',
  'resolvedAt': status == 'RESOLVED' ? '2026-10-05T10:00:00.000Z' : null,
  'resolvedBy': status == 'RESOLVED' ? arun : null,
  'resolutionNote': note,
  'attachmentCount': 0,
  'attachments': <Object?>[],
};

/// Everything an engineer's screens read, with a world that changes as they act.
class EngineerWorld {
  EngineerWorld() {
    api
      ..on('GET', '/dashboard/engineer', (_) => engineerDashboardJson())
      ..on('GET', '/sites', (_) => FakePage([siteSummaryJson()]))
      ..on('GET', '/sites/:id', (r) => {...siteDetailJson(id: r.params['id']!), 'financials': null})
      ..on('GET', '/sites/:id/day', (_) => siteDayJson())
      ..on('GET', '/staff-updates', (_) => FakePage([staffUpdateJson()]))
      ..on('GET', '/staff-updates/:id', (_) => staffUpdateJson())
      ..on('GET', '/staff-updates/:id/image', (_) {
        if (photoDeleted) throw const FakeApiError(410, 'IMAGE_DELETED', 'This photo has been deleted.');
        return {'url': '/files/photo?expires=1&signature=x', 'expiresAt': '2026-10-05T05:30:00.000Z'};
      })
      ..on('POST', '/staff-updates/:id/views', (_) => staffUpdateJson())
      ..on('GET', '/engineer-updates', (_) => FakePage([engineerUpdateJson()]))
      ..on('GET', '/engineer-updates/:id', (_) => engineerUpdateJson())
      ..on('POST', '/engineer-updates', (_) => engineerUpdateJson(id: 'eu-2'))
      ..on('POST', '/engineer-updates/:id/views', (_) => engineerUpdateJson(adminViewedAt: '2026-10-05T08:00:00.000Z'))
      ..on('GET', '/issues', (_) => FakePage([issueJson(status: issueStatus)]))
      ..on('POST', '/issues', (_) => issueJson())
      ..on('GET', '/issues/:id', (_) => issueJson(status: issueStatus, note: resolutionNote))
      ..on('PATCH', '/issues/:id', (r) {
        issueStatus = r.json['status'] as String;
        resolutionNote = r.json['resolutionNote'] as String?;
        return issueJson(status: issueStatus, note: resolutionNote);
      })
      ..on('GET', '/notifications/unread-count', (_) => {'count': 0});
  }

  final api = FakeApi();
  var photoDeleted = false;
  var issueStatus = 'OPEN';
  String? resolutionNote;
}

/// Serves a tiny PNG for every photo link, without a network.
class FakeImageLoader extends ImageLoader {
  FakeImageLoader() : super(Dio(), 'http://api.test/api/v1');

  final requested = <String>[];

  @override
  Future<Uint8List> bytes(String url) async {
    requested.add(url);
    return Uint8List.fromList(tinyPhoto().readAsBytesSync());
  }
}
