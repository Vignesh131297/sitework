import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../../../core/widgets/profile_action.dart';
import '../../../core/widgets/search_field.dart';
import '../../clients/presentation/clients_list.dart';
import '../data/sites_repository.dart';
import 'site_card.dart';

/// Admin "Sites" tab: sites and clients.
class SitesScreen extends StatefulWidget {
  const SitesScreen({super.key});

  @override
  State<SitesScreen> createState() => _SitesScreenState();
}

class _SitesScreenState extends State<SitesScreen> with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 2, vsync: this)..addListener(() => setState(() {}));

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onSites = _tabs.index == 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navSites),
        actions: const [ProfileAction()],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.sitesTitle),
            Tab(text: l10n.clientsTitle),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(onSites ? AppRoutes.adminSiteNew : AppRoutes.adminClientNew),
        icon: const Icon(Icons.add),
        label: Text(onSites ? l10n.siteNew : l10n.clientNew),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          SitesList(onOpen: (id) => context.push(AppRoutes.adminSite(id))),
          const ClientsList(),
        ],
      ),
    );
  }
}

/// Searchable, filterable list of sites (admin: all; engineer: their own).
class SitesList extends ConsumerStatefulWidget {
  const SitesList({super.key, required this.onOpen});

  final ValueChanged<String> onOpen;

  @override
  ConsumerState<SitesList> createState() => _SitesListState();
}

class _SitesListState extends ConsumerState<SitesList> {
  var _search = '';
  SiteStatus? _status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.sites));
    final repository = ref.watch(sitesRepositoryProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
          child: SearchField(hint: l10n.sitesSearch, onChanged: (value) => setState(() => _search = value)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Row(
            children: [
              for (final status in <SiteStatus?>[null, ...SiteStatus.values])
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(status?.label(l10n) ?? l10n.commonAll),
                    selected: _status == status,
                    onSelected: (_) => setState(() => _status = status),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: PagedListView(
            key: ValueKey('sites-$revision-$_search-$_status'),
            fetch: (page) => repository.list(page: page, search: _search, status: _status),
            itemBuilder: (context, site) => SiteCard(site: site, onTap: () => widget.onOpen(site.id)),
            empty: EmptyList(icon: Icons.apartment_outlined, message: l10n.sitesEmpty),
          ),
        ),
      ],
    );
  }
}
