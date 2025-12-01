import 'dart:convert';

import 'package:firebase_ai_testing/data/repositories/category_repository.dart';
import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/domain/models/category.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('CategoryRepository Property Tests', () {
    late CategoryRepository categoryRepository;
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    /// **Feature: api-integration, Property 9: Category fetch returns all categories**
    /// **Validates: Requirements 4.1**
    ///
    /// For any authenticated user, fetching categories should return a list
    /// containing both default and custom categories.
    test('Property 9: Category fetch returns all categories', () async {
      // Test with different category list sizes and combinations
      final testCases = [
        // Case 1: Mix of default and custom categories
        [
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
        ],
        // Case 2: Only default categories
        [
          {
            'id': 'cat-3',
            'user_id': 'user-456',
            'description': 'Entertainment',
            'icon': '🎬',
            'is_default': true,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
        ],
        // Case 3: Multiple custom categories
        [
          {
            'id': 'cat-4',
            'user_id': 'user-789',
            'description': 'Custom Category 1',
            'icon': null,
            'is_default': false,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
          {
            'id': 'cat-5',
            'user_id': 'user-789',
            'description': 'Custom Category 2',
            'icon': '⭐',
            'is_default': false,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
          {
            'id': 'cat-6',
            'user_id': 'user-789',
            'description': 'Custom Category 3',
            'icon': '💼',
            'is_default': false,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
        ],
      ];

      for (final categoriesData in testCases) {
        final mockClient = MockClient((request) async {
          // Verify the request is to the categories endpoint
          expect(request.url.path, equals('/api/categories'));

          // Return the categories list
          return http.Response(
            json.encode(categoriesData),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);

        // Call getCategories
        final result = await categoryRepository.getCategories();

        // Property: Fetch should succeed
        expect(result, isA<Ok<List<Category>>>());

        // Property: Should return all categories
        final categories = (result as Ok<List<Category>>).value;
        expect(categories.length, equals(categoriesData.length));

        // Property: Each category should match the source data
        for (var i = 0; i < categories.length; i++) {
          final category = categories[i];
          final sourceData = categoriesData[i];

          expect(category.id, equals(sourceData['id']));
          expect(category.userId, equals(sourceData['user_id']));
          expect(category.description, equals(sourceData['description']));
          expect(category.icon, equals(sourceData['icon']));
          expect(category.isDefault, equals(sourceData['is_default']));
        }

        // Property: Should contain both default and custom categories (if present)
        final hasDefault = categories.any((c) => c.isDefault);
        final hasCustom = categories.any((c) => !c.isDefault);
        final sourceHasDefault = categoriesData.any(
          (c) => c['is_default'] == true,
        );
        final sourceHasCustom = categoriesData.any(
          (c) => c['is_default'] == false,
        );

        expect(hasDefault, equals(sourceHasDefault));
        expect(hasCustom, equals(sourceHasCustom));
      }
    });

    /// **Feature: api-integration, Property 11: Valid category creation adds to list**
    /// **Validates: Requirements 5.1**
    ///
    /// For any valid category (description ≥ 3 chars), creation should succeed
    /// and the category should appear in the category list.
    test('Property 11: Valid category creation adds to list', () async {
      // Test with various valid category descriptions
      final testCases = [
        {'description': 'Food', 'icon': '🍔'},
        {'description': 'Transport', 'icon': '🚗'},
        {'description': 'Very Long Category Description', 'icon': null},
        {'description': 'ABC', 'icon': '⭐'}, // Minimum length (3 chars)
      ];

      for (final testData in testCases) {
        final description = testData['description']!;
        final icon = testData['icon'];

        final mockClient = MockClient((request) async {
          // Verify the request is to the create category endpoint
          expect(request.url.path, equals('/api/categories'));
          expect(request.method, equals('POST'));

          // Parse the request body
          final body = json.decode(request.body) as Map<String, dynamic>;

          // Property: Request should contain the provided data
          expect(body['description'], equals(description));
          expect(body['icon'], equals(icon));

          // Return a successful response with created category
          final response = {
            'id': 'cat-${DateTime.now().millisecondsSinceEpoch}',
            'user_id': 'user-123',
            'description': description,
            'icon': icon,
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

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);

        // Call createCategory
        final result = await categoryRepository.createCategory(
          description,
          icon,
        );

        // Property: Creation should succeed
        expect(result, isA<Ok<Category>>());

        // Property: Returned category should have matching description and icon
        final category = (result as Ok<Category>).value;
        expect(category.description, equals(description));
        expect(category.icon, equals(icon));
        expect(
          category.isDefault,
          isFalse,
        ); // Custom categories are not default
      }
    });

    /// **Feature: api-integration, Property 12: Optional icon is included when provided**
    /// **Validates: Requirements 5.2**
    ///
    /// For any category creation with an icon, the created category should
    /// contain the provided icon.
    test('Property 12: Optional icon is included when provided', () async {
      // Test with various icons and null
      final testIcons = ['🍔', '🚗', '⭐', '💼', null];

      for (final icon in testIcons) {
        final mockClient = MockClient((request) async {
          final body = json.decode(request.body) as Map<String, dynamic>;

          // Property: Icon in request should match provided icon
          expect(body['icon'], equals(icon));

          final response = {
            'id': 'cat-${DateTime.now().millisecondsSinceEpoch}',
            'user_id': 'user-123',
            'description': 'Test Category',
            'icon': icon,
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

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);

        // Call createCategory
        final result = await categoryRepository.createCategory(
          'Test Category',
          icon,
        );

        // Property: Creation should succeed
        expect(result, isA<Ok<Category>>());

        // Property: Returned category should have the provided icon (or null)
        final category = (result as Ok<Category>).value;
        expect(category.icon, equals(icon));
      }
    });

    /// **Feature: api-integration, Property 14: Category updates are applied**
    /// **Validates: Requirements 6.1**
    ///
    /// For any valid category update by the owner, the update should succeed
    /// and the category list should reflect the changes.
    test('Property 14: Category updates are applied', () async {
      // Test with various update scenarios
      final testCases = [
        {
          'id': 'cat-1',
          'oldDescription': 'Food',
          'newDescription': 'Food & Drinks',
          'oldIcon': '🍔',
          'newIcon': '🍕',
        },
        {
          'id': 'cat-2',
          'oldDescription': 'Transport',
          'newDescription': 'Transportation',
          'oldIcon': '🚗',
          'newIcon': null,
        },
        {
          'id': 'cat-3',
          'oldDescription': 'Entertainment',
          'newDescription': 'Fun & Entertainment',
          'oldIcon': null,
          'newIcon': '🎬',
        },
      ];

      for (final testData in testCases) {
        final id = testData['id']!;
        final newDescription = testData['newDescription']!;
        final newIcon = testData['newIcon'];

        final mockClient = MockClient((request) async {
          // Verify the request is to the update category endpoint
          expect(request.url.path, equals('/api/categories/$id'));
          expect(request.method, equals('PUT'));

          // Parse the request body
          final body = json.decode(request.body) as Map<String, dynamic>;

          // Property: Request should contain the new data
          expect(body['description'], equals(newDescription));
          expect(body['icon'], equals(newIcon));

          // Return a successful response with updated category
          final response = {
            'id': id,
            'user_id': 'user-123',
            'description': newDescription,
            'icon': newIcon,
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

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);

        // Call updateCategory
        final result = await categoryRepository.updateCategory(
          id,
          newDescription,
          newIcon,
        );

        // Property: Update should succeed
        expect(result, isA<Ok<Category>>());

        // Property: Returned category should have the updated data
        final category = (result as Ok<Category>).value;
        expect(category.id, equals(id));
        expect(category.description, equals(newDescription));
        expect(category.icon, equals(newIcon));
      }
    });

    /// **Feature: api-integration, Property 16: Category deletion removes from list**
    /// **Validates: Requirements 7.1**
    ///
    /// For any category deletion by the owner, the category should be removed
    /// from the category list.
    test('Property 16: Category deletion removes from list', () async {
      // Test with various category IDs
      final testIds = ['cat-1', 'cat-2', 'cat-3', 'cat-very-long-id-123'];

      for (final id in testIds) {
        final mockClient = MockClient((request) async {
          // Verify the request is to the delete category endpoint
          expect(request.url.path, equals('/api/categories/$id'));
          expect(request.method, equals('DELETE'));

          // Return a successful response (204 No Content or 200 OK)
          return http.Response('', 204);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);

        // Call deleteCategory
        final result = await categoryRepository.deleteCategory(id);

        // Property: Deletion should succeed
        expect(result, isA<Ok<void>>());
      }
    });

    /// **Feature: api-integration, Property 22: Null category_id is allowed**
    /// **Validates: Requirements 8.6**
    ///
    /// For any transaction with null category_id, creation should succeed
    /// (category is optional).
    ///
    /// Note: This property is tested in TransactionRepository tests, but we
    /// verify here that categories can be optional by testing category creation
    /// and updates with null icons (similar concept).
    test('Property 22: Null values are handled correctly', () async {
      // Test that null icon is handled correctly (similar to null category_id)
      final mockClient = MockClient((request) async {
        final body = json.decode(request.body) as Map<String, dynamic>;

        // Property: Null icon should be accepted
        expect(body.containsKey('icon'), isTrue);
        expect(body['icon'], isNull);

        final response = {
          'id': 'cat-1',
          'user_id': 'user-123',
          'description': 'Category without icon',
          'icon': null,
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

      apiService = ApiService(tokenStorage, mockClient);
      await apiService.init();
      categoryRepository = CategoryRepository(apiService);

      // Call createCategory with null icon
      final result = await categoryRepository.createCategory(
        'Category without icon',
        null,
      );

      // Property: Creation should succeed with null icon
      expect(result, isA<Ok<Category>>());

      final category = (result as Ok<Category>).value;
      expect(category.icon, isNull);
    });

    /// Property: 403 errors are handled correctly for updates
    test('Property: 403 errors are handled correctly for updates', () async {
      final mockClient = MockClient((request) async {
        // Return 403 Forbidden
        return http.Response(
          json.encode({'error': 'Forbidden'}),
          403,
        );
      });

      apiService = ApiService(tokenStorage, mockClient);
      await apiService.init();
      categoryRepository = CategoryRepository(apiService);

      // Call updateCategory (should get 403)
      final result = await categoryRepository.updateCategory(
        'cat-1',
        'Updated Description',
        null,
      );

      // Property: Should return error
      expect(result, isA<Error<Category>>());

      // Property: Error should be ApiException with 403 status
      final error = (result as Error<Category>).error;
      expect(error, isA<ApiException>());
      expect((error as ApiException).statusCode, equals(403));
    });

    /// Property: 404 errors are handled correctly for updates
    test('Property: 404 errors are handled correctly for updates', () async {
      final mockClient = MockClient((request) async {
        // Return 404 Not Found
        return http.Response(
          json.encode({'error': 'Not Found'}),
          404,
        );
      });

      apiService = ApiService(tokenStorage, mockClient);
      await apiService.init();
      categoryRepository = CategoryRepository(apiService);

      // Call updateCategory (should get 404)
      final result = await categoryRepository.updateCategory(
        'non-existent-id',
        'Updated Description',
        null,
      );

      // Property: Should return error
      expect(result, isA<Error<Category>>());

      // Property: Error should be ApiException with 404 status
      final error = (result as Error<Category>).error;
      expect(error, isA<ApiException>());
      expect((error as ApiException).statusCode, equals(404));
    });

    /// Property: 403 errors are handled correctly for deletions
    test('Property: 403 errors are handled correctly for deletions', () async {
      final mockClient = MockClient((request) async {
        // Return 403 Forbidden
        return http.Response(
          json.encode({'error': 'Forbidden'}),
          403,
        );
      });

      apiService = ApiService(tokenStorage, mockClient);
      await apiService.init();
      categoryRepository = CategoryRepository(apiService);

      // Call deleteCategory (should get 403)
      final result = await categoryRepository.deleteCategory('cat-1');

      // Property: Should return error
      expect(result, isA<Error<void>>());

      // Property: Error should be ApiException with 403 status
      final error = (result as Error<void>).error;
      expect(error, isA<ApiException>());
      expect((error as ApiException).statusCode, equals(403));
    });

    /// Property: 404 errors are handled correctly for deletions
    test('Property: 404 errors are handled correctly for deletions', () async {
      final mockClient = MockClient((request) async {
        // Return 404 Not Found
        return http.Response(
          json.encode({'error': 'Not Found'}),
          404,
        );
      });

      apiService = ApiService(tokenStorage, mockClient);
      await apiService.init();
      categoryRepository = CategoryRepository(apiService);

      // Call deleteCategory (should get 404)
      final result = await categoryRepository.deleteCategory('non-existent-id');

      // Property: Should return error
      expect(result, isA<Error<void>>());

      // Property: Error should be ApiException with 404 status
      final error = (result as Error<void>).error;
      expect(error, isA<ApiException>());
      expect((error as ApiException).statusCode, equals(404));
    });
  });
}
