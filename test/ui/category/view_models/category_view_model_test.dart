import 'dart:convert';

import 'package:firebase_ai_testing/data/repositories/category_repository.dart';
import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/ui/category/view_models/category_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('CategoryViewModel Unit Tests', () {
    late CategoryViewModel categoryViewModel;
    late CategoryRepository categoryRepository;
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    group('loadCategories command', () {
      test('should update categories list', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/categories') &&
              request.method == 'GET') {
            final response = [
              {
                'id': 'cat-1',
                'user_id': 'user-1',
                'description': 'Food',
                'icon': 'food',
                'is_default': true,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              },
              {
                'id': 'cat-2',
                'user_id': 'user-1',
                'description': 'Transport',
                'icon': 'transport',
                'is_default': false,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              },
            ];

            return http.Response(json.encode(response), 200);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);
        categoryViewModel = CategoryViewModel(categoryRepository);

        expect(categoryViewModel.categories, isEmpty);

        await categoryViewModel.loadCategoriesCommand.execute();

        expect(categoryViewModel.loadCategoriesCommand.completed, isTrue);
        expect(categoryViewModel.categories, hasLength(2));
        expect(categoryViewModel.categories[0].description, equals('Food'));
        expect(
          categoryViewModel.categories[1].description,
          equals('Transport'),
        );
        expect(categoryViewModel.error, isNull);

        await tokenStorage.deleteToken();
      });
    });

    group('createCategory command', () {
      test('should add category to list', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/categories') &&
              request.method == 'POST') {
            final response = {
              'id': 'cat-1',
              'user_id': 'user-1',
              'description': 'Shopping',
              'icon': 'shopping',
              'is_default': false,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            };
            return http.Response(json.encode(response), 201);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);
        categoryViewModel = CategoryViewModel(categoryRepository);

        expect(categoryViewModel.categories, isEmpty);

        await categoryViewModel.createCategoryCommand.execute(
          CreateCategoryParams(
            description: 'Shopping',
            icon: 'shopping',
          ),
        );

        expect(categoryViewModel.createCategoryCommand.completed, isTrue);
        expect(categoryViewModel.categories, hasLength(1));
        expect(categoryViewModel.categories[0].description, equals('Shopping'));
        expect(categoryViewModel.categories[0].icon, equals('shopping'));
        expect(categoryViewModel.error, isNull);

        await tokenStorage.deleteToken();
      });
    });

    group('updateCategory command', () {
      test('should modify category in list', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/categories') &&
              request.method == 'GET') {
            final response = [
              {
                'id': 'cat-1',
                'user_id': 'user-1',
                'description': 'Food',
                'icon': 'food',
                'is_default': false,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              },
            ];
            return http.Response(json.encode(response), 200);
          } else if (request.url.path.contains('/api/categories/') &&
              request.method == 'PUT') {
            final response = {
              'id': 'cat-1',
              'user_id': 'user-1',
              'description': 'Groceries',
              'icon': 'shopping',
              'is_default': false,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            };
            return http.Response(json.encode(response), 200);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);
        categoryViewModel = CategoryViewModel(categoryRepository);

        // Load initial categories
        await categoryViewModel.loadCategoriesCommand.execute();
        expect(categoryViewModel.categories, hasLength(1));
        expect(categoryViewModel.categories[0].description, equals('Food'));

        // Update category
        await categoryViewModel.updateCategoryCommand.execute(
          UpdateCategoryParams(
            id: 'cat-1',
            description: 'Groceries',
            icon: 'shopping',
          ),
        );

        expect(categoryViewModel.updateCategoryCommand.completed, isTrue);
        expect(categoryViewModel.categories, hasLength(1));
        expect(
          categoryViewModel.categories[0].description,
          equals('Groceries'),
        );
        expect(categoryViewModel.categories[0].icon, equals('shopping'));
        expect(categoryViewModel.error, isNull);

        await tokenStorage.deleteToken();
      });
    });

    group('deleteCategory command', () {
      test('should remove category from list', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/categories') &&
              request.method == 'GET') {
            final response = [
              {
                'id': 'cat-1',
                'user_id': 'user-1',
                'description': 'Food',
                'icon': 'food',
                'is_default': false,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              },
              {
                'id': 'cat-2',
                'user_id': 'user-1',
                'description': 'Transport',
                'icon': 'transport',
                'is_default': false,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              },
            ];
            return http.Response(json.encode(response), 200);
          } else if (request.url.path.contains('/api/categories/') &&
              request.method == 'DELETE') {
            return http.Response('', 204);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);
        categoryViewModel = CategoryViewModel(categoryRepository);

        // Load initial categories
        await categoryViewModel.loadCategoriesCommand.execute();
        expect(categoryViewModel.categories, hasLength(2));

        // Delete category
        await categoryViewModel.deleteCategoryCommand.execute('cat-1');

        expect(categoryViewModel.deleteCategoryCommand.completed, isTrue);
        expect(categoryViewModel.categories, hasLength(1));
        expect(categoryViewModel.categories[0].id, equals('cat-2'));
        expect(categoryViewModel.error, isNull);

        await tokenStorage.deleteToken();
      });
    });

    group('loading state', () {
      test('should be true during operations', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/categories')) {
            await Future<void>.delayed(const Duration(milliseconds: 50));
            return http.Response(json.encode([]), 200);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);
        categoryViewModel = CategoryViewModel(categoryRepository);

        expect(categoryViewModel.isLoading, isFalse);

        var wasLoading = false;
        categoryViewModel.addListener(() {
          if (categoryViewModel.isLoading) {
            wasLoading = true;
          }
        });

        await categoryViewModel.loadCategoriesCommand.execute();

        expect(wasLoading, isTrue);
        expect(categoryViewModel.isLoading, isFalse);

        await tokenStorage.deleteToken();
      });
    });

    group('notifyListeners', () {
      test('should be called after loadCategories', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/categories')) {
            return http.Response(json.encode([]), 200);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);
        categoryViewModel = CategoryViewModel(categoryRepository);

        var notificationCount = 0;
        categoryViewModel.addListener(() {
          notificationCount++;
        });

        await categoryViewModel.loadCategoriesCommand.execute();

        expect(notificationCount, greaterThan(0));

        await tokenStorage.deleteToken();
      });

      test('should be called after createCategory', () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/categories') &&
              request.method == 'POST') {
            final response = {
              'id': 'cat-1',
              'user_id': 'user-1',
              'description': 'Shopping',
              'icon': 'shopping',
              'is_default': false,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            };
            return http.Response(json.encode(response), 201);
          }
          return http.Response('{}', 404);
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);
        categoryViewModel = CategoryViewModel(categoryRepository);

        var notificationCount = 0;
        categoryViewModel.addListener(() {
          notificationCount++;
        });

        await categoryViewModel.createCategoryCommand.execute(
          CreateCategoryParams(
            description: 'Shopping',
            icon: 'shopping',
          ),
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
        categoryRepository = CategoryRepository(apiService);
        categoryViewModel = CategoryViewModel(categoryRepository);

        await categoryViewModel.loadCategoriesCommand.execute();

        expect(categoryViewModel.loadCategoriesCommand.error, isTrue);
        expect(categoryViewModel.error, isNotNull);

        await tokenStorage.deleteToken();
      });

      test('should clear error with clearError()', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Server error'}),
            500,
          );
        });

        await tokenStorage.saveToken('test_token');
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        categoryRepository = CategoryRepository(apiService);
        categoryViewModel = CategoryViewModel(categoryRepository);

        await categoryViewModel.loadCategoriesCommand.execute();

        expect(categoryViewModel.error, isNotNull);

        categoryViewModel.clearError();

        expect(categoryViewModel.error, isNull);

        await tokenStorage.deleteToken();
      });
    });
  });
}
