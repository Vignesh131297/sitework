import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../people/data/people_repository.dart';

/// Lets the admin pick any number of active engineers. Resolves to the chosen
/// ids, or null when cancelled.
Future<List<String>?> pickEngineers(BuildContext context, {required List<String> selected}) => showDialog<List<String>>(
  context: context,
  builder: (_) => _EngineerPicker(initial: selected),
);

class _EngineerPicker extends ConsumerStatefulWidget {
  const _EngineerPicker({required this.initial});

  final List<String> initial;

  @override
  ConsumerState<_EngineerPicker> createState() => _EngineerPickerState();
}

class _EngineerPickerState extends ConsumerState<_EngineerPicker> {
  late final _selected = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.fieldEngineers),
      contentPadding: const EdgeInsets.only(top: 16),
      content: SizedBox(
        width: double.maxFinite,
        child: AsyncValueView(
          value: ref.watch(engineerPickerProvider),
          onRetry: () => ref.invalidate(engineerPickerProvider),
          data: (engineers) => ListView(
            shrinkWrap: true,
            children: [
              for (final engineer in engineers)
                CheckboxListTile(
                  value: _selected.contains(engineer.id),
                  title: Text(engineer.name),
                  subtitle: Text(engineer.employeeCode),
                  onChanged: (checked) =>
                      setState(() => checked == true ? _selected.add(engineer.id) : _selected.remove(engineer.id)),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.commonCancel)),
        FilledButton(onPressed: () => Navigator.of(context).pop(_selected.toList()), child: Text(l10n.commonSave)),
      ],
    );
  }
}
