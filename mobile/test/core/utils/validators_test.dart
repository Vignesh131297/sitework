import 'package:flutter_test/flutter_test.dart';
import 'package:sitework/core/utils/validators.dart';

void main() {
  group('isValidPhone (same rule as the server)', () {
    test('accepts a 10-digit mobile number, with or without +91, 91 or 0', () {
      for (final phone in [
        '9876543210',
        '+919876543210',
        '919876543210',
        '09876543210',
        '+91 98765 43210',
        '98765-43210',
      ]) {
        expect(isValidPhone(phone), isTrue, reason: phone);
      }
    });

    test('rejects numbers that are not 10 digits or do not start with 6-9', () {
      for (final phone in ['987654321', '98765432101', '+9198765432', '+91987654321012', '5876543210', '12345', '']) {
        expect(isValidPhone(phone), isFalse, reason: phone);
      }
    });

    test('accepts other countries in international format', () {
      expect(isValidPhone('+14155552671'), isTrue);
      expect(isValidPhone('+4420'), isFalse);
    });
  });
}
