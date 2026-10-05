import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/widgets/profile_action.dart';
import 'issues_list.dart';

/// All issues the caller may see: the engineer's tab, or the admin's list.
class IssuesScreen extends ConsumerWidget {
  const IssuesScreen({super.key, this.showProfileAction = false});

  final bool showProfileAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final area = ref.watch(areaPathProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.issuesTitle), actions: [if (showProfileAction) const ProfileAction()]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.issueNew(area)),
        icon: const Icon(Icons.add),
        label: Text(l10n.issueNew),
      ),
      body: const IssuesList(),
    );
  }
}
