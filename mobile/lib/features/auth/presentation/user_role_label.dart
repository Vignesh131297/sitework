import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/user_role.dart';

extension UserRoleLabel on UserRole {
  String label(AppLocalizations l10n) => switch (this) {
    UserRole.admin => l10n.roleAdmin,
    UserRole.engineer => l10n.roleEngineer,
    UserRole.staff => l10n.roleStaff,
    UserRole.godownManager => l10n.roleGodownManager,
  };
}
