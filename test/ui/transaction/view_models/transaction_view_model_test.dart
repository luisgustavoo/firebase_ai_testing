import 'dart:convert';

import 'package:firebase_ai_testing/data/repositories/transaction_repository.dart';
import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_request/create_transaction_request.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:firebase_ai_testing/ui/transaction/view_models/transaction_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('TransactionViewModel Unit Tests', () {
    late TransactionViewModel transactionViewModel;
    late TransactionRepository transactionRepository;
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    group('createTransaction command', () {
      test('should add transaction to list', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/transactions') &&
              request.method == 'POST') {
            final response = {
              'id': 'txn-1',
              'user_id': 'user-1',
              'amount': 100.0,
              'description': 'Test transaction',
              'transaction_type': 'expense',
              'payment_type': 'credit_card',
              'transaction_date': DateTime.now().toIso8601String(),
              'created_at': DateTime.now().toIso8601String(),
            };
            return http.Response(json.encode(response), 201);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);
        transactionViewModel = TransactionViewModel(transactionRepository);

        expect(transactionViewModel.transactions, isEmpty);

        final request = CreateTransactionRequest(
          amount: 100,
          description: 'Test transaction',
          transactionType: 'expense',
          paymentType: 'credit_card',
          transactionDate: DateTime.now(),
        );

        await transactionViewModel.createTransactionCommand.execute(
          CreateTransactionParams(request: request),
        );

        expect(transactionViewModel.createTransactionCommand.completed, isTrue);
        expect(transactionViewModel.transactions, hasLength(1));
        expect(transactionViewModel.transactions[0].amount, equals(100.0));
        expect(
          transactionViewModel.transactions[0].description,
          equals('Test transaction'),
        );

        await tokenStorage.deleteToken();
      });
    });

    group('loadTransactions command', () {
      test('should populate list', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/transactions') &&
              request.method == 'GET') {
            final response = {
              'transactions': [
                {
                  'id': 'txn-1',
                  'user_id': 'user-1',
                  'amount': 100.0,
                  'transaction_type': 'expense',
                  'payment_type': 'credit_card',
                  'transaction_date': DateTime.now().toIso8601String(),
                  'created_at': DateTime.now().toIso8601String(),
                },
                {
                  'id': 'txn-2',
                  'user_id': 'user-1',
                  'amount': 50.0,
                  'transaction_type': 'income',
                  'payment_type': 'pix',
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

            return http.Response(json.encode(response), 200);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);
        transactionViewModel = TransactionViewModel(transactionRepository);

        expect(transactionViewModel.transactions, isEmpty);

        await transactionViewModel.loadTransactionsCommand.execute();

        expect(transactionViewModel.loadTransactionsCommand.completed, isTrue);
        expect(transactionViewModel.transactions, hasLength(2));
        expect(transactionViewModel.transactions[0].amount, equals(100.0));
        expect(transactionViewModel.transactions[1].amount, equals(50.0));
        expect(transactionViewModel.pagination, isNotNull);
        expect(transactionViewModel.pagination!.page, equals(1));

        await tokenStorage.deleteToken();
      });
    });

    group('loadMore command', () {
      test('should append to list', () async {
        var requestCount = 0;
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/transactions') &&
              request.method == 'GET') {
            requestCount++;

            if (requestCount == 1) {
              // First page
              final response = {
                'transactions': [
                  {
                    'id': 'txn-1',
                    'user_id': 'user-1',
                    'amount': 100.0,
                    'transaction_type': 'expense',
                    'payment_type': 'credit_card',
                    'transaction_date': DateTime.now().toIso8601String(),
                    'created_at': DateTime.now().toIso8601String(),
                  },
                ],
                'pagination': {
                  'page': 1,
                  'page_size': 1,
                  'total': 2,
                  'total_pages': 2,
                  'has_next': true,
                  'has_previous': false,
                },
              };
              return http.Response(json.encode(response), 200);
            } else {
              // Second page
              final response = {
                'transactions': [
                  {
                    'id': 'txn-2',
                    'user_id': 'user-1',
                    'amount': 50.0,
                    'transaction_type': 'income',
                    'payment_type': 'pix',
                    'transaction_date': DateTime.now().toIso8601String(),
                    'created_at': DateTime.now().toIso8601String(),
                  },
                ],
                'pagination': {
                  'page': 2,
                  'page_size': 1,
                  'total': 2,
                  'total_pages': 2,
                  'has_next': false,
                  'has_previous': true,
                },
              };
              return http.Response(json.encode(response), 200);
            }
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);
        transactionViewModel = TransactionViewModel(transactionRepository);

        // Load first page
        await transactionViewModel.loadTransactionsCommand.execute();
        expect(transactionViewModel.transactions, hasLength(1));
        expect(transactionViewModel.hasMore, isTrue);

        // Load more
        await transactionViewModel.loadMoreCommand.execute();

        expect(transactionViewModel.loadMoreCommand.completed, isTrue);
        expect(transactionViewModel.transactions, hasLength(2));
        expect(transactionViewModel.transactions[0].id, equals('txn-1'));
        expect(transactionViewModel.transactions[1].id, equals('txn-2'));
        expect(transactionViewModel.hasMore, isFalse);

        await tokenStorage.deleteToken();
      });
    });

    group('setFilter', () {
      test('should reload with filter', () async {
        var lastFilter = '';
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/transactions') &&
              request.method == 'GET') {
            // Capture the filter from query params
            lastFilter = request.url.queryParameters['type'] ?? '';

            final response = {
              'transactions': [
                {
                  'id': 'txn-1',
                  'user_id': 'user-1',
                  'amount': 100.0,
                  'transaction_type': lastFilter.isEmpty
                      ? 'expense'
                      : lastFilter,
                  'payment_type': 'credit_card',
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

            return http.Response(json.encode(response), 200);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);
        transactionViewModel = TransactionViewModel(transactionRepository);

        // Load without filter
        await transactionViewModel.loadTransactionsCommand.execute();
        expect(lastFilter, isEmpty);

        // Set filter
        await transactionViewModel.setFilter(TransactionType.income);

        expect(transactionViewModel.filter, equals(TransactionType.income));
        expect(lastFilter, equals('income'));
        expect(transactionViewModel.transactions, hasLength(1));

        await tokenStorage.deleteToken();
      });
    });

    group('hasMore', () {
      test('should be based on pagination', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/transactions')) {
            final response = {
              'transactions': <Transaction>[],
              'pagination': {
                'page': 1,
                'page_size': 20,
                'total': 0,
                'total_pages': 0,
                'has_next': false,
                'has_previous': false,
              },
            };
            return http.Response(json.encode(response), 200);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);
        transactionViewModel = TransactionViewModel(transactionRepository);

        // Initially hasMore should be false (no pagination data)
        expect(transactionViewModel.hasMore, isFalse);

        await transactionViewModel.loadTransactionsCommand.execute();

        // After loading, hasMore should match pagination.hasNext
        expect(transactionViewModel.hasMore, isFalse);

        await tokenStorage.deleteToken();
      });
    });

    group('loading state', () {
      test('should be true during operations', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/transactions')) {
            await Future<void>.delayed(const Duration(milliseconds: 50));
            final response = {
              'transactions': <Transaction>[],
              'pagination': {
                'page': 1,
                'page_size': 20,
                'total': 0,
                'total_pages': 0,
                'has_next': false,
                'has_previous': false,
              },
            };
            return http.Response(json.encode(response), 200);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);
        transactionViewModel = TransactionViewModel(transactionRepository);

        // Command should not be running initially
        expect(transactionViewModel.loadTransactionsCommand.running, isFalse);

        var wasRunning = false;
        transactionViewModel.loadTransactionsCommand.addListener(() {
          if (transactionViewModel.loadTransactionsCommand.running) {
            wasRunning = true;
          }
        });

        await transactionViewModel.loadTransactionsCommand.execute();

        // Command should have been running at some point
        expect(wasRunning, isTrue);
        // Command should not be running after completion
        expect(transactionViewModel.loadTransactionsCommand.running, isFalse);
        expect(transactionViewModel.loadTransactionsCommand.completed, isTrue);

        await tokenStorage.deleteToken();
      });
    });

    group('notifyListeners', () {
      test('should be called after loadTransactions', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/transactions')) {
            final response = {
              'transactions': <Transaction>[],
              'pagination': {
                'page': 1,
                'page_size': 20,
                'total': 0,
                'total_pages': 0,
                'has_next': false,
                'has_previous': false,
              },
            };
            return http.Response(json.encode(response), 200);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);
        transactionViewModel = TransactionViewModel(transactionRepository);

        var notificationCount = 0;
        transactionViewModel.addListener(() {
          notificationCount++;
        });

        await transactionViewModel.loadTransactionsCommand.execute();

        expect(notificationCount, greaterThan(0));

        await tokenStorage.deleteToken();
      });

      test('should be called after createTransaction', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/transactions') &&
              request.method == 'POST') {
            final response = {
              'id': 'txn-1',
              'user_id': 'user-1',
              'amount': 100.0,
              'transaction_type': 'expense',
              'payment_type': 'credit_card',
              'transaction_date': DateTime.now().toIso8601String(),
              'created_at': DateTime.now().toIso8601String(),
            };
            return http.Response(json.encode(response), 201);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);
        transactionViewModel = TransactionViewModel(transactionRepository);

        var notificationCount = 0;
        transactionViewModel.addListener(() {
          notificationCount++;
        });

        final request = CreateTransactionRequest(
          amount: 100,
          transactionType: 'expense',
          paymentType: 'credit_card',
          transactionDate: DateTime.now(),
        );

        await transactionViewModel.createTransactionCommand.execute(
          CreateTransactionParams(request: request),
        );

        expect(notificationCount, greaterThan(0));

        await tokenStorage.deleteToken();
      });
    });

    group('error handling', () {
      test('should handle API errors', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Server error'}),
            500,
          );
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);
        transactionViewModel = TransactionViewModel(transactionRepository);

        await transactionViewModel.loadTransactionsCommand.execute();

        // Command should be in error state
        expect(transactionViewModel.loadTransactionsCommand.error, isTrue);
        expect(transactionViewModel.loadTransactionsCommand.completed, isFalse);

        await tokenStorage.deleteToken();
      });

      test('should clear error with clearResult()', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Server error'}),
            500,
          );
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);
        transactionViewModel = TransactionViewModel(transactionRepository);

        await transactionViewModel.loadTransactionsCommand.execute();

        expect(transactionViewModel.loadTransactionsCommand.error, isTrue);

        // Clear the command result
        transactionViewModel.loadTransactionsCommand.clearResult();

        expect(transactionViewModel.loadTransactionsCommand.error, isFalse);
        expect(transactionViewModel.loadTransactionsCommand.completed, isFalse);

        await tokenStorage.deleteToken();
      });
    });
  });
}
