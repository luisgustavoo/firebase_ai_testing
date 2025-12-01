import 'dart:convert';

import 'package:firebase_ai_testing/data/repositories/user_repository.dart';
import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('UserRepository Unit Tests', () {
    late UserRepository userRepository;
    late ApiService apiService;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
    });

    group('getUser', () {
      test('should fetch user profile from API when cache is empty', () async {
        const token = 'valid_token';

        final mockClient = MockClient((request) async {
          expect(request.url.path, equals('/api/users/me'));
          expect(
            request.headers['Authorization'],
            equals('Bearer $token'),
          );

          final response = {
            'id': 'user-123',
            'name': 'John Doe',
            'email': 'john@example.com',
            'status': 'active',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          return http.Response(json.encode(response), 200);
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer $token';
        userRepository = UserRepository(apiService);

        final result = await userRepository.getUser();

        expect(result, isA<Ok<User>>());
        final user = (result as Ok<User>).value;
        expect(user.name, equals('John Doe'));
        expect(user.email, equals('john@example.com'));
        expect(user.status, equals(UserStatus.active));
      });

      test('should return cached user without API call', () async {
        var apiCallCount = 0;

        final mockClient = MockClient((request) async {
          apiCallCount++;
          final response = {
            'id': 'user-123',
            'name': 'John Doe',
            'email': 'john@example.com',
            'status': 'active',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          return http.Response(json.encode(response), 200);
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        userRepository = UserRepository(apiService);

        // First call - should fetch from API
        await userRepository.getUser();
        expect(apiCallCount, equals(1));

        // Second call - should use cache
        final result = await userRepository.getUser();
        expect(apiCallCount, equals(1)); // No additional API call

        expect(result, isA<Ok<User>>());
        final user = (result as Ok<User>).value;
        expect(user.name, equals('John Doe'));
      });

      test('should handle API errors', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Server error'}),
            500,
          );
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        userRepository = UserRepository(apiService);

        final result = await userRepository.getUser();

        expect(result, isA<Error<User>>());
        final error = (result as Error<User>).error;
        expect(error, isA<ApiException>());
        expect((error as ApiException).statusCode, equals(500));
      });
    });

    group('refreshUser', () {
      test('should fetch fresh data from API bypassing cache', () async {
        var apiCallCount = 0;

        final mockClient = MockClient((request) async {
          apiCallCount++;
          final response = {
            'id': 'user-123',
            'name': 'John Doe $apiCallCount',
            'email': 'john@example.com',
            'status': 'active',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          return http.Response(json.encode(response), 200);
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        userRepository = UserRepository(apiService);

        // First call - populate cache
        await userRepository.getUser();
        expect(apiCallCount, equals(1));

        // Refresh - should make new API call
        final result = await userRepository.refreshUser();
        expect(apiCallCount, equals(2));

        expect(result, isA<Ok<User>>());
        final user = (result as Ok<User>).value;
        expect(user.name, equals('John Doe 2'));
      });
    });

    group('clearUser', () {
      test('should clear cached user data', () async {
        final mockClient = MockClient((request) async {
          final response = {
            'id': 'user-123',
            'name': 'John Doe',
            'email': 'john@example.com',
            'status': 'active',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          return http.Response(json.encode(response), 200);
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        userRepository = UserRepository(apiService);

        // Populate cache
        await userRepository.getUser();
        expect(userRepository.user, isNotNull);

        // Clear cache
        userRepository.clearUser();
        expect(userRepository.user, isNull);
      });
    });

    group('notifyListeners', () {
      test('should notify listeners when user data is fetched', () async {
        var notificationCount = 0;

        final mockClient = MockClient((request) async {
          final response = {
            'id': 'user-123',
            'name': 'John Doe',
            'email': 'john@example.com',
            'status': 'active',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          return http.Response(json.encode(response), 200);
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        userRepository = UserRepository(apiService)
          ..addListener(() {
            notificationCount++;
          });

        await userRepository.getUser();
        expect(notificationCount, greaterThan(0));
      });

      test('should notify listeners when cache is cleared', () async {
        var notificationCount = 0;

        final mockClient = MockClient((request) async {
          final response = {
            'id': 'user-123',
            'name': 'John Doe',
            'email': 'john@example.com',
            'status': 'active',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          return http.Response(json.encode(response), 200);
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        userRepository = UserRepository(apiService);

        // Populate cache
        await userRepository.getUser();

        // Add listener after cache is populated
        userRepository
          ..addListener(() {
            notificationCount++;
          })
          // Clear cache
          ..clearUser();
        expect(notificationCount, equals(1));
      });
    });
  });
}
