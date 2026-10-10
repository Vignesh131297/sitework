import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/location/location_messages.dart';
import '../../../core/location/location_service.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../../clients/data/clients_repository.dart';
import '../../people/data/people_repository.dart';
import '../../stock/data/stock_repository.dart';
import '../../stock/domain/stock_models.dart';
import '../data/sites_repository.dart';
import '../domain/site_models.dart';
import 'engineer_picker.dart';

/// New site, or edit the site with [id].
class SiteFormScreen extends ConsumerWidget {
  const SiteFormScreen({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = this.id;
    return Scaffold(
      appBar: AppBar(title: Text(id == null ? l10n.siteNew : l10n.siteEdit)),
      body: id == null
          ? const _SiteForm()
          : AsyncValueView(
              value: ref.watch(siteDetailProvider(id)),
              onRetry: () => ref.invalidate(siteDetailProvider(id)),
              data: (site) => _SiteForm(initial: site),
            ),
    );
  }
}

class _SiteForm extends ConsumerStatefulWidget {
  const _SiteForm({this.initial});

  final SiteDetail? initial;

  @override
  ConsumerState<_SiteForm> createState() => _SiteFormState();
}

class _SiteFormState extends ConsumerState<_SiteForm> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  late final SiteDetail? _initial = widget.initial;
  late final _name = TextEditingController(text: _initial?.name);
  late final _code = TextEditingController(text: _initial?.code);
  late final _contactName = TextEditingController(text: _initial?.contactName);
  late final _contactPhone = TextEditingController(text: _initial?.contactPhone);
  late final _address = TextEditingController(text: _initial?.address);
  late final _contract = TextEditingController(text: _plainAmount(_initial?.contractAmount));
  late final _progress = TextEditingController(text: '${_initial?.progressPercent ?? 0}');
  late final _latitude = TextEditingController(text: _initial?.latitude?.toString());
  late final _longitude = TextEditingController(text: _initial?.longitude?.toString());
  late final _radius = TextEditingController(text: _initial?.geofenceRadiusM?.toString());
  late String? _clientId = _initial?.client.id;
  late String? _startDate = _initial?.startDate;
  late String? _completionDate = _initial?.expectedCompletionDate;
  late SiteStatus _status = _initial?.status ?? SiteStatus.notStarted;
  final _engineerIds = <String>[];
  var _locating = false;

  bool get _creating => _initial == null;

  /// "850000.00" → "850000" so the field shows what an admin would type.
  static String? _plainAmount(String? amount) =>
      amount == null ? null : (amount.endsWith('.00') ? amount.substring(0, amount.length - 3) : amount);

  @override
  void dispose() {
    for (final controller in [
      _name,
      _code,
      _contactName,
      _contactPhone,
      _address,
      _contract,
      _progress,
      _latitude,
      _longitude,
      _radius,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    final l10n = AppLocalizations.of(context);
    final service = ref.read(locationServiceProvider);
    setState(() => _locating = true);
    final result = await service.current(timeout: const Duration(seconds: 15));
    if (!mounted) return;
    setState(() => _locating = false);
    final fix = result.fix;
    if (fix == null) {
      showLocationProblem(context, service, result.problem!);
      return;
    }
    if (fix.isMocked) {
      // A site's position must be real: staff updates are checked against it.
      showSnack(context, l10n.locationMocked);
      return;
    }
    if (fix.approximate) {
      // Kilometres off: every staff update would look away from the site.
      showApproximateLocation(context, service);
      return;
    }
    setState(() {
      _latitude.text = fix.latitude.toStringAsFixed(6);
      _longitude.text = fix.longitude.toStringAsFixed(6);
    });
    showSnack(context, l10n.locationCaptured(fix.accuracyM.round()));
  }

  Future<void> _pickEngineers() async {
    final chosen = await pickEngineers(context, selected: _engineerIds);
    if (chosen != null) {
      setState(
        () => _engineerIds
          ..clear()
          ..addAll(chosen),
      );
    }
  }

  String? _coordinate(String? value, double limit) {
    final l10n = AppLocalizations.of(context);
    final hasLatitude = _latitude.text.trim().isNotEmpty;
    final hasLongitude = _longitude.text.trim().isNotEmpty;
    final text = value?.trim() ?? '';
    if (text.isEmpty) return hasLatitude != hasLongitude ? l10n.validationRequired : null;
    final number = double.tryParse(text);
    if (number == null) return l10n.validationNumber;
    return number.abs() > limit ? l10n.validationRange(-limit.toInt(), limit.toInt()) : null;
  }

  /// Completing a site that still holds stock: true to go ahead anyway. The
  /// stock stays on the books until someone returns or writes it off.
  Future<bool> _confirmStockLeft(String siteId) async {
    final l10n = AppLocalizations.of(context);
    final SiteStock stock;
    try {
      stock = await ref.read(stockRepositoryProvider).site(siteId);
    } on AppException {
      return true; // Can't check now; completing a site never loses stock.
    }
    final left = [
      for (final item in stock.items)
        if (item.hasStock) item,
    ];
    if (left.isEmpty && stock.arriving.isEmpty && stock.leaving.isEmpty) return true;
    if (!mounted) return false;
    final items = [
      for (final item in left.take(5)) '${item.material.name}: ${formatQuantity(item.onHand, item.material.unit)}',
    ];
    return showConfirmDialog(
      context,
      title: l10n.stockLeftTitle,
      message: [
        if (items.isNotEmpty) items.join('\n'),
        if (left.length > items.length) l10n.stockLeftMore(left.length - items.length),
        if (stock.arriving.isNotEmpty || stock.leaving.isNotEmpty) l10n.stockLeftOnTheWay,
        l10n.stockLeftBody,
      ].join('\n\n'),
      confirmLabel: l10n.stockLeftComplete,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final repository = ref.read(sitesRepositoryProvider);
    final code = textOrNull(_code);
    final radius = textOrNull(_radius);
    final body = <String, Object?>{
      'name': _name.text.trim(),
      'code': ?code,
      'clientId': _clientId,
      'contactName': textOrNull(_contactName),
      'contactPhone': textOrNull(_contactPhone),
      'address': _address.text.trim(),
      'latitude': double.tryParse(_latitude.text.trim()),
      'longitude': double.tryParse(_longitude.text.trim()),
      'geofenceRadiusM': radius == null ? null : int.parse(radius),
      'startDate': _startDate,
      'expectedCompletionDate': _completionDate,
      'contractAmount': _contract.text.trim(),
      'status': _status.apiValue,
      'progressPercent': int.parse(_progress.text.trim()),
      if (_creating) 'engineerIds': _engineerIds,
    };
    // Left empty on a new site, the server applies its default radius.
    if (_creating && radius == null) body.remove('geofenceRadiusM');
    final initial = _initial;
    if (initial != null &&
        initial.status != SiteStatus.completed &&
        _status == SiteStatus.completed &&
        !await _confirmStockLeft(initial.id)) {
      return;
    }
    if (!mounted) return;
    final saved = await runSubmit(
      () => initial == null ? repository.create(body) : repository.update(initial.id, body),
    );
    if (saved == null || !mounted) return;
    ref
      ..bump(DataSet.sites)
      ..bump(DataSet.clients)
      ..bump(DataSet.people)
      ..bump(DataSet.payments);
    showSnack(context, l10n.siteSaved);
    if (initial == null) {
      context.pushReplacement(AppRoutes.adminSite(saved.id));
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    final digitsOnly = [FilteringTextInputFormatter.digitsOnly];
    final coordinateFormat = [FilteringTextInputFormatter.allow(RegExp(r'^-?\d{0,3}(\.\d{0,8})?'))];
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextFormField(
            controller: _name,
            decoration: InputDecoration(labelText: l10n.fieldSiteName),
            textCapitalization: TextCapitalization.words,
            validator: requiredText(l10n),
          ),
          gap,
          TextFormField(
            controller: _code,
            decoration: InputDecoration(
              labelText: l10n.fieldSiteCode,
              helperText: _creating ? l10n.fieldCodeHelper : null,
            ),
            textCapitalization: TextCapitalization.characters,
            validator: _creating ? null : requiredText(l10n),
          ),
          gap,
          _ClientField(clientId: _clientId, onChanged: (id) => setState(() => _clientId = id)),
          gap,
          TextFormField(
            controller: _address,
            decoration: InputDecoration(labelText: l10n.fieldAddress),
            minLines: 2,
            maxLines: 4,
            validator: requiredText(l10n),
          ),
          gap,
          TextFormField(
            controller: _contactName,
            decoration: InputDecoration(labelText: l10n.fieldContactName),
            textCapitalization: TextCapitalization.words,
          ),
          gap,
          TextFormField(
            controller: _contactPhone,
            decoration: InputDecoration(labelText: l10n.fieldContactPhone),
            keyboardType: TextInputType.phone,
            validator: phoneValidator(l10n, required: false),
          ),
          gap,
          DateField(
            label: l10n.fieldStartDate,
            initialValue: _startDate,
            validator: (value) => value == null ? l10n.validationRequired : null,
            onChanged: (value) => setState(() => _startDate = value),
          ),
          gap,
          DateField(
            label: l10n.fieldExpectedCompletion,
            initialValue: _completionDate,
            clearable: true,
            validator: (value) => value != null && _startDate != null && value.compareTo(_startDate!) < 0
                ? l10n.validationCompletionBeforeStart
                : null,
            onChanged: (value) => _completionDate = value,
          ),
          gap,
          AmountField(
            controller: _contract,
            label: l10n.fieldContractAmount,
            validator: (value) => value == null || !isAmount(value) ? l10n.validationAmount : null,
          ),
          gap,
          DropdownButtonFormField<SiteStatus>(
            isExpanded: true,
            initialValue: _status,
            decoration: InputDecoration(labelText: l10n.fieldStatus),
            items: [
              for (final status in SiteStatus.values) DropdownMenuItem(value: status, child: Text(status.label(l10n))),
            ],
            onChanged: (value) => setState(() => _status = value ?? _status),
          ),
          gap,
          TextFormField(
            controller: _progress,
            decoration: InputDecoration(labelText: l10n.fieldProgress, suffixText: '%'),
            keyboardType: TextInputType.number,
            inputFormatters: digitsOnly,
            validator: intRangeValidator(l10n, 0, 100),
          ),
          SectionHeader(l10n.siteLocation),
          Text(l10n.siteLocationHelp, style: theme.textTheme.bodySmall),
          gap,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _latitude,
                  decoration: InputDecoration(labelText: l10n.fieldLatitude),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  inputFormatters: coordinateFormat,
                  validator: (value) => _coordinate(value, 90),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _longitude,
                  decoration: InputDecoration(labelText: l10n.fieldLongitude),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  inputFormatters: coordinateFormat,
                  validator: (value) => _coordinate(value, 180),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              OutlinedButton.icon(
                onPressed: _locating ? null : _useCurrentLocation,
                icon: _locating
                    ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.my_location),
                label: Text(l10n.useCurrentLocation),
              ),
              if (_latitude.text.isNotEmpty || _longitude.text.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() {
                    _latitude.clear();
                    _longitude.clear();
                  }),
                  child: Text(l10n.locationClear),
                ),
            ],
          ),
          gap,
          TextFormField(
            controller: _radius,
            decoration: InputDecoration(labelText: l10n.fieldGeofence, suffixText: 'm'),
            keyboardType: TextInputType.number,
            inputFormatters: digitsOnly,
            validator: intRangeValidator(l10n, 25, 5000, required: false),
          ),
          if (_creating) ...[
            SectionHeader(l10n.fieldEngineers),
            _ChosenEngineers(ids: _engineerIds, onEdit: _pickEngineers),
          ],
          if (submitError != null) ...[const SizedBox(height: AppSpacing.lg), InlineMessage(message: submitError!)],
          const SizedBox(height: AppSpacing.xl),
          SubmitButton(label: l10n.commonSave, busy: submitting, onPressed: _save),
        ],
      ),
    );
  }
}

class _ClientField extends ConsumerWidget {
  const _ClientField({required this.clientId, required this.onChanged});

  final String? clientId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AsyncValueView(
      value: ref.watch(clientPickerProvider),
      onRetry: () => ref.invalidate(clientPickerProvider),
      data: (clients) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              // A client added meanwhile appears once the list reloads.
              key: ValueKey('clients-${clients.length}'),
              initialValue: clients.any((c) => c.id == clientId) ? clientId : null,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.fieldClient),
              items: [
                for (final client in clients)
                  DropdownMenuItem(
                    value: client.id,
                    child: Text(client.name, overflow: TextOverflow.ellipsis),
                  ),
              ],
              validator: (value) => value == null ? l10n.validationRequired : null,
              onChanged: onChanged,
            ),
          ),
          IconButton(
            tooltip: l10n.clientNew,
            icon: const Icon(Icons.person_add_alt_outlined),
            onPressed: () => context.push(AppRoutes.adminClientNew),
          ),
        ],
      ),
    );
  }
}

class _ChosenEngineers extends ConsumerWidget {
  const _ChosenEngineers({required this.ids, required this.onEdit});

  final List<String> ids;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final engineers = ref.watch(engineerPickerProvider).value ?? const [];
    final names = [
      for (final engineer in engineers)
        if (ids.contains(engineer.id)) engineer.name,
    ];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.engineering_outlined),
      title: Text(names.isEmpty ? l10n.siteNoEngineers : names.join(', ')),
      trailing: TextButton(onPressed: onEdit, child: Text(ids.isEmpty ? l10n.commonAdd : l10n.commonEdit)),
    );
  }
}
