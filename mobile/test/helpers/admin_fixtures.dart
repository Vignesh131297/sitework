import 'package:sitework/features/auth/domain/app_session.dart';
import 'package:sitework/features/auth/domain/auth_models.dart';
import 'package:sitework/features/auth/domain/user_role.dart';

import 'fake_api.dart';
import 'fake_auth_repository.dart';

// API answers shaped exactly like the server's JSON, for admin screen tests.

FakeAuthRepository signedInAdmin() => FakeAuthRepository(
  saved: const StoredSession(
    tokens: AuthTokens(accessToken: 'a', refreshToken: 'r'),
    user: AppSession(userId: 'admin-1', name: 'Admin User', role: UserRole.admin),
  ),
);

const abc = {'id': 'site-1', 'name': 'ABC Apartment Project'};
const arun = {'id': 'eng-1', 'name': 'Arun Kumar'};
const prakash = {'id': 'eng-2', 'name': 'Prakash'};

Map<String, Object?> dayTotals({int expected = 9, int submitted = 5, int missing = 2}) => {
  'expected': expected,
  'submitted': submitted,
  'missing': missing,
  'pending': 1,
  'upcoming': 1,
  'notCheckedIn': 1,
};

Map<String, Object?> dashboardJson() => {
  'date': '2026-10-05',
  'isWorkingDay': true,
  'holiday': null,
  'counts': {'activeSites': 2, 'clients': 2, 'engineers': 2, 'staff': 5},
  'payments': {
    'contract': '5000000.00',
    'received': '2450000.00',
    'pending': '2550000.00',
    'overdue': '300000.00',
    'overdueCount': 1,
  },
  'updates': dayTotals(),
  'issues': {'open': 3, 'critical': 1},
  'attention': [
    {
      'type': 'MISSING_UPDATES',
      'site': abc,
      'count': 2,
      'staffNames': ['Ravi', 'Kumar'],
    },
    {
      'type': 'OVERDUE_PAYMENT',
      'site': abc,
      'milestone': {'id': 'm-1', 'title': 'Foundation'},
      'outstanding': '300000.00',
      'dueDate': '2026-09-30',
    },
    {'type': 'SOMETHING_NEWER', 'site': abc},
  ],
  'sites': [
    {
      'site': {'id': 'site-1', 'code': 'SITE-001', 'name': 'ABC Apartment Project', 'status': 'IN_PROGRESS'},
      'engineers': ['Arun Kumar'],
      'staffCount': 3,
      'updates': dayTotals(),
      'lastActivityAt': '2026-10-05T05:12:00.000Z',
    },
  ],
};

Map<String, Object?> siteSummaryJson({
  String id = 'site-1',
  String code = 'SITE-001',
  String name = 'ABC Apartment Project',
  String status = 'IN_PROGRESS',
  List<Map<String, Object?>> engineers = const [arun],
  int staffCount = 1,
}) => {
  'id': id,
  'code': code,
  'name': name,
  'status': status,
  'progressPercent': 40,
  'address': 'Anna Nagar, Chennai',
  'client': {'id': 'client-1', 'name': 'Mr. Rajesh'},
  'engineers': engineers,
  'staffCount': staffCount,
  'startDate': '2026-06-01',
  'expectedCompletionDate': '2027-03-31',
  'contractAmount': '2500000.00',
};

Map<String, Object?> siteDetailJson({
  String id = 'site-1',
  String name = 'ABC Apartment Project',
  List<Map<String, Object?>> engineers = const [arun],
  List<Map<String, Object?>>? staff,
}) => {
  ...siteSummaryJson(id: id, name: name, engineers: engineers),
  'client': {'id': 'client-1', 'name': 'Mr. Rajesh', 'phone': '+919800000001', 'email': null},
  'contactName': 'Suresh',
  'contactPhone': '+919800000002',
  'latitude': 13.0850,
  'longitude': 80.2101,
  'geofenceRadiusM': 300,
  'staff':
      staff ??
      [
        {'id': 'staff-1', 'name': 'Ravi', 'phone': '+919000000101', 'designation': 'MASON', 'engineer': arun},
      ],
  'financials': {
    'contract': '2500000.00',
    'received': '1000000.00',
    'pending': '1500000.00',
    'overdue': '300000.00',
    'overdueCount': 1,
    'milestones': [
      {
        'id': 'm-1',
        'title': 'Foundation',
        'amount': '500000.00',
        'dueDate': '2026-09-30',
        'paid': '200000.00',
        'outstanding': '300000.00',
        'status': 'OVERDUE',
      },
    ],
  },
  'openIssues': 2,
};

Map<String, Object?> clientJson() => {
  'id': 'client-1',
  'name': 'Mr. Rajesh',
  'company': 'Rajesh Builders',
  'phone': '+919800000001',
  'email': 'rajesh@example.com',
  'address': 'T Nagar',
  'notes': null,
  'siteCount': 1,
};

Map<String, Object?> personJson({
  String id = 'staff-1',
  String role = 'STAFF',
  String name = 'Ravi',
  bool isActive = true,
  bool assigned = true,
}) => {
  'id': id,
  'role': role,
  'name': name,
  'phone': '+919000000101',
  'email': null,
  'employeeCode': role == 'STAFF' ? 'STF-001' : 'ENG-001',
  'designation': role == 'STAFF' ? 'MASON' : null,
  'joiningDate': '2026-01-10',
  'isActive': isActive,
  'lastLoginAt': null,
  'sites': role == 'ENGINEER'
      ? [
          {'id': 'site-1', 'code': 'SITE-001', 'name': 'ABC Apartment Project', 'address': 'Anna Nagar'},
        ]
      : <Object?>[],
  'staffCount': role == 'ENGINEER' ? 1 : 0,
  'assignment': role == 'STAFF' && assigned
      ? {
          'site': {'id': 'site-1', 'code': 'SITE-001', 'name': 'ABC Apartment Project', 'address': 'Anna Nagar'},
          'engineer': {'id': 'eng-1', 'name': 'Arun Kumar', 'phone': '+919000000011'},
        }
      : null,
};

Map<String, Object?> personDetailJson({
  String id = 'staff-1',
  String role = 'STAFF',
  String name = 'Ravi',
  bool isActive = true,
  bool assigned = true,
}) => {
  ...personJson(id: id, role: role, name: name, isActive: isActive, assigned: assigned),
  'mustChangePassword': false,
  'supervisedStaff': role == 'ENGINEER'
      ? [
          {'id': 'staff-1', 'name': 'Ravi', 'designation': 'MASON', 'site': abc},
        ]
      : <Object?>[],
};

Map<String, Object?> boardSlot(String slot, String state, {String? updateId, bool reviewed = false}) => {
  'slot': slot,
  'state': state,
  'start': '2026-10-05T04:30:00.000Z',
  'end': '2026-10-05T06:30:00.000Z',
  'closesAt': '2026-10-05T06:45:00.000Z',
  'update': updateId == null
      ? null
      : {
          'id': updateId,
          'submittedAt': '2026-10-05T05:12:00.000Z',
          'submittedOffline': false,
          'imageStatus': 'AVAILABLE',
          'engineerViewedAt': reviewed ? '2026-10-05T05:30:00.000Z' : null,
          'adminViewedAt': null,
        },
};

/// A site's staff board: Ravi sent the Morning update; Kumar hasn't checked in.
Map<String, Object?> siteDayJson() => {
  'date': '2026-10-05',
  'isWorkingDay': true,
  'holiday': null,
  'staff': [
    {
      'staff': {'id': 'staff-1', 'name': 'Ravi', 'phone': '+919000000101', 'designation': 'MASON'},
      'site': abc,
      'engineer': arun,
      'attendance': {'status': 'PRESENT', 'checkInAt': '2026-10-05T03:35:00.000Z', 'checkOutAt': null},
      'notCheckedIn': false,
      'slots': [
        boardSlot('MORNING', 'SUBMITTED', updateId: 'upd-1'),
        boardSlot('AFTERNOON', 'PENDING'),
        boardSlot('EVENING', 'UPCOMING'),
      ],
    },
    {
      'staff': {'id': 'staff-2', 'name': 'Kumar', 'phone': '+919000000102', 'designation': 'HELPER'},
      'site': abc,
      'engineer': arun,
      'attendance': null,
      'notCheckedIn': true,
      'slots': [
        boardSlot('MORNING', 'NOT_EXPECTED'),
        boardSlot('AFTERNOON', 'PENDING'),
        boardSlot('EVENING', 'UPCOMING'),
      ],
    },
  ],
};

/// The read-only answers every admin screen needs.
FakeApi adminApi() => FakeApi()
  ..on('GET', '/dashboard/admin', (_) => dashboardJson())
  ..on(
    'GET',
    '/sites',
    (_) => FakePage([siteSummaryJson(), siteSummaryJson(id: 'site-2', code: 'SITE-002', name: 'Green Villa')]),
  )
  ..on('GET', '/sites/:id', (r) => siteDetailJson(id: r.params['id']!))
  ..on('GET', '/sites/:id/day', (_) => siteDayJson())
  ..on('GET', '/clients', (_) => FakePage([clientJson()]))
  ..on(
    'GET',
    '/clients/:id',
    (_) => {
      ...clientJson(),
      'sites': [
        {
          'id': 'site-1',
          'code': 'SITE-001',
          'name': 'ABC Apartment Project',
          'status': 'IN_PROGRESS',
          'contractAmount': '2500000.00',
        },
      ],
    },
  )
  ..on(
    'GET',
    '/engineers',
    (_) => FakePage([
      personJson(id: 'eng-1', role: 'ENGINEER', name: 'Arun Kumar'),
      personJson(id: 'eng-2', role: 'ENGINEER', name: 'Prakash'),
    ]),
  )
  ..on('GET', '/engineers/:id', (r) => personDetailJson(id: r.params['id']!, role: 'ENGINEER', name: 'Arun Kumar'))
  ..on('GET', '/staff', (_) => FakePage([personJson()]))
  ..on('GET', '/staff/:id', (r) => personDetailJson(id: r.params['id']!));
