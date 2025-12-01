import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_api.dart';
import 'package:firebase_ai_testing/domain/mappers/transaction_mapper.dart';
import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionMapper', () {
    final testDate = DateTime(2024, 1, 15, 10, 30);
    final transactionDate = DateTime(2024, 1, 10, 14);

    group('toDomain', () {
      test('converts TransactionApi to Transaction with all fields', () {
        final transactionApi = TransactionApiModel(
          id: 'txn-123',
          userId: 'user-123',
          amount: 150.50,
          transactionType: 'income',
          paymentType: 'credit_card',
          transactionDate: transactionDate,
          createdAt: testDate,
          categoryId: 'cat-123',
          description: 'Salary payment',
        );

        final transaction = TransactionMapper.toDomain(transactionApi);

        expect(transaction.id, 'txn-123');
        expect(transaction.userId, 'user-123');
        expect(transaction.amount, 150.50);
        expect(transaction.transactionType, TransactionType.income);
        expect(transaction.paymentType, PaymentType.creditCard);
        expect(transaction.transactionDate, transactionDate);
        expect(transaction.createdAt, testDate);
        expect(transaction.categoryId, 'cat-123');
        expect(transaction.description, 'Salary payment');
      });

      test(
        'converts TransactionApi to Transaction without optional fields',
        () {
          final transactionApi = TransactionApiModel(
            id: 'txn-456',
            userId: 'user-123',
            amount: 50,
            transactionType: 'expense',
            paymentType: 'pix',
            transactionDate: transactionDate,
            createdAt: testDate,
          );

          final transaction = TransactionMapper.toDomain(transactionApi);

          expect(transaction.categoryId, null);
          expect(transaction.description, null);
        },
      );

      test('converts all transaction types correctly', () {
        final incomeApi = TransactionApiModel(
          id: 'txn-1',
          userId: 'user-123',
          amount: 100,
          transactionType: 'income',
          paymentType: 'pix',
          transactionDate: transactionDate,
          createdAt: testDate,
        );

        final expenseApi = TransactionApiModel(
          id: 'txn-2',
          userId: 'user-123',
          amount: 100,
          transactionType: 'expense',
          paymentType: 'pix',
          transactionDate: transactionDate,
          createdAt: testDate,
        );

        expect(
          TransactionMapper.toDomain(incomeApi).transactionType,
          TransactionType.income,
        );
        expect(
          TransactionMapper.toDomain(expenseApi).transactionType,
          TransactionType.expense,
        );
      });

      test('converts all payment types correctly', () {
        final paymentTypes = {
          'credit_card': PaymentType.creditCard,
          'debit_card': PaymentType.debitCard,
          'pix': PaymentType.pix,
          'money': PaymentType.money,
        };

        for (final entry in paymentTypes.entries) {
          final transactionApi = TransactionApiModel(
            id: 'txn-test',
            userId: 'user-123',
            amount: 100,
            transactionType: 'expense',
            paymentType: entry.key,
            transactionDate: transactionDate,
            createdAt: testDate,
          );

          final transaction = TransactionMapper.toDomain(transactionApi);
          expect(transaction.paymentType, entry.value);
        }
      });

      test('handles case-insensitive transaction type conversion', () {
        final transactionApi = TransactionApiModel(
          id: 'txn-789',
          userId: 'user-123',
          amount: 100,
          transactionType: 'INCOME',
          paymentType: 'pix',
          transactionDate: transactionDate,
          createdAt: testDate,
        );

        final transaction = TransactionMapper.toDomain(transactionApi);
        expect(transaction.transactionType, TransactionType.income);
      });

      test('throws ArgumentError for unknown transaction type', () {
        final transactionApi = TransactionApiModel(
          id: 'txn-999',
          userId: 'user-123',
          amount: 100,
          transactionType: 'unknown',
          paymentType: 'pix',
          transactionDate: transactionDate,
          createdAt: testDate,
        );

        expect(
          () => TransactionMapper.toDomain(transactionApi),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for unknown payment type', () {
        final transactionApi = TransactionApiModel(
          id: 'txn-999',
          userId: 'user-123',
          amount: 100,
          transactionType: 'income',
          paymentType: 'unknown',
          transactionDate: transactionDate,
          createdAt: testDate,
        );

        expect(
          () => TransactionMapper.toDomain(transactionApi),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('toApi', () {
      test('converts Transaction to TransactionApi with all fields', () {
        final transaction = Transaction(
          id: 'txn-123',
          userId: 'user-123',
          amount: 150.50,
          transactionType: TransactionType.income,
          paymentType: PaymentType.creditCard,
          transactionDate: transactionDate,
          createdAt: testDate,
          categoryId: 'cat-123',
          description: 'Salary payment',
        );

        final transactionApi = TransactionMapper.toApi(transaction);

        expect(transactionApi.id, 'txn-123');
        expect(transactionApi.userId, 'user-123');
        expect(transactionApi.amount, 150.50);
        expect(transactionApi.transactionType, 'income');
        expect(transactionApi.paymentType, 'credit_card');
        expect(transactionApi.transactionDate, transactionDate);
        expect(transactionApi.createdAt, testDate);
        expect(transactionApi.categoryId, 'cat-123');
        expect(transactionApi.description, 'Salary payment');
      });

      test('converts all payment types to correct strings', () {
        final paymentTypeMap = {
          PaymentType.creditCard: 'credit_card',
          PaymentType.debitCard: 'debit_card',
          PaymentType.pix: 'pix',
          PaymentType.money: 'money',
        };

        for (final entry in paymentTypeMap.entries) {
          final transaction = Transaction(
            id: 'txn-test',
            userId: 'user-123',
            amount: 100,
            transactionType: TransactionType.expense,
            paymentType: entry.key,
            transactionDate: transactionDate,
            createdAt: testDate,
          );

          final transactionApi = TransactionMapper.toApi(transaction);
          expect(transactionApi.paymentType, entry.value);
        }
      });
    });

    group('toCreateRequest', () {
      test(
        'converts Transaction to CreateTransactionRequest with all fields',
        () {
          final transaction = Transaction(
            id: 'txn-123',
            userId: 'user-123',
            amount: 150.50,
            transactionType: TransactionType.expense,
            paymentType: PaymentType.debitCard,
            transactionDate: transactionDate,
            createdAt: testDate,
            categoryId: 'cat-123',
            description: 'Grocery shopping',
          );

          final request = TransactionMapper.toCreateRequest(transaction);

          expect(request.amount, 150.50);
          expect(request.transactionType, 'expense');
          expect(request.paymentType, 'debit_card');
          expect(request.transactionDate, transactionDate);
          expect(request.categoryId, 'cat-123');
          expect(request.description, 'Grocery shopping');
        },
      );

      test(
        'converts Transaction to CreateTransactionRequest without optional fields',
        () {
          final transaction = Transaction(
            id: 'txn-456',
            userId: 'user-123',
            amount: 50,
            transactionType: TransactionType.income,
            paymentType: PaymentType.pix,
            transactionDate: transactionDate,
            createdAt: testDate,
          );

          final request = TransactionMapper.toCreateRequest(transaction);

          expect(request.categoryId, null);
          expect(request.description, null);
        },
      );

      test('formats date correctly for CreateTransactionRequest', () {
        final transaction = Transaction(
          id: 'txn-789',
          userId: 'user-123',
          amount: 100,
          transactionType: TransactionType.expense,
          paymentType: PaymentType.money,
          transactionDate: transactionDate,
          createdAt: testDate,
        );

        final request = TransactionMapper.toCreateRequest(transaction);

        // Verify the date is preserved correctly
        expect(request.transactionDate, transactionDate);

        // Verify ISO 8601 format when serialized
        final isoString = request.transactionDate.toIso8601String();
        expect(isoString, contains('2024-01-10'));
      });
    });

    group('round-trip conversion', () {
      test('toDomain then toApi preserves data', () {
        final originalApi = TransactionApiModel(
          id: 'txn-123',
          userId: 'user-123',
          amount: 150.50,
          transactionType: 'income',
          paymentType: 'credit_card',
          transactionDate: transactionDate,
          createdAt: testDate,
          categoryId: 'cat-123',
          description: 'Salary payment',
        );

        final domain = TransactionMapper.toDomain(originalApi);
        final convertedApi = TransactionMapper.toApi(domain);

        expect(convertedApi.id, originalApi.id);
        expect(convertedApi.userId, originalApi.userId);
        expect(convertedApi.amount, originalApi.amount);
        expect(convertedApi.transactionType, originalApi.transactionType);
        expect(convertedApi.paymentType, originalApi.paymentType);
        expect(convertedApi.transactionDate, originalApi.transactionDate);
        expect(convertedApi.createdAt, originalApi.createdAt);
        expect(convertedApi.categoryId, originalApi.categoryId);
        expect(convertedApi.description, originalApi.description);
      });

      test('toApi then toDomain preserves data', () {
        final originalDomain = Transaction(
          id: 'txn-456',
          userId: 'user-456',
          amount: 75.25,
          transactionType: TransactionType.expense,
          paymentType: PaymentType.pix,
          transactionDate: transactionDate,
          createdAt: testDate,
          categoryId: 'cat-456',
          description: 'Coffee',
        );

        final api = TransactionMapper.toApi(originalDomain);
        final convertedDomain = TransactionMapper.toDomain(api);

        expect(convertedDomain.id, originalDomain.id);
        expect(convertedDomain.userId, originalDomain.userId);
        expect(convertedDomain.amount, originalDomain.amount);
        expect(convertedDomain.transactionType, originalDomain.transactionType);
        expect(convertedDomain.paymentType, originalDomain.paymentType);
        expect(convertedDomain.transactionDate, originalDomain.transactionDate);
        expect(convertedDomain.createdAt, originalDomain.createdAt);
        expect(convertedDomain.categoryId, originalDomain.categoryId);
        expect(convertedDomain.description, originalDomain.description);
      });
    });
  });
}
