import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../../../core/widgets/profile_action.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/material_requests_repository.dart';
import 'request_widgets.dart';

enum _Filter { open, pending, approved, closed, all }

/// Material requests: what sites asked for and where each one is. Admins
/// approve here, engineers ask for their sites, godown managers find what to
/// send. [siteId] keeps one site's requests.
class RequestsScreen extends ConsumerStatefulWidget {
  const RequestsScreen({super.key, this.siteId, this.showProfileAction = false});

  final String? siteId;

  /// On a tab (godown managers), the app bar opens the profile.
  final bool showProfileAction;

  @override
  ConsumerState<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends ConsumerState<RequestsScreen> {
  var _filter = _Filter.open;

  String _label(_Filter filter, AppLocalizations l10n) => switch (filter) {
    _Filter.open => l10n.requestFilterOpen,
    _Filter.pending => l10n.requestStagePending,
    _Filter.approved => l10n.requestFilterApproved,
    _Filter.closed => l10n.requestStageClosed,
    _Filter.all => l10n.commonAll,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(sessionProvider).value?.role;
    final area = ref.watch(areaPathProvider);
    final revision = ref.watch(revisionProvider(DataSet.stock));
    final repository = ref.watch(materialRequestsRepositoryProvider);
    // Godown managers see requests once approved; only sites and admins ask.
    final manager = role == UserRole.godownManager;
    final filters = [
      for (final filter in _Filter.values)
        if (!manager || filter != _Filter.pending) filter,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.requestsTitle), actions: [if (widget.showProfileAction) const ProfileAction()]),
      floatingActionButton: manager
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.requestNew(area, siteId: widget.siteId)),
              icon: const Icon(Icons.add_shopping_cart),
              label: Text(l10n.requestNew),
            ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Row(
              children: [
                for (final filter in filters)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: ChoiceChip(
                      label: Text(_label(filter, l10n)),
                      selected: _filter == filter,
                      onSelected: (_) => setState(() => _filter = filter),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: PagedListView(
              key: ValueKey('requests-$revision-$_filter-${widget.siteId}'),
              fetch: (page) => repository.list(
                page: page,
                siteId: widget.siteId,
                open: _filter == _Filter.open,
                status: switch (_filter) {
                  _Filter.pending => MaterialRequestStatus.pending,
                  _Filter.approved => MaterialRequestStatus.approved,
                  _Filter.closed => MaterialRequestStatus.closed,
                  _Filter.open || _Filter.all => null,
                },
              ),
              itemBuilder: (context, request) => RequestTile(request: request),
              empty: EmptyList(
                icon: Icons.assignment_outlined,
                message: manager ? l10n.requestsEmptyManager : l10n.requestsEmpty,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
