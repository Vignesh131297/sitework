import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:sitework/core/location/location_service.dart';
import 'package:sitework/features/auth/domain/app_session.dart';
import 'package:sitework/features/auth/domain/auth_models.dart';
import 'package:sitework/features/auth/domain/user_role.dart';

import 'fake_auth_repository.dart';

// API answers shaped like the server's JSON, for staff screens and the queue.

FakeAuthRepository signedInStaff() => FakeAuthRepository(
  saved: const StoredSession(
    tokens: AuthTokens(accessToken: 'a', refreshToken: 'r'),
    user: AppSession(userId: 'staff-1', name: 'Ravi Kumar', role: UserRole.staff),
  ),
);

Map<String, Object?> attendanceJson({String status = 'PRESENT', String? checkOutAt}) => {
  'id': 'att-1',
  'workDate': '2026-10-05',
  'status': status,
  'staff': {'id': 'staff-1', 'name': 'Ravi Kumar'},
  'site': {'id': 'site-1', 'name': 'ABC Apartment Project'},
  'checkInAt': '2026-10-05T03:35:00.000Z',
  'checkInLocationFlag': 'OK',
  'checkOutAt': checkOutAt,
  'checkOutLocationFlag': checkOutAt == null ? null : 'OK',
  'workedMinutes': checkOutAt == null ? null : 540,
  'correctionNote': null,
};

Map<String, Object?> _slot(String slot, String state, String start, String end, {Map<String, Object?>? update}) => {
  'slot': slot,
  'state': state,
  'start': '2026-10-05T$start:00.000Z',
  'end': '2026-10-05T$end:00.000Z',
  'closesAt': '2026-10-05T$end:00.000Z',
  'update': update,
};

/// Monday 5 Oct 2026, 10:30 IST: Morning is open.
Map<String, Object?> todayJson({bool checkedIn = false, String morning = 'PENDING', bool assigned = true}) => {
  'serverTime': '2026-10-05T05:00:00.000Z',
  'date': '2026-10-05',
  'isWorkingDay': true,
  'holiday': null,
  'assignment': assigned
      ? {
          'site': {
            'id': 'site-1',
            'code': 'SITE-001',
            'name': 'ABC Apartment Project',
            'address': 'Anna Nagar, Chennai',
            'latitude': 13.0878,
            'longitude': 80.2008,
            'geofenceRadiusM': 300,
          },
          'engineer': {'id': 'eng-1', 'name': 'Arun Kumar', 'phone': '+919000000011'},
        }
      : null,
  'attendance': checkedIn ? attendanceJson() : null,
  'slots': [
    _slot(
      'MORNING',
      morning,
      '04:30',
      '06:30',
      update: morning == 'SUBMITTED'
          ? {'id': 'upd-1', 'submittedAt': '2026-10-05T05:12:00.000Z', 'submittedOffline': false}
          : null,
    ),
    _slot('AFTERNOON', 'UPCOMING', '07:30', '09:30'),
    _slot('EVENING', 'UPCOMING', '10:30', '13:30'),
  ],
  'rules': {
    'requireCheckIn': true,
    'allowGallery': true,
    'locationRequired': true,
    'fixTimeoutSeconds': 10,
    'maxUploadMb': 5,
    'offlineAcceptanceMinutes': 180,
    'defaultGeofenceRadiusM': 300,
  },
};

Map<String, Object?> staffUpdateJson({
  String id = 'upd-1',
  String slot = 'MORNING',
  String imageStatus = 'AVAILABLE',
}) => {
  'id': id,
  'workDate': '2026-10-05',
  'slot': slot,
  'description': 'Plastering the first floor',
  'staff': {'id': 'staff-1', 'name': 'Ravi Kumar', 'designation': 'MASON'},
  'site': {'id': 'site-1', 'name': 'ABC Apartment Project'},
  'engineer': {'id': 'eng-1', 'name': 'Arun Kumar'},
  'submittedAt': '2026-10-05T05:12:00.000Z',
  'capturedAt': '2026-10-05T05:11:30.000Z',
  'submittedOffline': false,
  'location': {'flag': 'OK', 'distanceFromSiteM': 12},
  'photoSource': 'CAMERA',
  'image': {
    'status': imageStatus,
    'expiresAt': '2026-10-06T05:12:00.000Z',
    'deletedAt': imageStatus == 'DELETED' ? '2026-10-05T06:00:00.000Z' : null,
    'deleteReason': imageStatus == 'DELETED' ? 'ALL_VIEWED' : null,
  },
  'engineerViewedAt': null,
  'adminViewedAt': null,
};

/// A smallest-possible valid PNG, written to a fresh temp folder.
File tinyPhoto() {
  final dir = Directory.systemTemp.createTempSync('sitework-photo-');
  return File('${dir.path}${Platform.pathSeparator}photo.jpg')..writeAsBytesSync(_png);
}

const _png = [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, //
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
];

/// Answers with a fixed result instead of asking the phone's GPS.
class FakeLocationService extends LocationService {
  FakeLocationService([this.result = onSite]);

  static const onSite = LocationResult.fix(
    LocationFix(latitude: 13.0879, longitude: 80.2009, accuracyM: 12, isMocked: false),
  );

  LocationResult result;

  @override
  Future<LocationResult> current({Duration timeout = const Duration(seconds: 10)}) async => result;
}

/// "Takes" [photo] whenever the camera or gallery is opened.
class FakeImagePicker extends ImagePicker {
  FakeImagePicker(this.photo);

  final File photo;
  final sources = <ImageSource>[];

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    sources.add(source);
    return XFile(photo.path);
  }
}
