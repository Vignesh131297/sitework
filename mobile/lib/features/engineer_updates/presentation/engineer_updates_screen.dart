import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/profile_action.dart';
import 'engineer_updates_list.dart';

/// Engineer "Updates": what they have reported to the admin.
class EngineerUpdatesScreen extends StatelessWidget {
  const EngineerUpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.engineerUpdatesTitle), actions: const [ProfileAction()]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.engineerUpdateNew),
        icon: const Icon(Icons.add),
        label: Text(l10n.engineerUpdateNew),
      ),
      body: const EngineerUpdatesList(),
    );
  }
}
