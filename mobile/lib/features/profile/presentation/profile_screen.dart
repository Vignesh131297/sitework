import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/error_messages.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/initials.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/inline_message.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/domain/auth_models.dart';
import '../../auth/presentation/session_controller.dart';
import '../../auth/presentation/user_role_label.dart';
import '../../system/presentation/server_status.dart';

final meProvider = FutureProvider.autoDispose<MeProfile>((ref) => ref.watch(authRepositoryProvider).fetchProfile());

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.profileSignOutConfirmTitle,
      message: l10n.profileSignOutConfirmBody,
      confirmLabel: l10n.profileSignOut,
      destructive: true,
    );
    // The router returns to the sign-in screen once the session is cleared.
    if (confirmed) await ref.read(sessionProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider).value;
    if (session == null) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(meProvider.future),
        child: ListView(
          padding: AppSpacing.screen,
          children: [
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  child: Text(initialsOf(session.name)),
                ),
                title: Text(session.name, style: theme.textTheme.titleMedium),
                subtitle: Text(session.role.label(l10n)),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const _ProfileDetails(),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.changePassword),
              icon: const Icon(Icons.password),
              label: Text(l10n.profileChangePassword),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () => _signOut(context, ref),
              icon: const Icon(Icons.logout),
              label: Text(l10n.profileSignOut),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.profileServerSection, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: ServerStatus()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetails extends ConsumerWidget {
  const _ProfileDetails();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(meProvider)
        .when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InlineMessage(message: error is AppException ? error.userMessage(l10n) : l10n.errorUnexpected),
              TextButton.icon(
                onPressed: () => ref.invalidate(meProvider),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.commonRetry),
              ),
            ],
          ),
          data: (me) => Card(
            child: Column(
              children: [
                _DetailTile(icon: Icons.phone_outlined, label: l10n.profilePhone, value: me.phone),
                if (me.email != null) _DetailTile(icon: Icons.mail_outline, label: l10n.profileEmail, value: me.email!),
                _DetailTile(icon: Icons.badge_outlined, label: l10n.profileEmployeeId, value: me.employeeCode),
                if (me.assignment case final assignment?) ...[
                  _DetailTile(
                    icon: Icons.apartment_outlined,
                    label: l10n.profileSite,
                    value: assignment.site.name,
                    detail: assignment.site.address,
                  ),
                  _DetailTile(
                    icon: Icons.engineering_outlined,
                    label: l10n.profileEngineer,
                    value: assignment.engineer.name,
                    detail: assignment.engineer.phone,
                  ),
                ],
                if (me.sites.isNotEmpty)
                  _DetailTile(
                    icon: Icons.apartment_outlined,
                    label: l10n.profileSites,
                    value: me.sites.map((site) => site.name).join('\n'),
                  ),
              ],
            ),
          ),
        );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({required this.icon, required this.label, required this.value, this.detail});

  final IconData icon;
  final String label;
  final String value;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon),
      title: Text(label, style: theme.textTheme.labelMedium),
      subtitle: Text(detail == null ? value : '$value\n$detail', style: theme.textTheme.bodyLarge),
    );
  }
}
