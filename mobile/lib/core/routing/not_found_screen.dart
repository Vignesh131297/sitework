import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../widgets/empty_state.dart';
import 'app_routes.dart';

/// Shown for a path no route matches, such as an old or mistyped link.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: EmptyState(
        icon: Icons.link_off,
        title: l10n.notFoundTitle,
        message: l10n.notFoundMessage,
        // The splash route sends signed-in users to their home and everyone else to sign-in.
        action: FilledButton(onPressed: () => context.go(AppRoutes.splash), child: Text(l10n.notFoundGoHome)),
      ),
    );
  }
}
