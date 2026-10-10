import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:uuid/uuid.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/time/server_clock.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/material_requests_repository.dart';
import '../data/stock_repository.dart';
import '../domain/stock_models.dart';

/// A site asks for material: what, how much, and by when. An admin approves
/// it from a godown, whose manager sends it.
class RequestFormScreen extends ConsumerStatefulWidget {
  const RequestFormScreen({super.key, this.siteId});

  /// The site asking; the user picks one of theirs when null.
  final String? siteId;

  @override
  ConsumerState<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _Line {
  String? materialId;
  final quantity = TextEditingController();
}

class _RequestFormScreenState extends ConsumerState<RequestFormScreen> with SubmitState {
  final _formKey = GlobalKey<FormState>();

  /// Made once per form, so a retry after a dropped connection asks only once.
  final _requestId = const Uuid().v4();
  final _note = TextEditingController();
  final _lines = [_Line()];
  late String? _siteId = widget.siteId;
  String? _neededBy;

  @override
  void dispose() {
    _note.dispose();
    for (final line in _lines) {
      line.quantity.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final area = ref.read(areaPathProvider);
    final created = await runSubmit(
      () => ref
          .read(materialRequestsRepositoryProvider)
          .create(
            requestId: _requestId,
            siteId: _siteId!,
            lines: [for (final line in _lines) (materialId: line.materialId!, quantity: line.quantity.text.trim())],
            neededBy: _neededBy,
            note: textOrNull(_note),
          ),
    );
    if (created == null || !mounted) return;
    ref
      ..bump(DataSet.stock)
      ..bump(DataSet.notifications);
    showSnack(context, l10n.requestSent(created.code));
    context.pushReplacement(AppRoutes.request(area, created.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    final overview = ref.watch(stockOverviewProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.requestNew)),
      body: AsyncValueView(
        value: overview,
        onRetry: () => ref.invalidate(stockOverviewProvider),
        data: (overview) {
          final materials = [
            for (final row in overview.materials)
              if (row.material.isActive) row.material,
          ];
          final sites = overview.sites;
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: sites.any((s) => s.id == _siteId) ? _siteId : null,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.fieldSite,
                    prefixIcon: const Icon(Icons.apartment_outlined),
                  ),
                  items: [
                    for (final site in sites)
                      DropdownMenuItem(
                        value: site.id,
                        child: Text(site.name, overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  validator: (value) => value == null ? l10n.validationRequired : null,
                  onChanged: widget.siteId == null ? (value) => setState(() => _siteId = value) : null,
                ),
                gap,
                DateField(
                  label: l10n.requestNeededByOptional,
                  initialValue: _neededBy,
                  clearable: true,
                  firstDate: ref.read(serverClockProvider.notifier).now(),
                  onChanged: (value) => _neededBy = value,
                ),
                SectionHeader(l10n.stockMaterials),
                if (materials.isEmpty)
                  InlineMessage(message: l10n.stockNoMaterials)
                else ...[
                  for (final (index, line) in _lines.indexed)
                    _LineCard(
                      key: ObjectKey(line),
                      index: index,
                      line: line,
                      materials: [
                        for (final m in materials)
                          if (m.id == line.materialId || !_lines.any((other) => other.materialId == m.id)) m,
                      ],
                      onChanged: () => setState(() {}),
                      onRemove: _lines.length > 1
                          ? () => setState(() {
                              _lines.remove(line);
                              line.quantity.dispose();
                            })
                          : null,
                    ),
                  if (_lines.length < materials.length)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => setState(() => _lines.add(_Line())),
                        icon: const Icon(Icons.add),
                        label: Text(l10n.stockAddMaterial),
                      ),
                    ),
                ],
                gap,
                TextFormField(
                  controller: _note,
                  decoration: InputDecoration(labelText: l10n.requestWhatFor),
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 500,
                ),
                if (submitError case final error?) ...[gap, InlineMessage(message: error)],
                const SizedBox(height: AppSpacing.lg),
                SubmitButton(label: l10n.requestSubmit, busy: submitting, onPressed: materials.isEmpty ? null : _save),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LineCard extends StatelessWidget {
  const _LineCard({
    super.key,
    required this.index,
    required this.line,
    required this.materials,
    required this.onChanged,
    this.onRemove,
  });

  final int index;
  final _Line line;
  final List<StockMaterial> materials;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = materials.where((m) => m.id == line.materialId).firstOrNull?.unit;
    return Card(
      key: ValueKey('request-line-$index'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.xs, AppSpacing.sm),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    key: ValueKey('request-material-$index-${line.materialId}'),
                    initialValue: line.materialId,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.stockMaterial),
                    items: [
                      for (final material in materials)
                        DropdownMenuItem(
                          value: material.id,
                          child: Text(material.name, overflow: TextOverflow.ellipsis),
                        ),
                    ],
                    validator: (value) => value == null ? l10n.validationRequired : null,
                    onChanged: (value) {
                      line.materialId = value;
                      onChanged();
                    },
                  ),
                ),
                IconButton(tooltip: l10n.stockRemoveLine, onPressed: onRemove, icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: QuantityField(
                controller: line.quantity,
                label: l10n.requestQuantityNeeded,
                unit: unit,
                validator: (value) =>
                    value == null || !isQuantity(value) || num.parse(value) <= 0 ? l10n.validationQuantity : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
