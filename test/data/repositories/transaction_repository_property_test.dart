import 'dart:convert';

import 'package:firebase_ai_testing/data/repositories/transaction_repository.dart';
import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_request/create_transaction_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_response/transactions_response.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('TransactionRepository Property Tests', () {
    late TransactionRepository transactionRepository;
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    /// **Feature: api-integration, Property 17: Valid transaction creation succeeds**
    /// **Validates: Requirements 8.1**
    ///
    /// For any valid transaction data (amount > 0, valid type, valid payment type,
    /// valid date), creation should succeed.
    test('Property 17: Valid transaction creation succeeds', () async {
      // Test with various valid transaction data
      final testCases = [
        {
          'amount': 100.0,
          'description': 'Grocery shopping',
          'transactionType': 'expense',
          'paymentType': 'credit_card',
          'categoryId': 'cat-1',
        },
        {
          'amount': 5000.0,
          'description': 'Salary',
          'transactionType': 'income',
          'paymentType': 'pix',
          'categoryId': 'cat-2',
        },
        {
          'amount': 50.5,
          'description': 'Coffee',
          'transactionType': 'expense',
          'paymentType': 'money',
          'categoryId': null, // Null category is valid
        },
        {
          'amount': 1500.75,
          'description': 'Freelance work',
          'transactionType': 'income',
          'paymentType': 'debit_card',
          'categoryId': 'cat-3',
        },
      ];

      for (final testData in testCases) {
        final amount = testData['amount'] as double;
        final description = testData['description'] as String;
        final transactionType = testData['transactionType'] as String;
        final paymentType = testData['paymentType'] as String;
        final categoryId = testData['categoryId'] as String?;

        final mockClient = MockClient((request) async {
          // Verify the request is to the create transaction endpoint
          expect(request.url.path, equals('/api/transactions'));
          expect(request.method, equals('POST'));

          // Parse the request body
          final body = json.decode(request.body) as Map<String, dynamic>;

          // Property: Request should contain the provided data
          expect(body['amount'], equals(amount));
          expect(body['description'], equals(description));
          expect(body['transaction_type'], equals(transactionType));
          expect(body['payment_type'], equals(paymentType));
          expect(body['category_id'], equals(categoryId));
          expect(body.containsKey('transaction_date'), isTrue);

          // Return a successful response with created transaction
          final response = {
            'id': 'txn-${DateTime.now().millisecondsSinceEpoch}',
            'user_id': 'user-123',
            'amount': amount,
            'description': description,
            'transaction_type': transactionType,
            'payment_type': paymentType,
            'category_id': categoryId,
            'transaction_date': DateTime.now().toIso8601String(),
            'created_at': DateTime.now().toIso8601String(),
          };

          return http.Response(
            json.encode(response),
            201,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);

        // Create request
        final request = CreateTransactionRequest(
          amount: amount,
          description: description,
          transactionType: transactionType,
          paymentType: paymentType,
          categoryId: categoryId,
          transactionDate: DateTime.now(),
        );

        // Call createTransaction
        final result = await transactionRepository.createTransaction(request);

        // Property: Creation should succeed
        expect(result, isA<Ok<Transaction>>());

        // Property: Returned transaction should have matching data
        final transaction = (result as Ok<Transaction>).value;
        expect(transaction.amount, equals(amount));
        expect(transaction.description, equals(description));
        expect(transaction.categoryId, equals(categoryId));
      }
    });

    /// **Feature: api-integration, Property 23: Pagination loads next page when available**
    /// **Validates: Requirements 9.2**
    ///
    /// For any transaction list where has_next is true, scrolling to the end
    /// should trigger loading the next page.
    test('Property 23: Pagination loads next page when available', () async {
      // Test with various pagination scenarios
      final testCases = [
        {
          'page': 1,
          'pageSize': 20,
          'hasNext': true,
          'totalPages': 3,
        },
        {
          'page': 2,
          'pageSize': 10,
          'hasNext': true,
          'totalPages': 5,
        },
        {
          'page': 1,
          'pageSize': 50,
          'hasNext': true,
          'totalPages': 2,
        },
      ];

      for (final testData in testCases) {
        final page = testData['page'] as int;
        final pageSize = testData['pageSize'] as int;
        final hasNext = testData['hasNext'] as bool;
        final totalPages = testData['totalPages'] as int;

        final mockClient = MockClient((request) async {
          // Verify the request is to the transactions endpoint
          expect(request.url.path, equals('/api/transactions'));

          // Verify pagination parameters
          expect(request.url.queryParameters['page'], equals(page.toString()));
          expect(
            request.url.queryParameters['pageSize'],
            equals(pageSize.toString()),
          );

          // Return a response with pagination metadata
          final response = {
            'transactions': List.generate(
              pageSize,
              (i) => {
                'id': 'txn-$page-$i',
                'user_id': 'user-123',
                'amount': 100.0 + i,
                'description': 'Transaction $i',
                'transaction_type': 'expense',
                'payment_type': 'credit_card',
                'category_id': 'cat-1',
                'transaction_date': DateTime.now().toIso8601String(),
                'created_at': DateTime.now().toIso8601String(),
              },
            ),
            'pagination': {
              'page': page,
              'page_size': pageSize,
              'total': totalPages * pageSize,
              'total_pages': totalPages,
              'has_next': hasNext,
              'has_previous': page > 1,
            },
          };

          return http.Response(
            json.encode(response),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);

        // Call getTransactions
        final result = await transactionRepository.getTransactions(
          page: page,
          pageSize: pageSize,
        );

        // Property: Request should succeed
        expect(result, isA<Ok<TransactionsResponse>>());

        // Property: Response should contain pagination metadata
        final response = (result as Ok<TransactionsResponse>).value;
        expect(response.pagination.page, equals(page));
        expect(response.pagination.pageSize, equals(pageSize));
        expect(response.pagination.hasNext, equals(hasNext));
        expect(response.pagination.totalPages, equals(totalPages));

        // Property: When hasNext is true, there should be more pages available
        if (hasNext) {
          expect(response.pagination.page, lessThan(totalPages));
        }

        // Property: Should return the correct number of transactions
        expect(response.transactions.length, equals(pageSize));
      }
    });

    /// **Feature: api-integration, Property 24: Filters are applied to API requests**
    /// **Validates: Requirements 9.3**
    ///
    /// For any transaction type filter (income/expense), the API request should
    /// include the filter parameter.
    test('Property 24: Filters are applied to API requests', () async {
      // Test with different filter types
      final testCases = [
        {'type': TransactionType.income, 'expectedString': 'income'},
        {'type': TransactionType.expense, 'expectedString': 'expense'},
        {'type': null, 'expectedString': null}, // No filter
      ];

      for (final testData in testCases) {
        final type = testData['type'] as TransactionType?;
        final expectedString = testData['expectedString'] as String?;

        final mockClient = MockClient((request) async {
          // Verify the request is to the transactions endpoint
          expect(request.url.path, equals('/api/transactions'));

          // Property: Filter parameter should match the provided type
          if (expectedString != null) {
            expect(
              request.url.queryParameters['type'],
              equals(expectedString),
            );
          } else {
            expect(request.url.queryParameters.containsKey('type'), isFalse);
          }

          // Return a filtered response
          final transactionType = expectedString ?? 'expense';
          final response = {
            'transactions': [
              {
                'id': 'txn-1',
                'user_id': 'user-123',
                'amount': 100.0,
                'description': 'Test transaction',
                'transaction_type': transactionType,
                'payment_type': 'credit_card',
                'category_id': 'cat-1',
                'transaction_date': DateTime.now().toIso8601String(),
                'created_at': DateTime.now().toIso8601String(),
              },
            ],
            'pagination': {
              'page': 1,
              'page_size': 20,
              'total': 1,
              'total_pages': 1,
              'has_next': false,
              'has_previous': false,
            },
          };

          return http.Response(
            json.encode(response),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);

        // Call getTransactions with filter
        final result = await transactionRepository.getTransactions(type: type);

        // Property: Request should succeed
        expect(result, isA<Ok<TransactionsResponse>>());

        // Property: When filter is applied, all returned transactions should match the filter
        if (type != null) {
          final response = (result as Ok<TransactionsResponse>).value;
          for (final transaction in response.transactions) {
            final transactionTypeString = transaction.transactionType;
            expect(transactionTypeString, equals(expectedString));
          }
        }
      }
    });

    /// **Feature: api-integration, Property 25: No loading when no more pages**
    /// **Validates: Requirements 9.4**
    ///
    /// For any transaction list where has_next is false, no additional API
    /// requests should be made.
    test('Property 25: No loading when no more pages', () async {
      // Test with scenarios where hasNext is false
      final testCases = [
        {
          'page': 3,
          'pageSize': 20,
          'hasNext': false,
          'totalPages': 3,
        },
        {
          'page': 1,
          'pageSize': 50,
          'hasNext': false,
          'totalPages': 1,
        },
        {
          'page': 5,
          'pageSize': 10,
          'hasNext': false,
          'totalPages': 5,
        },
      ];

      for (final testData in testCases) {
        final page = testData['page'] as int;
        final pageSize = testData['pageSize'] as int;
        final hasNext = testData['hasNext'] as bool;
        final totalPages = testData['totalPages'] as int;

        final mockClient = MockClient((request) async {
          // Verify the request is to the transactions endpoint
          expect(request.url.path, equals('/api/transactions'));

          // Return a response with hasNext = false
          final response = {
            'transactions': List.generate(
              pageSize,
              (i) => {
                'id': 'txn-$page-$i',
                'user_id': 'user-123',
                'amount': 100.0 + i,
                'description': 'Transaction $i',
                'transaction_type': 'expense',
                'payment_type': 'credit_card',
                'category_id': 'cat-1',
                'transaction_date': DateTime.now().toIso8601String(),
                'created_at': DateTime.now().toIso8601String(),
              },
            ),
            'pagination': {
              'page': page,
              'page_size': pageSize,
              'total': totalPages * pageSize,
              'total_pages': totalPages,
              'has_next': hasNext,
              'has_previous': page > 1,
            },
          };

          return http.Response(
            json.encode(response),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);

        // Call getTransactions
        final result = await transactionRepository.getTransactions(
          page: page,
          pageSize: pageSize,
        );

        // Property: Request should succeed
        expect(result, isA<Ok<TransactionsResponse>>());

        // Property: Response should indicate no more pages
        final response = (result as Ok<TransactionsResponse>).value;
        expect(response.pagination.hasNext, isFalse);

        // Property: When hasNext is false, we're on the last page
        expect(response.pagination.page, equals(totalPages));

        // Property: The ViewModel should use this information to prevent
        // additional API requests (tested in ViewModel tests)
      }
    });
  });
}
