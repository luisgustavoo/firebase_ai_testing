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
  group('TransactionViewModel Property Tests', () {
    late TransactionViewModel transactionViewModel;
    late TransactionRepository transactionRepository;
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    /// **Feature: api-integration, Property 8: Loading state is shown during async operations**
    /// **Validates: Requirements 8.7, 9.5, 9.8**
    ///
    /// For any async operation (transaction load), the loading state should be
    /// true during execution and false after completion.
    test(
      'Property 8: Loading state is shown during async operations',
      () async {
        // Test with multiple scenarios
        final testCases = [
          {
            'scenario': 'load transactions',
            'page': 1,
            'pageSize': 20,
          },
          {
            'scenario': 'load with filter',
            'page': 1,
            'pageSize': 10,
          },
        ];

        for (final testData in testCases) {
          final mockClient = MockClient((request) async {
            // Simulate network delay
            await Future<void>.delayed(const Duration(milliseconds: 50));

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
                'page': testData['page'],
                'page_size': testData['pageSize'],
                'total': 1,
                'total_pages': 1,
                'has_next': false,
                'has_previous': false,
              },
            };

            return http.Response(json.encode(response), 200);
          });

          apiService = ApiService(tokenStorage, mockClient);
          await apiService.init();
          transactionRepository = TransactionRepository(apiService);
          transactionViewModel = TransactionViewModel(transactionRepository);

          // Property: Command should not be running initially
          expect(transactionViewModel.loadTransactionsCommand.running, isFalse);

          // Start async operation
          final loadFuture = transactionViewModel.loadTransactionsCommand
              .execute();

          // Property: Command should be running during operation
          // Note: We need to wait a tiny bit for the state to update
          await Future<void>.delayed(const Duration(milliseconds: 1));
          expect(transactionViewModel.loadTransactionsCommand.running, isTrue);

          // Wait for completion
          await loadFuture;

          // Property: Command should not be running after completion
          expect(transactionViewModel.loadTransactionsCommand.running, isFalse);
          expect(
            transactionViewModel.loadTransactionsCommand.completed,
            isTrue,
          );
        }
      },
    );

    /// **Feature: api-integration, Property 10: UI reactively reflects data changes**
    /// **Validates: Requirements 8.7, 9.5, 9.8**
    ///
    /// For any data change (transaction created, list loaded, filter changed),
    /// notifyListeners should be called and observers should be notified.
    test('Property 10: UI reactively reflects data changes', () async {
      // Test that notifyListeners is called for various state changes
      final testScenarios = [
        {
          'action': 'loadTransactions',
        },
        {
          'action': 'createTransaction',
          'amount': 50.0,
          'type': 'income',
        },
        {
          'action': 'setFilter',
          'filter': 'expense',
        },
      ];

      for (final scenario in testScenarios) {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('transactions') &&
              request.method == 'POST') {
            // Create transaction response
            final response = {
              'id': 'txn-new',
              'user_id': 'user-1',
              'amount': scenario['amount'] ?? 100.0,
              'transaction_type': scenario['type'] ?? 'expense',
              'payment_type': 'credit_card',
              'transaction_date': DateTime.now().toIso8601String(),
              'created_at': DateTime.now().toIso8601String(),
            };
            return http.Response(json.encode(response), 201);
          } else {
            // Get transactions response
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
                'page_size': 20,
                'total': 1,
                'total_pages': 1,
                'has_next': false,
                'has_previous': false,
              },
            };
            return http.Response(json.encode(response), 200);
          }
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        transactionRepository = TransactionRepository(apiService);
        transactionViewModel = TransactionViewModel(transactionRepository);

        // Track listener notifications
        var notificationCount = 0;
        transactionViewModel.addListener(() {
          notificationCount++;
        });

        // Execute action
        if (scenario['action'] == 'loadTransactions') {
          await transactionViewModel.loadTransactionsCommand.execute();
        } else if (scenario['action'] == 'createTransaction') {
          final request = CreateTransactionRequest(
            amount: (scenario['amount']! as num).toDouble(),
            transactionType: scenario['type']! as String,
            paymentType: 'credit_card',
            transactionDate: DateTime.now(),
          );
          await transactionViewModel.createTransactionCommand.execute(
            CreateTransactionParams(request: request),
          );
        } else if (scenario['action'] == 'setFilter') {
          await transactionViewModel.setFilter(TransactionType.expense);
        }

        // Property: notifyListeners should be called (notification count > 0)
        expect(notificationCount, greaterThan(0));
      }
    });
  });
}
