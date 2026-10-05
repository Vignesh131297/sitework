import 'package:flutter_test/flutter_test.dart';
import 'package:sitework/core/utils/formatters.dart';
import 'package:sitework/core/utils/initials.dart';

void main() {
  test('formatInr uses Indian digit grouping and hides zero paise', () {
    expect(formatInr('850000.00'), '₹8,50,000');
    expect(formatInr('2450000'), '₹24,50,000');
    expect(formatInr('1234.5'), '₹1,234.50');
  });

  test('formatShortDate and formatTime', () {
    expect(formatShortDate(DateTime(2026, 10, 3)), 'Sat 3 Oct');
    // intl separates the period with a narrow no-break space.
    expect(formatTime(DateTime(2026, 10, 3, 10, 42)), matches(RegExp(r'^10:42\sAM$')));
  });

  test('initialsOf', () {
    expect(initialsOf('Arun Kumar'), 'AK');
    expect(initialsOf('Ravi'), 'R');
    expect(initialsOf('  admin   user '), 'AU');
  });
}
