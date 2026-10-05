import 'package:material_ui/material_ui.dart';

import '../l10n/generated/app_localizations.dart';
import 'location_service.dart';

extension LocationProblemMessage on LocationProblem {
  String message(AppLocalizations l10n) => switch (this) {
    LocationProblem.serviceOff => l10n.locationServiceOff,
    LocationProblem.permissionDenied => l10n.locationPermissionDenied,
    LocationProblem.permissionDeniedForever => l10n.locationPermissionForever,
    LocationProblem.noFix => l10n.locationNoFix,
  };

  /// Whether the user can fix this in system settings.
  bool get hasSettings => this != LocationProblem.noFix && this != LocationProblem.permissionDenied;
}

/// Asks for precise location, with a shortcut to the app's settings.
void showApproximateLocation(BuildContext context, LocationService service) {
  final l10n = AppLocalizations.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(l10n.locationApproximate),
      action: SnackBarAction(label: l10n.commonOpenSettings, onPressed: service.openAppSettings),
    ),
  );
}

/// Explains [problem] in a snack bar, with a shortcut to the right settings page.
void showLocationProblem(BuildContext context, LocationService service, LocationProblem problem) {
  final l10n = AppLocalizations.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(problem.message(l10n)),
      action: problem.hasSettings
          ? SnackBarAction(label: l10n.commonOpenSettings, onPressed: () => service.openSettingsFor(problem))
          : null,
    ),
  );
}
