import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../../../core/widgets/search_field.dart';
import '../data/vehicles_repository.dart';
import 'vehicle_widgets.dart';

/// The company's vehicles and who has each one (admins).
class VehiclesScreen extends ConsumerStatefulWidget {
  const VehiclesScreen({super.key});

  @override
  ConsumerState<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends ConsumerState<VehiclesScreen> {
  VehicleFilter? _filter;
  var _search = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.vehicles));
    final repository = ref.watch(vehiclesRepositoryProvider);
    String label(VehicleFilter? filter) => switch (filter) {
      null => l10n.commonAll,
      VehicleFilter.given => l10n.vehiclesFilterGiven,
      VehicleFilter.free => l10n.vehiclesFilterFree,
      VehicleFilter.inactive => l10n.vehicleOutOfUse,
    };
    return Scaffold(
      appBar: AppBar(title: Text(l10n.vehiclesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.adminVehicleNew),
        icon: const Icon(Icons.add),
        label: Text(l10n.vehicleNewTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
            child: SearchField(hint: l10n.vehiclesSearch, onChanged: (value) => setState(() => _search = value)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Row(
              children: [
                for (final filter in [null, ...VehicleFilter.values])
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: ChoiceChip(
                      label: Text(label(filter)),
                      selected: _filter == filter,
                      onSelected: (_) => setState(() => _filter = filter),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: PagedListView(
              key: ValueKey('vehicles-$revision-$_filter-$_search'),
              fetch: (page) => repository.list(page: page, filter: _filter, search: _search),
              itemBuilder: (context, vehicle) => VehicleTile(vehicle: vehicle),
              empty: EmptyList(icon: Icons.two_wheeler, message: l10n.vehiclesEmpty),
            ),
          ),
        ],
      ),
    );
  }
}
