import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/refs.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../../sites/data/sites_repository.dart';
import '../data/people_repository.dart';

/// A site and the engineers a staff member there can report to.
typedef SiteTeam = ({String id, String name, List<IdName> engineers});

/// Puts a staff member on a site under one of the site's engineers. From a
/// person's profile pass [staff]; from a site's Team tab pass [site].
/// Resolves to true once saved.
Future<bool> showAssignStaffSheet(
  BuildContext context, {
  IdName? staff,
  SiteTeam? site,
  String? currentSiteId,
  String? currentEngineerId,
}) async {
  assert(staff != null || site != null, 'Fix the person or the site');
  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) =>
        _AssignStaffSheet(staff: staff, site: site, currentSiteId: currentSiteId, currentEngineerId: currentEngineerId),
  );
  return saved ?? false;
}

class _AssignStaffSheet extends ConsumerStatefulWidget {
  const _AssignStaffSheet({this.staff, this.site, this.currentSiteId, this.currentEngineerId});

  final IdName? staff;
  final SiteTeam? site;
  final String? currentSiteId;
  final String? currentEngineerId;

  @override
  ConsumerState<_AssignStaffSheet> createState() => _AssignStaffSheetState();
}

class _AssignStaffSheetState extends ConsumerState<_AssignStaffSheet> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  late IdName? _staff = widget.staff;
  late String? _siteId = widget.site?.id ?? widget.currentSiteId;
  late String? _engineerId = widget.currentEngineerId;

  Future<void> _save(SiteTeam site) async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final staff = _staff!;
    final messenger = ScaffoldMessenger.of(context);
    final done = await runSubmit(
      () => ref.read(peopleRepositoryProvider).assignStaff(staff.id, siteId: site.id, engineerId: _engineerId!),
    );
    if (done == null || !mounted) return;
    ref
      ..bump(DataSet.people)
      ..bump(DataSet.sites);
    Navigator.of(context).pop(true);
    messenger.showSnackBar(SnackBar(content: Text(l10n.staffAssigned(staff.name, site.name))));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final fixedSite = widget.site;
    final title = widget.staff != null ? l10n.assignTitle(widget.staff!.name) : l10n.assignStaffToSite(fixedSite!.name);

    Widget form(List<SiteTeam> sites) {
      final site = sites.where((s) => s.id == _siteId).firstOrNull;
      final engineers = site?.engineers ?? const <IdName>[];
      // Keep the chosen engineer only if they work on the chosen site.
      if (!engineers.any((e) => e.id == _engineerId)) {
        _engineerId = engineers.length == 1 ? engineers.single.id : null;
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.staff == null) ...[
            _StaffField(selected: _staff, onChanged: (staff) => setState(() => _staff = staff)),
            const SizedBox(height: AppSpacing.md),
          ],
          if (fixedSite == null) ...[
            DropdownButtonFormField<String>(
              initialValue: site?.id,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.fieldSite),
              items: [
                for (final s in sites)
                  DropdownMenuItem(
                    value: s.id,
                    child: Text(s.name, overflow: TextOverflow.ellipsis),
                  ),
              ],
              validator: (value) => value == null ? l10n.validationRequired : null,
              onChanged: (value) => setState(() => _siteId = value),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          if (site != null && engineers.isEmpty)
            InlineMessage(message: l10n.assignNoEngineers, tone: StatusTone.warning)
          else
            DropdownButtonFormField<String>(
              // Rebuilt per site so the choices and the selection always match.
              key: ValueKey('engineer-${site?.id}'),
              initialValue: _engineerId,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.fieldEngineer),
              items: [for (final e in engineers) DropdownMenuItem(value: e.id, child: Text(e.name))],
              validator: (value) => value == null ? l10n.validationRequired : null,
              onChanged: (value) => setState(() => _engineerId = value),
            ),
          if (submitError != null) ...[const SizedBox(height: AppSpacing.md), InlineMessage(message: submitError!)],
          const SizedBox(height: AppSpacing.lg),
          SubmitButton(
            label: l10n.assignSave,
            busy: submitting,
            onPressed: site == null || engineers.isEmpty || _staff == null ? null : () => _save(site),
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.lg),
              if (fixedSite != null)
                form([fixedSite])
              else
                AsyncValueView(
                  value: ref.watch(sitePickerProvider),
                  onRetry: () => ref.invalidate(sitePickerProvider),
                  data: (sites) => form([for (final s in sites) (id: s.id, name: s.name, engineers: s.engineers)]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Picks an active staff member who isn't on any site yet.
class _StaffField extends ConsumerWidget {
  const _StaffField({required this.selected, required this.onChanged});

  final IdName? selected;
  final ValueChanged<IdName?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AsyncValueView(
      value: ref.watch(unassignedStaffProvider),
      onRetry: () => ref.invalidate(unassignedStaffProvider),
      data: (people) {
        if (people.isEmpty) return InlineMessage(message: l10n.assignNoUnassignedStaff, tone: StatusTone.info);
        return DropdownButtonFormField<String>(
          initialValue: selected?.id,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.fieldStaffMember),
          items: [
            for (final person in people)
              DropdownMenuItem(value: person.id, child: Text('${person.name} · ${person.employeeCode}')),
          ],
          validator: (value) => value == null ? l10n.validationRequired : null,
          onChanged: (id) {
            final person = people.where((p) => p.id == id).firstOrNull;
            onChanged(person == null ? null : IdName(id: person.id, name: person.name));
          },
        );
      },
    );
  }
}
