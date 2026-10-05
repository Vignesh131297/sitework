import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../data/staff_updates_repository.dart';
import 'update_tile.dart';

/// Staff "History": every update they have sent, newest first.
class StaffHistoryScreen extends ConsumerWidget {
  const StaffHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.staffUpdates));
    final repository = ref.watch(staffUpdatesRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: PagedListView(
        key: ValueKey('history-$revision'),
        fetch: (page) => repository.list(page: page),
        itemBuilder: (context, update) => UpdateTile(update: update),
        empty: EmptyList(icon: Icons.history, message: l10n.historyEmpty),
      ),
    );
  }
}
