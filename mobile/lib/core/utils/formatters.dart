import 'package:intl/intl.dart';

final _rupees = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
final _rupeesAndPaise = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

/// Formats an API amount ("850000.00") as "₹8,50,000", or "₹1,234.50" when
/// there are paise. Display only: money arithmetic happens on the server.
String formatInr(String amount) {
  final value = num.parse(amount);
  return (value % 1 == 0 ? _rupees : _rupeesAndPaise).format(value);
}

final _quantity = NumberFormat('#,##,##0.###', 'en_IN');

/// An API quantity ("1250", "12.5") with its unit: "1,250 bag" (or "1,250"
/// without one). Display only: stock arithmetic happens on the server.
String formatQuantity(String quantity, [String? unit]) {
  final number = _quantity.format(num.parse(quantity));
  return unit == null ? number : '$number $unit';
}

/// "10:42 AM" in the phone's time zone.
String formatTime(DateTime time) => DateFormat.jm().format(time.toLocal());

/// "Sat 3 Oct"
String formatShortDate(DateTime date) => DateFormat('EEE d MMM').format(date);

/// ISO date "2026-10-05" → "5 Oct 2026".
String formatDate(String isoDate) => DateFormat('d MMM yyyy').format(DateTime.parse(isoDate));

/// "5 Oct, 10:42 AM"
String formatDateTime(DateTime time) => DateFormat('d MMM, h:mm a').format(time.toLocal());

/// DateTime → "2026-10-05" (calendar date, no time zone shift).
String isoDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
