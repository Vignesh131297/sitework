import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Generated message methods take placeholders in the order the metadata
/// declares them. Keeping that order the same as the English text means a
/// call reads like the sentence, e.g. `updatesSubmittedOf(submitted, expected)`.
void main() {
  test('placeholders are declared in the order they appear in the message', () {
    final arb = jsonDecode(File('lib/core/l10n/app_en.arb').readAsStringSync()) as Map<String, dynamic>;
    final mismatches = <String>[];
    for (final MapEntry(:key, :value) in arb.entries) {
      if (key.startsWith('@') || value is! String) continue;
      final meta = arb['@$key'];
      if (meta is! Map<String, dynamic> || meta['placeholders'] is! Map<String, dynamic>) continue;
      final declared = (meta['placeholders'] as Map<String, dynamic>).keys.toList();
      final inText = <String>[];
      for (final match in RegExp(r'\{(\w+)').allMatches(value)) {
        final name = match.group(1)!;
        if (declared.contains(name) && !inText.contains(name)) inText.add(name);
      }
      if (declared.join(',') != inText.join(',')) mismatches.add('$key: declared $declared, text $inText');
    }
    expect(mismatches, isEmpty);
  });

  test('text is clean UTF-8, not double-encoded (e.g. "Â·" for "·")', () {
    final text = File('lib/core/l10n/app_en.arb').readAsStringSync();
    expect(RegExp('Ã|Â|â€').allMatches(text).map((m) => m.group(0)), isEmpty);
  });
}
