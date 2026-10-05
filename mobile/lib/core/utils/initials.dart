/// "Arun Kumar" → "AK", "Ravi" → "R".
String initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  return parts.take(2).map((p) => p.characters.first.toUpperCase()).join();
}

extension on String {
  // Avoids splitting surrogate pairs in non-Latin names.
  Iterable<String> get characters => runes.map(String.fromCharCode);
}
