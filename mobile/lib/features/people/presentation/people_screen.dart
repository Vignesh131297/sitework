import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/initials.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../../../core/widgets/profile_action.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/domain/user_role.dart';
import '../data/people_repository.dart';
import '../domain/person_models.dart';

/// Admin "People" tab: engineers, staff, godown managers and admins.
class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> with SingleTickerProviderStateMixin {
  static const _roles = [UserRole.engineer, UserRole.staff, UserRole.godownManager, UserRole.admin];
  late final _tabs = TabController(length: _roles.length, vsync: this)..addListener(() => setState(() {}));

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = _roles[_tabs.index];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.peopleTitle),
        actions: const [ProfileAction()],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: l10n.engineersTitle),
            Tab(text: l10n.staffTitle),
            Tab(text: l10n.godownManagersTitle),
            Tab(text: l10n.adminsTitle),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.adminPersonNew(personSegment(role))),
        icon: const Icon(Icons.person_add_alt_outlined),
        label: Text(newPersonLabel(role, l10n)),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [for (final role in _roles) PeopleList(role: role)],
      ),
    );
  }
}

enum _StatusFilter { all, active, inactive, unassigned }

class PeopleList extends ConsumerStatefulWidget {
  const PeopleList({super.key, required this.role});

  final UserRole role;

  @override
  ConsumerState<PeopleList> createState() => _PeopleListState();
}

class _PeopleListState extends ConsumerState<PeopleList> {
  var _search = '';
  var _filter = _StatusFilter.all;
  Designation? _designation;

  bool get _isStaff => widget.role == UserRole.staff;

  String _filterLabel(_StatusFilter filter, AppLocalizations l10n) => switch (filter) {
    _StatusFilter.all => l10n.commonAll,
    _StatusFilter.active => l10n.filterActive,
    _StatusFilter.inactive => l10n.filterInactive,
    _StatusFilter.unassigned => l10n.filterUnassigned,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.people)) + ref.watch(revisionProvider(DataSet.sites));
    final repository = ref.watch(peopleRepositoryProvider);
    final filters = [
      _StatusFilter.all,
      _StatusFilter.active,
      _StatusFilter.inactive,
      if (_isStaff) _StatusFilter.unassigned,
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
          child: SearchField(hint: l10n.peopleSearch, onChanged: (value) => setState(() => _search = value)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Row(
            children: [
              for (final filter in filters)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(_filterLabel(filter, l10n)),
                    selected: _filter == filter,
                    onSelected: (_) => setState(() => _filter = filter),
                  ),
                ),
              if (_isStaff)
                // Values are API names; '' means all (a null value would count as cancel).
                PopupMenuButton<String>(
                  tooltip: l10n.filterDesignation,
                  onSelected: (value) =>
                      setState(() => _designation = Designation.values.where((d) => d.apiValue == value).firstOrNull),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: '', child: Text(l10n.commonAll)),
                    for (final designation in Designation.values)
                      PopupMenuItem(value: designation.apiValue, child: Text(designation.label(l10n))),
                  ],
                  child: Chip(
                    avatar: const Icon(Icons.filter_list, size: 18),
                    label: Text(_designation?.label(l10n) ?? l10n.filterDesignation),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: PagedListView(
            key: ValueKey('people-${widget.role.name}-$revision-$_search-$_filter-$_designation'),
            fetch: (page) => repository.list(
              widget.role,
              page: page,
              search: _search,
              active: switch (_filter) {
                _StatusFilter.active => true,
                _StatusFilter.inactive => false,
                _StatusFilter.all || _StatusFilter.unassigned => null,
              },
              unassignedOnly: _filter == _StatusFilter.unassigned,
              designation: _designation,
            ),
            itemBuilder: (context, person) => PersonCard(person: person),
            empty: EmptyList(
              icon: Icons.groups_outlined,
              message: switch (widget.role) {
                UserRole.staff => l10n.staffEmpty,
                UserRole.engineer => l10n.engineersEmpty,
                UserRole.godownManager => l10n.godownManagersEmpty,
                UserRole.admin => l10n.adminsEmpty,
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// "New engineer", "New godown manager"…
String newPersonLabel(UserRole role, AppLocalizations l10n) => switch (role) {
  UserRole.engineer => l10n.engineerNew,
  UserRole.staff => l10n.staffNew,
  UserRole.godownManager => l10n.godownManagerNew,
  UserRole.admin => l10n.adminNew,
};

class PersonCard extends StatelessWidget {
  const PersonCard({super.key, required this.person});

  final PersonSummary person;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = person;
    final details = switch (p.role) {
      UserRole.staff => [
        p.employeeCode,
        ?p.designation?.label(l10n),
        p.assignment?.site.name ?? l10n.personNotAssigned,
      ],
      UserRole.engineer => [p.employeeCode, l10n.siteCount(p.sites.length), l10n.staffCount(p.staffCount)],
      UserRole.godownManager => [
        p.employeeCode,
        if (p.godowns.isEmpty) l10n.personNoGodowns else p.godowns.map((g) => g.name).join(', '),
      ],
      UserRole.admin => [p.employeeCode, ?p.email],
    };
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: p.isActive ? null : theme.colorScheme.surfaceContainerHighest,
          child: Text(initialsOf(p.name)),
        ),
        title: Text(p.name),
        subtitle: Text(details.join(' · ')),
        trailing: p.isActive ? null : StatusChip(label: l10n.commonInactive, tone: StatusTone.neutral),
        onTap: () => context.push(AppRoutes.adminPerson(personSegment(p.role), p.id)),
      ),
    );
  }
}
