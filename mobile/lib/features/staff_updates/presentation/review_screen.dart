import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../data/staff_updates_repository.dart';
import 'update_tile.dart';

/// Staff photos the signed-in reviewer hasn't looked at yet, newest first.
class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.staffUpdates));
    final repository = ref.watch(staffUpdatesRepositoryProvider);
    final area = ref.watch(areaPathProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reviewTitle)),
      body: PagedListView(
        key: ValueKey('review-$revision'),
        fetch: (page) => repository.list(page: page, pendingReview: true),
        itemBuilder: (context, update) => UpdateTile(
          update: update,
          showStaff: true,
          onTap: () => context.push(AppRoutes.staffUpdate(area, update.id)),
        ),
        empty: EmptyList(icon: Icons.task_alt, message: l10n.reviewEmpty),
      ),
    );
  }
}
