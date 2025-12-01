import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:firebase_ai_testing/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators Property Tests', () {
    /// **Feature: api-integration, Property 2: Invalid registration data is rejected before API call**
    /// **Validates: Requirements 1.3**
    test('Property 2: Invalid registration data is rejected before API call', () {
      // Test invalid names (< 3 chars)
      for (var i = 0; i < 100; i++) {
        // Generate names with 0, 1, or 2 characters
        final nameLength = i % 3;
        final invalidName = 'a' * nameLength;

        final result = Validators.validateName(invalidName);
        expect(
          result,
          isNotNull,
          reason:
              'Name with $nameLength characters should be rejected: "$invalidName"',
        );
      }

      // Test invalid emails
      final invalidEmails = [
        'notanemail',
        '@example.com',
        'user@',
        'user@.com',
        'user @example.com',
        'user@example',
        '',
        'user@@example.com',
        'user@example..com',
      ];

      for (final email in invalidEmails) {
        for (var i = 0; i < 10; i++) {
          // Test each invalid email multiple times
          final result = Validators.validateEmail(email);
          expect(
            result,
            isNotNull,
            reason: 'Invalid email should be rejected: "$email"',
          );
        }
      }

      // Test invalid passwords (< 6 chars)
      for (var i = 0; i < 100; i++) {
        // Generate passwords with 0-5 characters
        final passwordLength = i % 6;
        final invalidPassword = 'p' * passwordLength;

        final result = Validators.validatePassword(invalidPassword);
        expect(
          result,
          isNotNull,
          reason:
              'Password with $passwordLength characters should be rejected: "$invalidPassword"',
        );
      }

      // Test null values
      for (var i = 0; i < 20; i++) {
        expect(
          Validators.validateName(null),
          isNotNull,
          reason: 'Null name should be rejected',
        );
        expect(
          Validators.validateEmail(null),
          isNotNull,
          reason: 'Null email should be rejected',
        );
        expect(
          Validators.validatePassword(null),
          isNotNull,
          reason: 'Null password should be rejected',
        );
      }
    });

    /// **Feature: api-integration, Property 13: Short category descriptions are rejected**
    /// **Validates: Requirements 5.3**
    test('Property 13: Short category descriptions are rejected', () {
      // Test descriptions with < 3 characters
      for (var i = 0; i < 100; i++) {
        // Generate descriptions with 0, 1, or 2 characters
        final descLength = i % 3;
        final shortDescription = 'x' * descLength;

        final result = Validators.validateDescription(shortDescription);
        expect(
          result,
          isNotNull,
          reason:
              'Description with $descLength characters should be rejected: "$shortDescription"',
        );
      }

      // Test null and empty descriptions
      for (var i = 0; i < 20; i++) {
        expect(
          Validators.validateDescription(null),
          isNotNull,
          reason: 'Null description should be rejected',
        );
        expect(
          Validators.validateDescription(''),
          isNotNull,
          reason: 'Empty description should be rejected',
        );
      }

      // Test with custom min length
      for (var i = 0; i < 50; i++) {
        final minLength = 5 + (i % 10); // Min lengths from 5 to 14
        final shortDescription = 'x' * (minLength - 1);

        final result = Validators.validateDescription(
          shortDescription,
          minLength: minLength,
        );
        expect(
          result,
          isNotNull,
          reason:
              'Description with ${shortDescription.length} characters should be rejected when minLength is $minLength',
        );
      }
    });

    /// **Feature: api-integration, Property 15: Invalid updates are prevented**
    /// **Validates: Requirements 6.5**
    test('Property 15: Invalid updates are prevented', () {
      // Test that validation prevents invalid category updates
      // This tests the same validation as Property 13 but in update context
      for (var i = 0; i < 100; i++) {
        // Generate invalid descriptions for updates
        final descLength = i % 3;
        final invalidDescription = 'u' * descLength;

        final result = Validators.validateDescription(invalidDescription);
        expect(
          result,
          isNotNull,
          reason:
              'Invalid update with description length $descLength should be prevented',
        );
      }

      // Test that valid descriptions pass
      for (var i = 0; i < 50; i++) {
        final validDescription = 'Valid description ${i + 3}';
        final result = Validators.validateDescription(validDescription);
        expect(
          result,
          isNull,
          reason: 'Valid description should pass validation',
        );
      }
    });

    /// **Feature: api-integration, Property 18: Zero or negative amounts are rejected**
    /// **Validates: Requirements 8.2**
    test('Property 18: Zero or negative amounts are rejected', () {
      // Test zero amount
      for (var i = 0; i < 50; i++) {
        final result = Validators.validateAmount(0);
        expect(
          result,
          isNotNull,
          reason: 'Zero amount should be rejected',
        );
      }

      // Test negative amounts
      for (var i = 0; i < 100; i++) {
        final negativeAmount = -(i + 1).toDouble();
        final result = Validators.validateAmount(negativeAmount);
        expect(
          result,
          isNotNull,
          reason: 'Negative amount $negativeAmount should be rejected',
        );
      }

      // Test very small negative amounts
      for (var i = 0; i < 50; i++) {
        final smallNegative = -0.01 * (i + 1);
        final result = Validators.validateAmount(smallNegative);
        expect(
          result,
          isNotNull,
          reason: 'Small negative amount $smallNegative should be rejected',
        );
      }

      // Test null amount
      for (var i = 0; i < 20; i++) {
        expect(
          Validators.validateAmount(null),
          isNotNull,
          reason: 'Null amount should be rejected',
        );
      }

      // Test that positive amounts pass
      for (var i = 0; i < 50; i++) {
        final positiveAmount = (i + 1).toDouble();
        final result = Validators.validateAmount(positiveAmount);
        expect(
          result,
          isNull,
          reason: 'Positive amount $positiveAmount should pass validation',
        );
      }
    });

    /// **Feature: api-integration, Property 19: Invalid transaction types are rejected**
    /// **Validates: Requirements 8.3**
    test('Property 19: Invalid transaction types are rejected', () {
      // Test invalid transaction type strings
      final invalidTypes = [
        'invalid',
        'INCOME',
        'EXPENSE',
        'Income',
        'Expense',
        'transfer',
        'payment',
        'withdrawal',
        'deposit',
        '',
        'in come',
        'ex pense',
        'income ',
        ' expense',
      ];

      for (final invalidType in invalidTypes) {
        for (var i = 0; i < 10; i++) {
          final result = Validators.validateTransactionType(invalidType);
          expect(
            result,
            isNotNull,
            reason:
                'Invalid transaction type should be rejected: "$invalidType"',
          );
        }
      }

      // Test null transaction type
      for (var i = 0; i < 20; i++) {
        expect(
          Validators.validateTransactionType(null),
          isNotNull,
          reason: 'Null transaction type should be rejected',
        );
      }

      // Test that valid types pass (only lowercase)
      final validTypes = ['income', 'expense'];
      for (final validType in validTypes) {
        for (var i = 0; i < 10; i++) {
          final result = Validators.validateTransactionType(validType);
          expect(
            result,
            isNull,
            reason: 'Valid transaction type should pass: "$validType"',
          );
        }
      }

      // Test enum validation
      for (var i = 0; i < 50; i++) {
        final type = i.isEven
            ? TransactionType.income
            : TransactionType.expense;
        final isValid = Validators.isValidTransactionType(type);
        expect(
          isValid,
          isTrue,
          reason: 'Valid TransactionType enum should be accepted',
        );
      }
    });

    /// **Feature: api-integration, Property 20: Invalid payment types are rejected**
    /// **Validates: Requirements 8.4**
    test('Property 20: Invalid payment types are rejected', () {
      // Test invalid payment type strings
      final invalidTypes = [
        'invalid',
        'cash',
        'check',
        'bank_transfer',
        'CREDIT_CARD',
        'DEBIT_CARD',
        'PIX',
        'MONEY',
        'CreditCard',
        'DebitCard',
        '',
        'credit card',
        'debit card',
        'credit_card ',
        ' pix',
      ];

      for (final invalidType in invalidTypes) {
        for (var i = 0; i < 10; i++) {
          final result = Validators.validatePaymentType(invalidType);
          expect(
            result,
            isNotNull,
            reason: 'Invalid payment type should be rejected: "$invalidType"',
          );
        }
      }

      // Test null payment type
      for (var i = 0; i < 20; i++) {
        expect(
          Validators.validatePaymentType(null),
          isNotNull,
          reason: 'Null payment type should be rejected',
        );
      }

      // Test that valid types pass (only lowercase)
      final validTypes = ['credit_card', 'debit_card', 'pix', 'money'];
      for (final validType in validTypes) {
        for (var i = 0; i < 10; i++) {
          final result = Validators.validatePaymentType(validType);
          expect(
            result,
            isNull,
            reason: 'Valid payment type should pass: "$validType"',
          );
        }
      }

      // Test enum validation
      for (var i = 0; i < 100; i++) {
        final type = PaymentType.values[i % PaymentType.values.length];
        final isValid = Validators.isValidPaymentType(type);
        expect(
          isValid,
          isTrue,
          reason: 'Valid PaymentType enum should be accepted: $type',
        );
      }
    });

    // Additional comprehensive test for all validators
    test('Comprehensive validation test across all validators', () {
      // Test 100 iterations of various validation scenarios
      for (var i = 0; i < 100; i++) {
        // Valid data should pass
        expect(Validators.validateName('John Doe $i'), isNull);
        expect(Validators.validateEmail('user$i@example.com'), isNull);
        expect(Validators.validatePassword('password$i'), isNull);
        expect(Validators.validateAmount(100.0 + i), isNull);
        expect(Validators.validateDescription('Description $i'), isNull);
        expect(Validators.validateTransactionType('income'), isNull);
        expect(Validators.validatePaymentType('pix'), isNull);

        // Invalid data should fail
        if (i % 3 == 0) {
          expect(Validators.validateName('ab'), isNotNull);
          expect(Validators.validateEmail('invalid'), isNotNull);
          expect(Validators.validatePassword('12345'), isNotNull);
          expect(Validators.validateAmount(-1), isNotNull);
          expect(Validators.validateDescription('ab'), isNotNull);
          expect(Validators.validateTransactionType('invalid'), isNotNull);
          expect(Validators.validatePaymentType('invalid'), isNotNull);
        }
      }
    });
  });
}
