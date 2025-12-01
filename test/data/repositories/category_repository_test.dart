import 'dart:convert';

import 'package:firebase_ai_testing/data/repositories/category_repository.dart';
import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/domain/models/category.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('CategoryRepository Unit Tests', () {
    late CategoryRepository categoryRepository;
    late ApiService apiService;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
    });

    group('getCategories', () {
      test('should return all categories', () async {
        final mockClient = MockClient((request) async {
          expect(request.url.path, equals('/api/categories'));
          expect(
            request.headers['Authorization'],
            equals('Bearer test_token'),
          );

          final response = [
            {
              'id': 'cat-1',
              'user_id': 'user-123',
              'description': 'Food',
              'icon': '🍔',
              'is_default': true,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            },
            {
              'id': 'cat-2',
              'user_id': 'user-123',
              'description': 'Transport',
              'icon': '🚗',
              'is_default': false,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            },
          ];

          return http.Response(
            json.encode(response),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        categoryRepository = CategoryRepository(apiService);

        final result = await categoryRepository.getCategories();

        expect(result, isA<Ok<List<Category>>>());
        final categories = (result as Ok<List<Category>>).value;
        expect(categories.length, equals(2));
        expect(categories[0].description, equals('Food'));
        expect(categories[0].icon, equals('🍔'));
        expect(categories[0].isDefault, isTrue);
        expect(categories[1].description, equals('Transport'));
        expect(categories[1].isDefault, isFalse);
      });
    });

    group('createCategory', () {
      test('should create category with valid data', () async {
        final mockClient = MockClient((request) async {
          expect(request.url.path, equals('/api/categories'));
          expect(
            request.headers['Authorization'],
            equals('Bearer test_token'),
          );

          final body = json.decode(request.body) as Map<String, dynamic>;
          expect(body['description'], equals('Shopping'));
          expect(body['icon'], equals('🛒'));

          final response = {
            'id': 'cat-new',
            'user_id': 'user-123',
            'description': 'Shopping',
            'icon': '🛒',
            'is_default': false,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          return http.Response(
            json.encode(response),
            201,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        categoryRepository = CategoryRepository(apiService);

        final result = await categoryRepository.createCategory(
          'Shopping',
          '🛒',
        );

        expect(result, isA<Ok<Category>>());
        final category = (result as Ok<Category>).value;
        expect(category.description, equals('Shopping'));
        expect(category.icon, equals('🛒'));
        expect(category.isDefault, isFalse);
      });

      test('should handle API error (400)', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Invalid category data'}),
            400,
          );
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        categoryRepository = CategoryRepository(apiService);

        final result = await categoryRepository.createCategory(
          'Invalid',
          null,
        );

        expect(result, isA<Error<Category>>());
        final error = (result as Error<Category>).error;
        expect(error, isA<ApiException>());
        expect((error as ApiException).statusCode, equals(400));
      });
    });

    group('updateCategory', () {
      test('should update category with valid data', () async {
        final mockClient = MockClient((request) async {
          expect(request.url.path, equals('/api/categories/cat-123'));
          expect(
            request.headers['Authorization'],
            equals('Bearer test_token'),
          );

          final body = json.decode(request.body) as Map<String, dynamic>;
          expect(body['description'], equals('Updated Food'));
          expect(body['icon'], equals('🍕'));

          final response = {
            'id': 'cat-123',
            'user_id': 'user-123',
            'description': 'Updated Food',
            'icon': '🍕',
            'is_default': false,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          return http.Response(
            json.encode(response),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        categoryRepository = CategoryRepository(apiService);

        final result = await categoryRepository.updateCategory(
          'cat-123',
          'Updated Food',
          '🍕',
        );

        expect(result, isA<Ok<Category>>());
        final category = (result as Ok<Category>).value;
        expect(category.id, equals('cat-123'));
        expect(category.description, equals('Updated Food'));
        expect(category.icon, equals('🍕'));
      });

      test('should handle permission error (403)', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Permission denied'}),
            403,
          );
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        categoryRepository = CategoryRepository(apiService);

        final result = await categoryRepository.updateCategory(
          'cat-other',
          'Updated',
          null,
        );

        expect(result, isA<Error<Category>>());
        final error = (result as Error<Category>).error as ApiException;
        expect(error, isA<ApiException>());
        expect(error.statusCode, equals(403));
        expect(
          error.message,
          contains('não tem permissão'),
        );
      });
    });

    group('deleteCategory', () {
      test('should delete category with valid id', () async {
        final mockClient = MockClient((request) async {
          expect(request.url.path, equals('/api/categories/cat-123'));
          expect(
            request.headers['Authorization'],
            equals('Bearer test_token'),
          );

          return http.Response('', 204);
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        categoryRepository = CategoryRepository(apiService);

        final result = await categoryRepository.deleteCategory('cat-123');

        expect(result, isA<Ok<void>>());
      });

      test('should handle not found error (404)', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Category not found'}),
            404,
          );
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        categoryRepository = CategoryRepository(apiService);

        final result = await categoryRepository.deleteCategory(
          'cat-nonexistent',
        );

        expect(result, isA<Error<void>>());
        final error = (result as Error<void>).error as ApiException;
        expect(error, isA<ApiException>());
        expect(error.statusCode, equals(404));
        expect(
          error.message,
          contains('não encontrada'),
        );
      });
    });
  });
}
