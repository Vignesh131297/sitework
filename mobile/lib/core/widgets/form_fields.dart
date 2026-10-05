import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../utils/formatters.dart';

/// Date picker field holding an ISO date ("2026-10-05").
class DateField extends FormField<String> {
  DateField({
    super.key,
    required String label,
    super.initialValue,
    super.validator,
    ValueChanged<String?>? onChanged,
    DateTime? firstDate,
    DateTime? lastDate,
    bool clearable = false,
  }) : super(
         builder: (state) {
           final context = state.context;
           Future<void> pick() async {
             final current = state.value == null ? DateTime.now() : DateTime.parse(state.value!);
             final picked = await showDatePicker(
               context: context,
               initialDate: current,
               firstDate: firstDate ?? DateTime(2015),
               lastDate: lastDate ?? DateTime(2040),
             );
             if (picked != null) {
               final iso = isoDate(picked);
               state.didChange(iso);
               onChanged?.call(iso);
             }
           }

           return InkWell(
             onTap: pick,
             borderRadius: BorderRadius.circular(12),
             child: InputDecorator(
               decoration: InputDecoration(
                 labelText: label,
                 errorText: state.errorText,
                 prefixIcon: const Icon(Icons.event_outlined),
                 suffixIcon: clearable && state.value != null
                     ? IconButton(
                         icon: const Icon(Icons.clear),
                         onPressed: () {
                           state.didChange(null);
                           onChanged?.call(null);
                         },
                       )
                     : null,
               ),
               isEmpty: state.value == null,
               child: Text(state.value == null ? '' : formatDate(state.value!)),
             ),
           );
         },
       );
}

/// Rupee amount input: digits with up to two decimals; the value stays a string.
class AmountField extends StatelessWidget {
  const AmountField({super.key, required this.controller, required this.label, this.validator, this.helperText});

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,12}(\.\d{0,2})?'))],
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixText: '₹ ',
        prefixIcon: const Icon(Icons.currency_rupee),
      ),
    );
  }
}

/// True for "1500000", "1500000.5", "1500000.50".
bool isAmount(String value) => RegExp(r'^\d{1,12}(\.\d{1,2})?$').hasMatch(value.trim());
