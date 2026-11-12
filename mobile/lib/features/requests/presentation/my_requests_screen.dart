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
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../../stock/data/material_requests_repository.dart';
import '../../stock/presentation/request_widgets.dart';
import '../../vehicles/data/vehicles_repository.dart';
import '../../vehicles/presentation/vehicle_widgets.dart';
import '../data/requests_repository.dart';
import 'request_widgets.dart';

/// The tabs of [MyRequestsScreen], also used in links (`?tab=money`).
enum MyRequestsTab {
  leave,
  money,
  material,
  repair;

  /// The tab a link's `?tab=` value opens, if any.
  static MyRequestsTab? fromName(String? name) => values.where((tab) => tab.name == name).firstOrNull;
}

/// The caller's own requests. Staff: leave, money and food, material for their
/// site, and repair money for their company vehicle, with "New request" to ask
/// for any of them. Engineers: their leave and their repair money.
class MyRequestsScreen extends ConsumerWidget {
  const MyRequestsScreen({super.key, this.initialTab});

  final MyRequestsTab? initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final staff = ref.watch(sessionProvider).value?.role == UserRole.staff;
    if (!staff) {
      return DefaultTabController(
        length: 2,
        initialIndex: initialTab == MyRequestsTab.repair ? 1 : 0,
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.requestsMyTitle),
            bottom: TabBar(
              tabs: [
                Tab(text: l10n.requestsTabLeave),
                Tab(text: l10n.requestsTabRepair),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push(AppRoutes.leaveNew(ref.read(areaPathProvider))),
            icon: const Icon(Icons.event_busy_outlined),
            label: Text(l10n.leaveNewTitle),
          ),
          body: const TabBarView(children: [_LeaveList(), _RepairList()]),
        ),
      );
    }
    return DefaultTabController(
      length: MyRequestsTab.values.length,
      initialIndex: (initialTab ?? MyRequestsTab.leave).index,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.requestsMyTitle),
          bottom: TabBar(
            // Four tabs don't fit a small phone side by side.
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.requestsTabLeave),
              Tab(text: l10n.requestsTabMoneyFood),
              Tab(text: l10n.requestsTabMaterial),
              Tab(text: l10n.requestsTabRepair),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showNewRequestSheet(context, ref.read(areaPathProvider)),
          icon: const Icon(Icons.add),
          label: Text(l10n.requestsNew),
        ),
        body: const TabBarView(children: [_LeaveList(), _MoneyFoodList(), _MaterialList(), _RepairList()]),
      ),
    );
  }
}

/// Leave, money, food, material or bike repair: opens the form for the chosen one.
Future<void> showNewRequestSheet(BuildContext context, String area) {
  final l10n = AppLocalizations.of(context);
  void open(String path) {
    Navigator.of(context).pop();
    context.push(path);
  }

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.requestsChooseKind, style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.event_busy_outlined),
            title: Text(l10n.requestKindLeave),
            subtitle: Text(l10n.requestKindLeaveHint),
            onTap: () => open(AppRoutes.leaveNew(area)),
          ),
          ListTile(
            leading: const Icon(Icons.currency_rupee),
            title: Text(l10n.requestKindMoney),
            subtitle: Text(l10n.requestKindMoneyHint),
            onTap: () => open(AppRoutes.staffRequestNew(area, StaffRequestKind.money)),
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_outlined),
            title: Text(l10n.requestKindFood),
            subtitle: Text(l10n.requestKindFoodHint),
            onTap: () => open(AppRoutes.staffRequestNew(area, StaffRequestKind.food)),
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: Text(l10n.requestKindMaterial),
            subtitle: Text(l10n.requestKindMaterialHint),
            onTap: () => open(AppRoutes.requestNew(area)),
          ),
          ListTile(
            leading: const Icon(Icons.build_outlined),
            title: Text(l10n.requestKindRepair),
            subtitle: Text(l10n.requestKindRepairHint),
            onTap: () => open(AppRoutes.repairRequestNew(area)),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    ),
  );
}

class _LeaveList extends ConsumerWidget {
  const _LeaveList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.requests));
    final repository = ref.watch(requestsRepositoryProvider);
    return PagedListView(
      key: ValueKey('my-leave-$revision'),
      fetch: (page) => repository.leave(page: page, mine: true),
      itemBuilder: (context, leave) => LeaveTile(leave: leave),
      empty: EmptyList(icon: Icons.event_available_outlined, message: l10n.leaveEmpty),
    );
  }
}

class _MoneyFoodList extends ConsumerWidget {
  const _MoneyFoodList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.requests));
    final repository = ref.watch(requestsRepositoryProvider);
    return PagedListView(
      key: ValueKey('my-staff-requests-$revision'),
      fetch: (page) => repository.staffRequests(page: page),
      itemBuilder: (context, request) => StaffRequestTile(request: request),
      empty: EmptyList(icon: Icons.receipt_long_outlined, message: l10n.staffRequestsEmpty),
    );
  }
}

/// Material requests the staff member made (the API shows staff only their own).
class _MaterialList extends ConsumerWidget {
  const _MaterialList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.stock));
    final repository = ref.watch(materialRequestsRepositoryProvider);
    return PagedListView(
      key: ValueKey('my-material-requests-$revision'),
      fetch: (page) => repository.list(page: page),
      itemBuilder: (context, request) => RequestTile(request: request),
      empty: EmptyList(icon: Icons.assignment_outlined, message: l10n.requestsEmpty),
    );
  }
}

/// Repair money the caller asked for, for a company vehicle they hold or held.
class _RepairList extends ConsumerWidget {
  const _RepairList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.vehicles));
    final repository = ref.watch(vehiclesRepositoryProvider);
    return PagedListView(
      key: ValueKey('my-repair-requests-$revision'),
      fetch: (page) => repository.repairRequests(page: page, mine: true),
      itemBuilder: (context, request) => RepairRequestTile(request: request),
      empty: EmptyList(icon: Icons.build_outlined, message: l10n.vehicleRepairsEmpty),
    );
  }
}
