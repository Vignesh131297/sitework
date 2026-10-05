import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/auth/presentation/session_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../utils/initials.dart';

/// App-bar avatar that opens the profile (Admin and Engineer keep Profile out
/// of the bottom bar, which holds at most five tabs).
class ProfileAction extends ConsumerWidget {
  const ProfileAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider).value;
    if (session == null) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        tooltip: AppLocalizations.of(context).navProfile,
        onPressed: () => context.push(session.role.profilePath),
        icon: CircleAvatar(
          radius: 18,
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: Text(initialsOf(session.name)),
        ),
      ),
    );
  }
}
