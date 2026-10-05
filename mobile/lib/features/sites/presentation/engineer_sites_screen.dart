import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/profile_action.dart';
import 'sites_screen.dart';

/// Engineer "Sites": the sites they are assigned to.
class EngineerSitesScreen extends ConsumerWidget {
  const EngineerSitesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSites), actions: const [ProfileAction()]),
      body: SitesList(onOpen: (id) => context.push(AppRoutes.site(AppRoutes.engineerArea, id))),
    );
  }
}
