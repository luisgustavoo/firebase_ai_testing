import 'package:firebase_ai_testing/data/services/api/models/category_api.dart';
import 'package:firebase_ai_testing/data/services/api/models/category_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/create_transaction_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/login_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/login_response.dart';
import 'package:firebase_ai_testing/data/services/api/models/pagination_metadata.dart';
import 'package:firebase_ai_testing/data/services/api/models/register_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction_api.dart';
import 'package:firebase_ai_testing/data/services/api/models/transactions_response.dart';
import 'package:firebase_ai_testing/data/services/api/models/user_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserApi', () {
    test('fromJson creates UserApi from JSON', () {
      final json = {
        'id': '123',
        'name': 'John Doe',
        'email': 'john@example.com',
        'status': 'active',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      };

      final user = UserApi.fromJson(json);

      expect(user.id, '123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.status, 'active');
      expect(user.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
      expect(user.updatedAt, DateTime.parse('2024-01-02T00:00:00.000Z'));
    });

    test('toJson converts UserApi to JSON', () {
      final user = UserApi(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        status: 'active',
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['status'], 'active');
      expect(json['created_at'], '2024-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2024-01-02T00:00:00.000Z');
    });
  });

  group('LoginRequest', () {
    test('toJson converts LoginRequest to JSON', () {
      const request = LoginRequest(
        email: 'test@example.com',
        password: 'password123',
      );

      final json = request.toJson();

      expect(json['email'], 'test@example.com');
      expect(json['password'], 'password123');
    });

    test('fromJson creates LoginRequest from JSON', () {
      final json = {
        'email': 'test@example.com',
        'password': 'password123',
      };

      final request = LoginRequest.fromJson(json);

      expect(request.email, 'test@example.com');
      expect(request.password, 'password123');
    });
  });

  group('RegisterRequest', () {
    test('toJson converts RegisterRequest to JSON', () {
      const request = RegisterRequest(
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
      );

      final json = request.toJson();

      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['password'], 'password123');
    });

    test('fromJson creates RegisterRequest from JSON', () {
      final json = {
        'name': 'John Doe',
        'email': 'john@example.com',
        'password': 'password123',
      };

      final request = RegisterRequest.fromJson(json);

      expect(request.name, 'John Doe');
      expect(request.email, 'john@example.com');
      expect(request.password, 'password123');
    });
  });

  group('LoginResponse', () {
    test('fromJson creates LoginResponse from JSON', () {
      final json = {
        'token': 'jwt-token-123',
        'user': {
          'id': '123',
          'name': 'John Doe',
          'email': 'john@example.com',
          'status': 'active',
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-02T00:00:00.000Z',
        },
      };

      final response = LoginResponse.fromJson(json);

      expect(response.token, 'jwt-token-123');
      expect(response.user.id, '123');
      expect(response.user.name, 'John Doe');
    });

    test('toJson converts LoginResponse to JSON', () {
      final response = LoginResponse(
        token: 'jwt-token-123',
        user: UserApi(
          id: '123',
          name: 'John Doe',
          email: 'john@example.com',
          status: 'active',
          createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
          updatedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
        ),
      );

      final json = response.toJson();

      expect(json['token'], 'jwt-token-123');
      // The user object is serialized by json_serializable
      expect(json['user'], isA<Map<String, dynamic>>());
    });
  });

  group('CategoryApi', () {
    test('fromJson creates CategoryApi from JSON', () {
      final json = {
        'id': 'cat-123',
        'user_id': 'user-456',
        'description': 'Food',
        'icon': '🍔',
        'is_default': false,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      };

      final category = CategoryApi.fromJson(json);

      expect(category.id, 'cat-123');
      expect(category.userId, 'user-456');
      expect(category.description, 'Food');
      expect(category.icon, '🍔');
      expect(category.isDefault, false);
      expect(category.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
      expect(category.updatedAt, DateTime.parse('2024-01-02T00:00:00.000Z'));
    });

    test('fromJson handles null icon', () {
      final json = {
        'id': 'cat-123',
        'user_id': 'user-456',
        'description': 'Food',
        'icon': null,
        'is_default': true,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      };

      final category = CategoryApi.fromJson(json);

      expect(category.icon, null);
      expect(category.isDefault, true);
    });

    test('toJson converts CategoryApi to JSON', () {
      final category = CategoryApi(
        id: 'cat-123',
        userId: 'user-456',
        description: 'Food',
        icon: '🍔',
        isDefault: false,
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
      );

      final json = category.toJson();

      expect(json['id'], 'cat-123');
      expect(json['user_id'], 'user-456');
      expect(json['description'], 'Food');
      expect(json['icon'], '🍔');
      expect(json['is_default'], false);
    });
  });

  group('CategoryRequest', () {
    test('toJson converts CategoryRequest to JSON', () {
      const request = CategoryRequest(
        description: 'Transportation',
        icon: '🚗',
      );

      final json = request.toJson();

      expect(json['description'], 'Transportation');
      expect(json['icon'], '🚗');
    });

    test('toJson handles null icon', () {
      const request = CategoryRequest(
        description: 'Transportation',
      );

      final json = request.toJson();

      expect(json['description'], 'Transportation');
      expect(json['icon'], null);
    });

    test('fromJson creates CategoryRequest from JSON', () {
      final json = {
        'description': 'Updated Category',
        'icon': '✨',
      };

      final request = CategoryRequest.fromJson(json);

      expect(request.description, 'Updated Category');
      expect(request.icon, '✨');
    });
  });

  group('TransactionApi', () {
    test('fromJson creates TransactionApi from JSON', () {
      final json = {
        'id': 'txn-123',
        'user_id': 'user-456',
        'category_id': 'cat-789',
        'amount': 50.75,
        'description': 'Lunch',
        'transaction_type': 'expense',
        'payment_type': 'credit_card',
        'transaction_date': '2024-01-15T12:30:00.000Z',
        'created_at': '2024-01-15T12:35:00.000Z',
      };

      final transaction = TransactionApi.fromJson(json);

      expect(transaction.id, 'txn-123');
      expect(transaction.userId, 'user-456');
      expect(transaction.categoryId, 'cat-789');
      expect(transaction.amount, 50.75);
      expect(transaction.description, 'Lunch');
      expect(transaction.transactionType, 'expense');
      expect(transaction.paymentType, 'credit_card');
      expect(
        transaction.transactionDate,
        DateTime.parse('2024-01-15T12:30:00.000Z'),
      );
      expect(transaction.createdAt, DateTime.parse('2024-01-15T12:35:00.000Z'));
    });

    test('fromJson handles null category_id and description', () {
      final json = {
        'id': 'txn-123',
        'user_id': 'user-456',
        'category_id': null,
        'amount': 100.0,
        'description': null,
        'transaction_type': 'income',
        'payment_type': 'pix',
        'transaction_date': '2024-01-15T12:30:00.000Z',
        'created_at': '2024-01-15T12:35:00.000Z',
      };

      final transaction = TransactionApi.fromJson(json);

      expect(transaction.categoryId, null);
      expect(transaction.description, null);
      expect(transaction.transactionType, 'income');
    });

    test('toJson converts TransactionApi to JSON with ISO 8601 dates', () {
      final transaction = TransactionApi(
        id: 'txn-123',
        userId: 'user-456',
        categoryId: 'cat-789',
        amount: 50.75,
        description: 'Lunch',
        transactionType: 'expense',
        paymentType: 'credit_card',
        transactionDate: DateTime.parse('2024-01-15T12:30:00.000Z'),
        createdAt: DateTime.parse('2024-01-15T12:35:00.000Z'),
      );

      final json = transaction.toJson();

      expect(json['transaction_date'], '2024-01-15T12:30:00.000Z');
      expect(json['created_at'], '2024-01-15T12:35:00.000Z');
    });
  });

  group('CreateTransactionRequest', () {
    test('toJson converts CreateTransactionRequest to JSON', () {
      final request = CreateTransactionRequest(
        categoryId: 'cat-123',
        amount: 75.50,
        description: 'Dinner',
        transactionType: 'expense',
        paymentType: 'debit_card',
        transactionDate: DateTime.parse('2024-01-20T19:00:00.000Z'),
      );

      final json = request.toJson();

      expect(json['category_id'], 'cat-123');
      expect(json['amount'], 75.50);
      expect(json['description'], 'Dinner');
      expect(json['transaction_type'], 'expense');
      expect(json['payment_type'], 'debit_card');
      expect(json['transaction_date'], '2024-01-20T19:00:00.000Z');
    });

    test('toJson formats date to ISO 8601', () {
      final request = CreateTransactionRequest(
        amount: 100,
        transactionType: 'income',
        paymentType: 'pix',
        transactionDate: DateTime.utc(2024, 3, 15, 10, 30, 45),
      );

      final json = request.toJson();

      expect(json['transaction_date'], '2024-03-15T10:30:45.000Z');
    });

    test('toJson handles null category_id and description', () {
      final request = CreateTransactionRequest(
        amount: 200,
        transactionType: 'income',
        paymentType: 'money',
        transactionDate: DateTime.parse('2024-01-20T19:00:00.000Z'),
      );

      final json = request.toJson();

      expect(json['category_id'], null);
      expect(json['description'], null);
    });
  });

  group('PaginationMetadata', () {
    test('fromJson creates PaginationMetadata from JSON', () {
      final json = {
        'page': 2,
        'page_size': 20,
        'total': 150,
        'total_pages': 8,
        'has_next': true,
        'has_previous': true,
      };

      final pagination = PaginationMetadata.fromJson(json);

      expect(pagination.page, 2);
      expect(pagination.pageSize, 20);
      expect(pagination.total, 150);
      expect(pagination.totalPages, 8);
      expect(pagination.hasNext, true);
      expect(pagination.hasPrevious, true);
    });

    test('toJson converts PaginationMetadata to JSON', () {
      const pagination = PaginationMetadata(
        page: 1,
        pageSize: 20,
        total: 45,
        totalPages: 3,
        hasNext: true,
        hasPrevious: false,
      );

      final json = pagination.toJson();

      expect(json['page'], 1);
      expect(json['page_size'], 20);
      expect(json['total'], 45);
      expect(json['total_pages'], 3);
      expect(json['has_next'], true);
      expect(json['has_previous'], false);
    });
  });

  group('TransactionsResponse', () {
    test('fromJson creates TransactionsResponse from JSON', () {
      final json = {
        'transactions': [
          {
            'id': 'txn-1',
            'user_id': 'user-1',
            'category_id': 'cat-1',
            'amount': 50.0,
            'description': 'Test',
            'transaction_type': 'expense',
            'payment_type': 'credit_card',
            'transaction_date': '2024-01-15T12:30:00.000Z',
            'created_at': '2024-01-15T12:35:00.000Z',
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

      final response = TransactionsResponse.fromJson(json);

      expect(response.transactions.length, 1);
      expect(response.transactions[0].id, 'txn-1');
      expect(response.pagination.page, 1);
      expect(response.pagination.hasNext, false);
    });

    test('toJson converts TransactionsResponse to JSON', () {
      final response = TransactionsResponse(
        transactions: [
          TransactionApi(
            id: 'txn-1',
            userId: 'user-1',
            categoryId: 'cat-1',
            amount: 50,
            description: 'Test',
            transactionType: 'expense',
            paymentType: 'credit_card',
            transactionDate: DateTime.parse('2024-01-15T12:30:00.000Z'),
            createdAt: DateTime.parse('2024-01-15T12:35:00.000Z'),
          ),
        ],
        pagination: const PaginationMetadata(
          page: 1,
          pageSize: 20,
          total: 1,
          totalPages: 1,
          hasNext: false,
          hasPrevious: false,
        ),
      );

      final json = response.toJson();

      expect(json['transactions'], isA<List<dynamic>>());
      expect((json['transactions'] as List<dynamic>).length, 1);
      // The pagination object is serialized by json_serializable
      expect(json['pagination'], isA<Map<String, dynamic>>());
    });
  });

  group('Date Parsing and Formatting', () {
    test('dates are parsed correctly from ISO 8601 strings', () {
      const dateString = '2024-01-15T12:30:45.123Z';
      final parsed = DateTime.parse(dateString);

      expect(parsed.year, 2024);
      expect(parsed.month, 1);
      expect(parsed.day, 15);
      expect(parsed.hour, 12);
      expect(parsed.minute, 30);
      expect(parsed.second, 45);
    });

    test('dates are formatted to ISO 8601 strings', () {
      final date = DateTime.utc(2024, 3, 20, 14, 30);
      final formatted = date.toIso8601String();

      expect(formatted, '2024-03-20T14:30:00.000Z');
    });

    test('transaction date round-trip maintains ISO 8601 format', () {
      const originalDate = '2024-01-15T12:30:00.000Z';
      final transaction = TransactionApi(
        id: 'txn-1',
        userId: 'user-1',
        amount: 100,
        transactionType: 'income',
        paymentType: 'pix',
        transactionDate: DateTime.parse(originalDate),
        createdAt: DateTime.parse(originalDate),
      );

      final json = transaction.toJson();
      final roundTrip = TransactionApi.fromJson(json);

      expect(json['transaction_date'], originalDate);
      expect(roundTrip.transactionDate.toIso8601String(), originalDate);
    });
  });
}
