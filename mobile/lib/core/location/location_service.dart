import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// Why a location could not be read. Callers explain this to the user;
/// they never invent coordinates (spec §32).
enum LocationProblem { serviceOff, permissionDenied, permissionDeniedForever, noFix }

class LocationFix {
  const LocationFix({
    required this.latitude,
    required this.longitude,
    required this.accuracyM,
    required this.isMocked,
    this.approximate = false,
  });

  final double latitude;
  final double longitude;
  final double accuracyM;

  /// True when Android reports a mock-location app as the source.
  final bool isMocked;

  /// The user allowed only approximate location (Android 12+): the fix can be
  /// kilometres off, so the server will likely mark it as away from the site.
  final bool approximate;
}

class LocationResult {
  const LocationResult.fix(LocationFix this.fix) : problem = null;
  const LocationResult.problem(LocationProblem this.problem) : fix = null;

  final LocationFix? fix;
  final LocationProblem? problem;
}

extension LocationResultFields on LocationResult {
  /// What check-in and update requests send: the fix, or why there is none.
  Map<String, Object> toApiFields() {
    final fix = this.fix;
    if (fix != null) {
      return {
        'latitude': fix.latitude,
        'longitude': fix.longitude,
        'accuracyM': double.parse(fix.accuracyM.toStringAsFixed(1)),
        'isMocked': fix.isMocked,
      };
    }
    final denied = problem == LocationProblem.permissionDenied || problem == LocationProblem.permissionDeniedForever;
    return {'locationProblem': denied ? 'PERMISSION_DENIED' : 'UNAVAILABLE'};
  }
}

class LocationService {
  /// One-shot position on Android (see CurrentLocationChannel.kt for why
  /// geolocator is used only for permissions there).
  static const _android = MethodChannel('com.sitework.app/location');

  /// Asks for permission if needed, then waits up to [timeout] for a GPS fix.
  Future<LocationResult> current({Duration timeout = const Duration(seconds: 10)}) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return const LocationResult.problem(LocationProblem.serviceOff);
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return const LocationResult.problem(LocationProblem.permissionDeniedForever);
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.unableToDetermine) {
      return const LocationResult.problem(LocationProblem.permissionDenied);
    }
    final approximate = await _isApproximate();
    try {
      if (Platform.isAndroid) return await _androidFix(timeout, approximate: approximate);
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high, timeLimit: timeout),
      );
      return LocationResult.fix(
        LocationFix(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracyM: position.accuracy,
          isMocked: position.isMocked,
          approximate: approximate,
        ),
      );
    } on TimeoutException {
      return const LocationResult.problem(LocationProblem.noFix);
    } on LocationServiceDisabledException {
      return const LocationResult.problem(LocationProblem.serviceOff);
    } on PermissionDeniedException {
      return const LocationResult.problem(LocationProblem.permissionDenied);
    }
  }

  Future<bool> _isApproximate() async {
    try {
      return await Geolocator.getLocationAccuracy() == LocationAccuracyStatus.reduced;
    } on Exception {
      return false; // Older systems have no approximate-only permission.
    }
  }

  Future<LocationResult> _androidFix(Duration timeout, {required bool approximate}) async {
    final fix = await _android
        .invokeMapMethod<String, Object?>('currentPosition', {'timeoutMs': timeout.inMilliseconds})
        // The platform answers by itself at [timeout]; this only guards against it never answering.
        .timeout(timeout + const Duration(seconds: 5));
    if (fix == null) return const LocationResult.problem(LocationProblem.noFix);
    return LocationResult.fix(
      LocationFix(
        latitude: fix['latitude']! as double,
        longitude: fix['longitude']! as double,
        accuracyM: fix['accuracyM']! as double,
        isMocked: fix['isMocked']! as bool,
        approximate: approximate,
      ),
    );
  }

  /// Where the user can fix [problem]: app settings or location settings.
  Future<bool> openSettingsFor(LocationProblem problem) =>
      problem == LocationProblem.serviceOff ? Geolocator.openLocationSettings() : openAppSettings();

  /// This app's settings page, where "Use precise location" is switched on.
  Future<bool> openAppSettings() => Geolocator.openAppSettings();
}

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());
