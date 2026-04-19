import 'package:flutter_test/flutter_test.dart';
import 'package:rideztohealth/core/validation/validators.dart';

void main() {
  group('Validators', () {
    test('email accepts a valid address', () {
      expect(Validators.email('user@example.com'), isNull);
    });

    test('email rejects an invalid address', () {
      expect(
        Validators.email('invalid-email'),
        'Please enter a valid email address',
      );
    });

    test('password enforces minimum security rules', () {
      expect(
        Validators.password('weakpass'),
        'Password must contain at least one uppercase letter',
      );
    });
  });
}
