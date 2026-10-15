import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/initials.dart';
import '../../../core/utils/launch.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/submit_state.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../../engineer_updates/presentation/engineer_updates_list.dart';
import '../../issues/presentation/issues_list.dart';
import '../../people/presentation/assign_staff_sheet.dart';
import '../../stock/presentation/site_stock_tab.dart';
import '../data/sites_repository.dart';
import '../domain/site_models.dart';
import 'engineer_picker.dart';
import 'site_day_tab.dart';
import 'site_payments_tab.dart';

/// The site's tabs, by the name used in links (`?tab=today`).
const siteTabs = ['today', 'overview', 'team', 'updates', 'issues', 'stock', 'payments'];

/// One site: today's staff board, overview, team, engineer updates, issues,
/// stock and money. Admins can edit; engineers report updates and issues and
/// look after the site's stock.
class SiteDetailScreen extends ConsumerWidget {
  const SiteDetailScreen({super.key, required this.id, this.initialTab});

  final String id;
  final String? initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(sessionProvider).value?.role;
    final isAdmin = role == UserRole.admin;
    final area = ref.watch(areaPathProvider);
    final site = ref.watch(siteDetailProvider(id));
    final initialIndex = siteTabs.indexOf(initialTab ?? 'today');
    return DefaultTabController(
      length: siteTabs.length,
      initialIndex: initialIndex < 0 ? 0 : initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text(site.value?.name ?? ''),
          actions: [
            if (isAdmin)
              IconButton(
                tooltip: l10n.siteEdit,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push(AppRoutes.adminSiteEdit(id)),
              ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.siteTabToday),
              Tab(text: l10n.siteTabOverview),
              Tab(text: l10n.siteTabTeam),
              Tab(text: l10n.siteTabUpdates),
              Tab(text: l10n.siteTabIssues),
              Tab(text: l10n.siteTabStock),
              Tab(text: l10n.siteTabPayments),
            ],
          ),
        ),
        body: AsyncValueView(
          value: site,
          onRetry: () => ref.invalidate(siteDetailProvider(id)),
          data: (site) => TabBarView(
            children: [
              SiteDayTab(siteId: id),
              _Refreshable(
                id: id,
                child: _OverviewTab(site: site, isAdmin: isAdmin),
              ),
              _Refreshable(
                id: id,
                child: _TeamTab(site: site, isAdmin: isAdmin),
              ),
              EngineerUpdatesList(
                siteId: id,
                header: role == UserRole.engineer
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: FilledButton.tonalIcon(
                          onPressed: () => context.push(AppRoutes.engineerUpdateNewFor(id)),
                          icon: const Icon(Icons.add),
                          label: Text(l10n.engineerUpdateNew),
                        ),
                      )
                    : null,
              ),
              IssuesList(
                siteId: id,
                action: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.tonalIcon(
                      onPressed: () => context.push(AppRoutes.issueNew(area, siteId: id)),
                      icon: const Icon(Icons.report_problem_outlined),
                      label: Text(l10n.issueNew),
                    ),
                  ),
                ),
              ),
              SiteStockTab(siteId: id, isAdmin: isAdmin),
              _Refreshable(
                id: id,
                child: SitePaymentsTab(site: site, isAdmin: isAdmin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Refreshable extends ConsumerWidget {
  const _Refreshable({required this.id, required this.child});

  final String id;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      RefreshIndicator(onRefresh: () => ref.refresh(siteDetailProvider(id).future), child: child);
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.site, required this.isAdmin});

  final SiteDetail site;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final clientPhone = site.client.phone;
    final contactPhone = site.contactPhone;
    final latitude = site.latitude;
    final longitude = site.longitude;
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(site.code, style: theme.textTheme.titleMedium)),
                  StatusChip(label: site.status.label(l10n), tone: site.status.tone),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.siteProgress(site.progressPercent), style: theme.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: site.progressPercent / 100, minHeight: 8),
              ),
            ],
          ),
        ),
        DetailRow(
          icon: Icons.business_outlined,
          label: l10n.siteClient,
          value: site.client.name,
          onTap: isAdmin ? () => context.push(AppRoutes.adminClient(site.client.id)) : null,
          trailing: clientPhone == null ? null : _CallButton(phone: clientPhone),
        ),
        DetailRow(
          icon: Icons.person_outline,
          label: l10n.siteContact,
          value: [?site.contactName, ?contactPhone].join(' · ').ifEmpty(l10n.siteContactNone),
          trailing: contactPhone == null ? null : _CallButton(phone: contactPhone),
        ),
        DetailRow(icon: Icons.place_outlined, label: l10n.siteAddress, value: site.address),
        if (latitude != null && longitude != null)
          DetailRow(
            icon: Icons.my_location_outlined,
            label: l10n.siteLocation,
            value: [
              '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
              if (site.geofenceRadiusM != null) l10n.siteGeofence(site.geofenceRadiusM!),
            ].join('\n'),
            trailing: IconButton(
              tooltip: l10n.commonOpenMap,
              icon: const Icon(Icons.map_outlined),
              onPressed: () => openMap(latitude, longitude, label: site.name),
            ),
          )
        else if (isAdmin)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: InlineMessage(message: l10n.siteNoLocation, tone: StatusTone.warning),
          ),
        DetailRow(icon: Icons.event_outlined, label: l10n.siteStart, value: formatDate(site.startDate)),
        if (site.expectedCompletionDate != null)
          DetailRow(
            icon: Icons.flag_outlined,
            label: l10n.siteExpectedCompletion,
            value: formatDate(site.expectedCompletionDate!),
          ),
        if (site.contractAmount != null)
          DetailRow(icon: Icons.currency_rupee, label: l10n.paymentsContract, value: formatInr(site.contractAmount!)),
        DetailRow(
          icon: Icons.report_problem_outlined,
          label: l10n.navIssues,
          value: l10n.siteOpenIssues(site.openIssues),
        ),
      ],
    );
  }
}

class _TeamTab extends ConsumerWidget {
  const _TeamTab({required this.site, required this.isAdmin});

  final SiteDetail site;
  final bool isAdmin;

  Future<void> _changeEngineers(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final current = [for (final engineer in site.engineers) engineer.id];
    final chosen = await pickEngineers(context, selected: current);
    if (chosen == null || setEquals(chosen.toSet(), current.toSet()) || !context.mounted) return;
    try {
      await ref.read(sitesRepositoryProvider).setEngineers(site.id, chosen);
      if (!context.mounted) return;
      ref
        ..bump(DataSet.sites)
        ..bump(DataSet.people);
      showSnack(context, l10n.siteEngineersSaved);
    } on AppException catch (error) {
      if (context.mounted) showErrorSnack(context, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget note(String text) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(text, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
    );
    Widget header(String title, Widget? action) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: SectionHeader(title, trailing: action),
    );

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        header(
          l10n.siteEngineers,
          isAdmin
              ? TextButton(onPressed: () => _changeEngineers(context, ref), child: Text(l10n.siteManageEngineers))
              : null,
        ),
        if (site.engineers.isEmpty) note(l10n.siteNoEngineers),
        for (final engineer in site.engineers)
          ListTile(
            leading: CircleAvatar(child: Text(initialsOf(engineer.name))),
            title: Text(engineer.name),
            onTap: isAdmin ? () => context.push(AppRoutes.adminEngineer(engineer.id)) : null,
          ),
        header(
          l10n.siteStaff,
          isAdmin && site.status != SiteStatus.completed
              ? TextButton.icon(
                  onPressed: () =>
                      showAssignStaffSheet(context, site: (id: site.id, name: site.name, engineers: site.engineers)),
                  icon: const Icon(Icons.person_add_alt_outlined),
                  label: Text(l10n.siteAssignStaff),
                )
              : null,
        ),
        if (site.staff.isEmpty) note(l10n.siteNoStaff),
        for (final member in site.staff)
          ListTile(
            leading: CircleAvatar(child: Text(initialsOf(member.name))),
            title: Text(member.name),
            subtitle: Text(
              [?member.designation?.label(l10n), l10n.personSupervisedBy(member.engineer.name)].join(' · '),
            ),
            trailing: _CallButton(phone: member.phone),
            onTap: isAdmin ? () => context.push(AppRoutes.adminStaffMember(member.id)) : null,
          ),
      ],
    );
  }
}

class _CallButton extends StatelessWidget {
  const _CallButton({required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: AppLocalizations.of(context).commonCall,
    icon: const Icon(Icons.call_outlined),
    onPressed: () => callPhone(phone),
  );
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
