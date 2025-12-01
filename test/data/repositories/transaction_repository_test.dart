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
  group('TransactionRepository Unit Tests', () {
    late TransactionRepository transactionRepository;
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    group('createTransaction', () {
      test('should create transaction with valid data', () async {
        final mockClient = MockClient((request) async {
          expect(request.url.path, equals('/api/transactions'));
          expect(request.method, equals('POST'));
          expect(
            request.headers['Authorization'],
            equals('Bearer test_token'),
          );

          final body = json.decode(request.body) as Map<String, dynamic>;
          expect(body['amount'], equals(150.0));
          expect(body['description'], equals('Grocery shopping'));
          expect(body['transaction_type'], equals('expense'));
          expect(body['payment_type'], equals('credit_card'));
          expect(body['category_id'], equals('cat-1'));

          final response = {
            'id': 'txn-123',
            'user_id': 'user-123',
            'amount': 150.0,
            'description': 'Grocery shopping',
            'transaction_type': 'expense',
            'payment_type': 'credit_card',
            'category_id': 'cat-1',
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
        apiService.authToken = 'test_token';
        transactionRepository = TransactionRepository(apiService);

        final request = CreateTransactionRequest(
          amount: 150,
          description: 'Grocery shopping',
          transactionType: 'expense',
          paymentType: 'credit_card',
          categoryId: 'cat-1',
          transactionDate: DateTime.now(),
        );

        final result = await transactionRepository.createTransaction(request);

        expect(result, isA<Ok<Transaction>>());
        final transaction = (result as Ok<Transaction>).value;
        expect(transaction.id, equals('txn-123'));
        expect(transaction.amount, equals(150.0));
        expect(transaction.description, equals('Grocery shopping'));
        expect(transaction.transactionType, equals(TransactionType.expense));
        expect(transaction.paymentType, equals(PaymentType.creditCard));
        expect(transaction.categoryId, equals('cat-1'));
      });

      test('should handle API error (400)', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Invalid transaction data'}),
            400,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = 'test_token';
        transactionRepository = TransactionRepository(apiService);

        final request = CreateTransactionRequest(
          amount: -50, // Invalid amount
          description: 'Invalid transaction',
          transactionType: 'expense',
          paymentType: 'credit_card',
          categoryId: 'cat-1',
          transactionDate: DateTime.now(),
        );

        final result = await transactionRepository.createTransaction(request);

        expect(result, isA<Error<Transaction>>());
        final error = (result as Error<Transaction>).error;
        expect(error, isA<ApiException>());
        expect((error as ApiException).statusCode, equals(400));
      });

      test('should create transaction with null category_id', () async {
        final mockClient = MockClient((request) async {
          final body = json.decode(request.body) as Map<String, dynamic>;
          expect(body['category_id'], isNull);

          final response = {
            'id': 'txn-456',
            'user_id': 'user-123',
            'amount': 75.0,
            'description': 'Cash payment',
            'transaction_type': 'expense',
            'payment_type': 'money',
            'category_id': null,
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
        apiService.authToken = 'test_token';
        transactionRepository = TransactionRepository(apiService);

        final request = CreateTransactionRequest(
          amount: 75,
          description: 'Cash payment',
          transactionType: 'expense',
          paymentType: 'money',
          transactionDate: DateTime.now(),
        );

        final result = await transactionRepository.createTransaction(request);

        expect(result, isA<Ok<Transaction>>());
        final transaction = (result as Ok<Transaction>).value;
        expect(transaction.categoryId, isNull);
      });
    });

    group('getTransactions', () {
      test('should get transactions with default pagination', () async {
        final mockClient = MockClient((request) async {
          expect(request.url.path, equals('/api/transactions'));
          expect(
            request.headers['Authorization'],
            equals('Bearer test_token'),
          );

          // Verify default pagination parameters
          expect(request.url.queryParameters['page'], equals('1'));
          expect(request.url.queryParameters['pageSize'], equals('20'));
          expect(request.url.queryParameters.containsKey('type'), isFalse);

          final response = {
            'transactions': [
              {
                'id': 'txn-1',
                'user_id': 'user-123',
                'amount': 100.0,
                'description': 'Transaction 1',
                'transaction_type': 'expense',
                'payment_type': 'credit_card',
                'category_id': 'cat-1',
                'transaction_date': DateTime.now().toIso8601String(),
                'created_at': DateTime.now().toIso8601String(),
              },
              {
                'id': 'txn-2',
                'user_id': 'user-123',
                'amount': 200.0,
                'description': 'Transaction 2',
                'transaction_type': 'income',
                'payment_type': 'pix',
                'category_id': 'cat-2',
                'transaction_date': DateTime.now().toIso8601String(),
                'created_at': DateTime.now().toIso8601String(),
              },
            ],
            'pagination': {
              'page': 1,
              'page_size': 20,
              'total': 2,
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
        apiService.authToken = 'test_token';
        transactionRepository = TransactionRepository(apiService);

        final result = await transactionRepository.getTransactions();

        expect(result, isA<Ok<TransactionsResponse>>());
        final response = (result as Ok<TransactionsResponse>).value;
        expect(response.transactions.length, equals(2));
        expect(response.pagination.page, equals(1));
        expect(response.pagination.pageSize, equals(20));
        expect(response.pagination.hasNext, isFalse);
      });

      test('should get transactions with custom page size', () async {
        final mockClient = MockClient((request) async {
          expect(request.url.path, equals('/api/transactions'));

          // Verify custom pagination parameters
          expect(request.url.queryParameters['page'], equals('2'));
          expect(request.url.queryParameters['pageSize'], equals('10'));

          final response = {
            'transactions': List.generate(
              10,
              (i) => {
                'id': 'txn-$i',
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
              'page': 2,
              'page_size': 10,
              'total': 25,
              'total_pages': 3,
              'has_next': true,
              'has_previous': true,
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
        apiService.authToken = 'test_token';
        transactionRepository = TransactionRepository(apiService);

        final result = await transactionRepository.getTransactions(
          page: 2,
          pageSize: 10,
        );

        expect(result, isA<Ok<TransactionsResponse>>());
        final response = (result as Ok<TransactionsResponse>).value;
        expect(response.transactions.length, equals(10));
        expect(response.pagination.page, equals(2));
        expect(response.pagination.pageSize, equals(10));
        expect(response.pagination.hasNext, isTrue);
        expect(response.pagination.hasPrevious, isTrue);
      });

      test('should get transactions with type filter', () async {
        final mockClient = MockClient((request) async {
          expect(request.url.path, equals('/api/transactions'));

          // Verify filter parameter
          expect(request.url.queryParameters['type'], equals('income'));

          final response = {
            'transactions': [
              {
                'id': 'txn-1',
                'user_id': 'user-123',
                'amount': 5000.0,
                'description': 'Salary',
                'transaction_type': 'income',
                'payment_type': 'pix',
                'category_id': 'cat-salary',
                'transaction_date': DateTime.now().toIso8601String(),
                'created_at': DateTime.now().toIso8601String(),
              },
              {
                'id': 'txn-2',
                'user_id': 'user-123',
                'amount': 1500.0,
                'description': 'Freelance',
                'transaction_type': 'income',
                'payment_type': 'pix',
                'category_id': 'cat-freelance',
                'transaction_date': DateTime.now().toIso8601String(),
                'created_at': DateTime.now().toIso8601String(),
              },
            ],
            'pagination': {
              'page': 1,
              'page_size': 20,
              'total': 2,
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
        apiService.authToken = 'test_token';
        transactionRepository = TransactionRepository(apiService);

        final result = await transactionRepository.getTransactions(
          type: TransactionType.income,
        );

        expect(result, isA<Ok<TransactionsResponse>>());
        final response = (result as Ok<TransactionsResponse>).value;
        expect(response.transactions.length, equals(2));

        // Verify all transactions are income type
        for (final transaction in response.transactions) {
          expect(transaction.transactionType, equals('income'));
        }
      });

      test('should handle network errors', () async {
        final mockClient = MockClient((request) async {
          throw Exception('Network error');
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = 'test_token';
        transactionRepository = TransactionRepository(apiService);

        final result = await transactionRepository.getTransactions();

        expect(result, isA<Error<TransactionsResponse>>());
      });
    });
  });
}
