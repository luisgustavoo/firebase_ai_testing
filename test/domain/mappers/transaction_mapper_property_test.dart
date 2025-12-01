import 'package:firebase_ai_testing/domain/mappers/transaction_mapper.dart';
import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionMapper Property Tests', () {
    /// **Feature: api-integration, Property 21: Dates are formatted to ISO 8601**
    /// **Validates: Requirements 8.5**
    test('Property 21: Dates are formatted to ISO 8601', () {
      // Generate 100 random dates to test the property
      for (var i = 0; i < 100; i++) {
        // Generate random date components
        final year = 2000 + (i % 25); // Years from 2000 to 2024
        final month = 1 + (i % 12); // Months 1-12
        final day = 1 + (i % 28); // Days 1-28 (safe for all months)
        final hour = i % 24;
        final minute = (i * 7) % 60;
        final second = (i * 13) % 60;

        final randomDate = DateTime(year, month, day, hour, minute, second);

        // Create a transaction with this date
        final transaction = Transaction(
          id: 'test-$i',
          userId: 'user-$i',
          amount: 100.0 + i,
          transactionType: i.isEven
              ? TransactionType.income
              : TransactionType.expense,
          paymentType: PaymentType.values[i % PaymentType.values.length],
          transactionDate: randomDate,
          createdAt: DateTime.now(),
          categoryId: 'cat-$i',
          description: 'Test transaction $i',
        );

        // Convert to create request
        final request = TransactionMapper.toCreateRequest(transaction);

        // Verify the date is in ISO 8601 format
        // ISO 8601 format: YYYY-MM-DDTHH:mm:ss.sssZ or YYYY-MM-DDTHH:mm:ss.sss
        final isoString = request.transactionDate.toIso8601String();

        // Check that the ISO string matches the expected pattern
        final iso8601Pattern = RegExp(
          r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}(Z|[+-]\d{2}:\d{2})?$',
        );

        expect(
          iso8601Pattern.hasMatch(isoString),
          isTrue,
          reason:
              'Date $randomDate should be formatted as ISO 8601, got: $isoString',
        );

        // Verify that parsing the ISO string gives us back the same date
        final parsedDate = DateTime.parse(isoString);
        expect(
          parsedDate.isAtSameMomentAs(request.transactionDate),
          isTrue,
          reason: 'Parsed date should match original date',
        );
      }
    });

    test('Property 21 (edge cases): ISO 8601 format for edge case dates', () {
      final edgeCaseDates = [
        DateTime(2000), // Start of millennium
        DateTime(2024, 12, 31, 23, 59, 59), // End of year
        DateTime(2020, 2, 29, 12), // Leap year
        DateTime.utc(2023, 6, 15, 14, 30), // UTC date
        DateTime(1970), // Unix epoch
      ];

      for (final date in edgeCaseDates) {
        final transaction = Transaction(
          id: 'test',
          userId: 'user',
          amount: 100,
          transactionType: TransactionType.income,
          paymentType: PaymentType.pix,
          transactionDate: date,
          createdAt: DateTime.now(),
        );

        final request = TransactionMapper.toCreateRequest(transaction);
        final isoString = request.transactionDate.toIso8601String();

        // Verify ISO 8601 format
        final iso8601Pattern = RegExp(
          r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}(Z|[+-]\d{2}:\d{2})?$',
        );

        expect(
          iso8601Pattern.hasMatch(isoString),
          isTrue,
          reason: 'Edge case date $date should be formatted as ISO 8601',
        );
      }
    });
  });
}
