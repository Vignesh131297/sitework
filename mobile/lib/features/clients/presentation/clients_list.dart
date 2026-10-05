import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/initials.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../../../core/widgets/search_field.dart';
import '../data/clients_repository.dart';

/// Searchable list of clients (admin "Sites" tab, second page).
class ClientsList extends ConsumerStatefulWidget {
  const ClientsList({super.key});

  @override
  ConsumerState<ClientsList> createState() => _ClientsListState();
}

class _ClientsListState extends ConsumerState<ClientsList> {
  var _search = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.clients)) + ref.watch(revisionProvider(DataSet.sites));
    final repository = ref.watch(clientsRepositoryProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
          child: SearchField(hint: l10n.clientsSearch, onChanged: (value) => setState(() => _search = value)),
        ),
        Expanded(
          child: PagedListView(
            key: ValueKey('clients-$revision-$_search'),
            fetch: (page) => repository.list(page: page, search: _search),
            itemBuilder: (context, client) => Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: CircleAvatar(child: Text(initialsOf(client.name))),
                title: Text(client.name),
                subtitle: Text([?client.company, client.phone].join(' · ')),
                trailing: Text(l10n.siteCount(client.siteCount)),
                onTap: () => context.push(AppRoutes.adminClient(client.id)),
              ),
            ),
            empty: EmptyList(icon: Icons.business_outlined, message: l10n.clientsEmpty),
          ),
        ),
      ],
    );
  }
}
