import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../../auth/domain/user_role.dart';
import '../../sites/data/sites_repository.dart';
import '../../sites/domain/site_models.dart';
import '../../stock/data/stock_repository.dart';
import '../data/people_repository.dart';
import '../domain/person_models.dart';
import 'people_screen.dart';
import 'temporary_password_dialog.dart';

/// A new person (engineer, staff member, godown manager or admin), or edit
/// the one with [id].
class PersonFormScreen extends ConsumerWidget {
  const PersonFormScreen({super.key, required this.role, this.id});

  final UserRole role;
  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = this.id;
    final title = id == null
        ? newPersonLabel(role, l10n)
        : switch (role) {
            UserRole.staff => l10n.staffEdit,
            UserRole.engineer => l10n.engineerEdit,
            UserRole.godownManager => l10n.godownManagerEdit,
            UserRole.admin => l10n.adminEdit,
          };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: id == null
          ? _PersonForm(role: role)
          : AsyncValueView(
              value: ref.watch(personDetailProvider((role: role, id: id))),
              onRetry: () => ref.invalidate(personDetailProvider((role: role, id: id))),
              data: (person) => _PersonForm(role: role, initial: person),
            ),
    );
  }
}

class _PersonForm extends ConsumerStatefulWidget {
  const _PersonForm({required this.role, this.initial});

  final UserRole role;
  final PersonDetail? initial;

  @override
  ConsumerState<_PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends ConsumerState<_PersonForm> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _phone = TextEditingController(text: widget.initial?.phone);
  late final _email = TextEditingController(text: widget.initial?.email);
  late final _code = TextEditingController(text: widget.initial?.employeeCode);
  late String? _joiningDate = widget.initial?.joiningDate;
  late Designation? _designation = widget.initial?.designation;

  // Godown managers: the godowns they run (when creating or editing).
  late final _godownIds = {for (final g in widget.initial?.godowns ?? const <IdName>[]) g.id};

  // Only when creating: where the new person starts.
  final _siteIds = <String>{};
  String? _siteId;
  String? _engineerId;

  bool get _isStaff => widget.role == UserRole.staff;
  bool get _isManager => widget.role == UserRole.godownManager;
  bool get _creating => widget.initial == null;

  @override
  void dispose() {
    for (final controller in [_name, _phone, _email, _code]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final repository = ref.read(peopleRepositoryProvider);
    final code = textOrNull(_code);
    final body = <String, Object?>{
      'name': _name.text.trim(),
      'phone': _phone.text.trim(),
      'email': textOrNull(_email),
      'employeeCode': ?code,
      'joiningDate': _joiningDate,
      if (_isStaff) 'designation': _designation!.apiValue,
      if (_isManager) 'godownIds': _godownIds.toList(),
    };
    final initial = widget.initial;
    if (initial != null) {
      final saved = await runSubmit(() => repository.update(widget.role, initial.id, body));
      if (saved == null || !mounted) return;
      ref
        ..bump(DataSet.people)
        ..bump(DataSet.stock);
      showSnack(context, l10n.personSaved);
      context.pop();
      return;
    }

    if (_isStaff) {
      if (_siteId != null && _engineerId != null) body.addAll({'siteId': _siteId, 'engineerId': _engineerId});
    } else if (widget.role == UserRole.engineer) {
      body['siteIds'] = _siteIds.toList();
    }
    final created = await runSubmit(() => repository.create(widget.role, body));
    if (created == null || !mounted) return;
    ref
      ..bump(DataSet.people)
      ..bump(DataSet.sites)
      ..bump(DataSet.stock);
    await showTemporaryPasswordDialog(context, name: created.person.name, password: created.temporaryPassword);
    if (!mounted) return;
    context.pushReplacement(AppRoutes.adminPerson(personSegment(widget.role), created.person.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextFormField(
            controller: _name,
            decoration: InputDecoration(labelText: l10n.fieldName),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: requiredText(l10n),
          ),
          gap,
          TextFormField(
            controller: _phone,
            decoration: InputDecoration(labelText: l10n.fieldPhone, prefixIcon: const Icon(Icons.phone_outlined)),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: phoneValidator(l10n),
          ),
          gap,
          TextFormField(
            controller: _email,
            decoration: InputDecoration(labelText: l10n.fieldEmail, prefixIcon: const Icon(Icons.email_outlined)),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: emailValidator(l10n),
          ),
          gap,
          TextFormField(
            controller: _code,
            decoration: InputDecoration(
              labelText: l10n.fieldEmployeeCode,
              helperText: _creating ? l10n.fieldCodeHelper : null,
            ),
            textCapitalization: TextCapitalization.characters,
            validator: _creating ? null : requiredText(l10n),
          ),
          gap,
          DateField(
            label: l10n.fieldJoiningDate,
            initialValue: _joiningDate,
            clearable: true,
            onChanged: (value) => _joiningDate = value,
          ),
          if (_isStaff) ...[
            gap,
            DropdownButtonFormField<Designation>(
              isExpanded: true,
              initialValue: _designation,
              decoration: InputDecoration(labelText: l10n.fieldDesignation),
              items: [
                for (final designation in Designation.values)
                  DropdownMenuItem(value: designation, child: Text(designation.label(l10n))),
              ],
              validator: (value) => value == null ? l10n.validationRequired : null,
              onChanged: (value) => setState(() => _designation = value),
            ),
          ],
          if (_isManager)
            _GodownPicker(
              selected: _godownIds,
              onToggle: (id, on) => setState(() => on ? _godownIds.add(id) : _godownIds.remove(id)),
            ),
          if (_creating && (_isStaff || widget.role == UserRole.engineer))
            _isStaff
                ? _StartingSite(
                    siteId: _siteId,
                    engineerId: _engineerId,
                    onChanged: (siteId, engineerId) => setState(() {
                      _siteId = siteId;
                      _engineerId = engineerId;
                    }),
                  )
                : _StartingSites(
                    selected: _siteIds,
                    onToggle: (id, on) => setState(() => on ? _siteIds.add(id) : _siteIds.remove(id)),
                  ),
          if (submitError != null) ...[const SizedBox(height: AppSpacing.lg), InlineMessage(message: submitError!)],
          const SizedBox(height: AppSpacing.xl),
          SubmitButton(label: l10n.commonSave, busy: submitting, onPressed: _save),
        ],
      ),
    );
  }
}

/// Godown manager: the godowns they run (open ones).
class _GodownPicker extends ConsumerWidget {
  const _GodownPicker({required this.selected, required this.onToggle});

  final Set<String> selected;
  final void Function(String id, bool on) onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.personGodowns, style: theme.textTheme.titleSmall),
        Text(l10n.personGodownsHelper, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView(
          value: ref.watch(stockOverviewProvider),
          onRetry: () => ref.invalidate(stockOverviewProvider),
          data: (overview) => Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final g in overview.godowns)
                if (g.godown.isActive)
                  FilterChip(
                    label: Text(g.godown.name),
                    selected: selected.contains(g.godown.id),
                    onSelected: (on) => onToggle(g.godown.id, on),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

/// New engineer: any number of sites to start on.
class _StartingSites extends ConsumerWidget {
  const _StartingSites({required this.selected, required this.onToggle});

  final Set<String> selected;
  final void Function(String id, bool on) onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.personSites, style: theme.textTheme.titleSmall),
        Text(l10n.personInitialSitesHelper, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView(
          value: ref.watch(sitePickerProvider),
          onRetry: () => ref.invalidate(sitePickerProvider),
          data: (sites) => Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final site in sites)
                FilterChip(
                  label: Text(site.name),
                  selected: selected.contains(site.id),
                  onSelected: (on) => onToggle(site.id, on),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// New staff member: optionally a site and the engineer they report to.
class _StartingSite extends ConsumerWidget {
  const _StartingSite({required this.siteId, required this.engineerId, required this.onChanged});

  final String? siteId;
  final String? engineerId;
  final void Function(String? siteId, String? engineerId) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.personInitialAssignment, style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView(
          value: ref.watch(sitePickerProvider),
          onRetry: () => ref.invalidate(sitePickerProvider),
          data: (sites) {
            final SiteSummary? site = sites.where((s) => s.id == siteId).firstOrNull;
            final engineers = site?.engineers ?? const [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: site?.id ?? '',
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l10n.fieldSite),
                  items: [
                    DropdownMenuItem(value: '', child: Text(l10n.commonNone)),
                    for (final s in sites)
                      DropdownMenuItem(
                        value: s.id,
                        child: Text(s.name, overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: (value) {
                    final chosen = sites.where((s) => s.id == value).firstOrNull;
                    // A site with one engineer needs no second choice.
                    final only = chosen != null && chosen.engineers.length == 1 ? chosen.engineers.single.id : null;
                    onChanged(chosen?.id, only);
                  },
                ),
                if (site != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  if (engineers.isEmpty)
                    InlineMessage(message: l10n.assignNoEngineers)
                  else
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      key: ValueKey('engineer-${site.id}'),
                      initialValue: engineerId,
                      decoration: InputDecoration(labelText: l10n.fieldEngineer),
                      items: [for (final e in engineers) DropdownMenuItem(value: e.id, child: Text(e.name))],
                      validator: (value) => value == null ? l10n.validationRequired : null,
                      onChanged: (value) => onChanged(site.id, value),
                    ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
