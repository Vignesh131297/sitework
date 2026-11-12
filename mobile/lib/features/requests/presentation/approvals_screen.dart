import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../../vehicles/data/vehicles_repository.dart';
import '../../vehicles/presentation/vehicle_widgets.dart';
import '../data/requests_repository.dart';
import 'request_widgets.dart';

/// Leave and staff money and food requests for admins and engineers to decide,
/// and for admins the repair money asked for company vehicles: what is waiting
/// for them first, or everything they may see.
class ApprovalsScreen extends ConsumerWidget {
  const ApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(sessionProvider).value?.role;
    final engineer = role == UserRole.engineer;
    final admin = role == UserRole.admin;
    final area = ref.watch(areaPathProvider);
    return DefaultTabController(
      length: admin ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.approvalsTitle),
          actions: [
            // Engineers ask for their own leave here too.
            if (engineer)
              IconButton(
                tooltip: l10n.myLeaveTitle,
                onPressed: () => context.push(AppRoutes.myRequests(area)),
                icon: const Icon(Icons.event_busy_outlined),
              ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.requestsTabLeave),
              Tab(text: l10n.requestsTabMoneyFood),
              if (admin) Tab(text: l10n.requestsTabRepair),
            ],
          ),
        ),
        body: TabBarView(children: [const _Leave(), const _MoneyFood(), if (admin) const _Repair()]),
      ),
    );
  }
}

enum _Filter { waiting, approved, all }

/// Waiting (for the caller), approved, or everything.
class _Filters extends StatelessWidget {
  const _Filters({required this.selected, required this.onSelected});

  final _Filter selected;
  final ValueChanged<_Filter> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String label(_Filter filter) => switch (filter) {
      _Filter.waiting => l10n.approvalsWaitingForYou,
      _Filter.approved => ApprovalStatus.approved.label(l10n),
      _Filter.all => l10n.commonAll,
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          for (final filter in _Filter.values)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ChoiceChip(
                label: Text(label(filter)),
                selected: selected == filter,
                onSelected: (_) => onSelected(filter),
              ),
            ),
        ],
      ),
    );
  }
}

class _Leave extends ConsumerStatefulWidget {
  const _Leave();

  @override
  ConsumerState<_Leave> createState() => _LeaveState();
}

class _LeaveState extends ConsumerState<_Leave> {
  var _filter = _Filter.waiting;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.requests));
    final repository = ref.watch(requestsRepositoryProvider);
    return Column(
      children: [
        _Filters(selected: _filter, onSelected: (filter) => setState(() => _filter = filter)),
        Expanded(
          child: PagedListView(
            key: ValueKey('approvals-leave-$revision-$_filter'),
            fetch: (page) => repository.leave(
              page: page,
              toReview: _filter == _Filter.waiting,
              status: _filter == _Filter.approved ? ApprovalStatus.approved : null,
            ),
            itemBuilder: (context, leave) => LeaveTile(leave: leave),
            empty: EmptyList(icon: Icons.event_available_outlined, message: l10n.approvalsEmpty),
          ),
        ),
      ],
    );
  }
}

class _MoneyFood extends ConsumerStatefulWidget {
  const _MoneyFood();

  @override
  ConsumerState<_MoneyFood> createState() => _MoneyFoodState();
}

class _MoneyFoodState extends ConsumerState<_MoneyFood> {
  var _filter = _Filter.waiting;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.requests));
    final repository = ref.watch(requestsRepositoryProvider);
    return Column(
      children: [
        _Filters(selected: _filter, onSelected: (filter) => setState(() => _filter = filter)),
        Expanded(
          child: PagedListView(
            key: ValueKey('approvals-staff-requests-$revision-$_filter'),
            fetch: (page) => repository.staffRequests(
              page: page,
              toReview: _filter == _Filter.waiting,
              status: _filter == _Filter.approved ? ApprovalStatus.approved : null,
            ),
            itemBuilder: (context, request) => StaffRequestTile(request: request),
            empty: EmptyList(icon: Icons.receipt_long_outlined, message: l10n.approvalsEmpty),
          ),
        ),
      ],
    );
  }
}

/// Money asked for the repair of a company vehicle (admins decide).
class _Repair extends ConsumerStatefulWidget {
  const _Repair();

  @override
  ConsumerState<_Repair> createState() => _RepairState();
}

class _RepairState extends ConsumerState<_Repair> {
  var _filter = _Filter.waiting;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.vehicles));
    final repository = ref.watch(vehiclesRepositoryProvider);
    return Column(
      children: [
        _Filters(selected: _filter, onSelected: (filter) => setState(() => _filter = filter)),
        Expanded(
          child: PagedListView(
            key: ValueKey('approvals-repair-$revision-$_filter'),
            fetch: (page) => repository.repairRequests(
              page: page,
              toReview: _filter == _Filter.waiting,
              status: _filter == _Filter.approved ? ApprovalStatus.approved : null,
            ),
            itemBuilder: (context, request) => RepairRequestTile(request: request),
            empty: EmptyList(icon: Icons.build_outlined, message: l10n.approvalsEmpty),
          ),
        ),
      ],
    );
  }
}
