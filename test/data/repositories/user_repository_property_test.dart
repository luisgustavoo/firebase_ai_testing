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
  group('UserRepository Property Tests', () {
    late UserRepository userRepository;
    late ApiService apiService;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
    });

    /// **Feature: api-integration, Property 7: Authenticated requests fetch profile data**
    /// **Validates: Requirements 3.1**
    ///
    /// For any authenticated user with valid token, profile request should return
    /// user information matching the authenticated user.
    test('Property 7: Authenticated requests fetch profile data', () async {
      // Test with multiple user profiles
      final testProfiles = [
        {
          'id': 'user-1',
          'name': 'Alice Smith',
          'email': 'alice@example.com',
          'status': 'active',
        },
        {
          'id': 'user-2',
          'name': 'Bob Johnson',
          'email': 'bob@test.com',
          'status': 'active',
        },
        {
          'id': 'user-3',
          'name': 'Charlie Brown',
          'email': 'charlie@domain.org',
          'status': 'inactive',
        },
      ];

      for (final profileData in testProfiles) {
        final token = 'valid_token_for_${profileData['id']}';

        final mockClient = MockClient((request) async {
          // Verify the request is to the profile endpoint
          expect(request.url.path, equals('/api/users/me'));

          // Property: Request should include the Bearer token
          expect(
            request.headers['Authorization'],
            equals('Bearer $token'),
          );

          // Return the user profile
          final response = {
            'id': profileData['id'],
            'name': profileData['name'],
            'email': profileData['email'],
            'status': profileData['status'],
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          return http.Response(json.encode(response), 200);
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer $token';
        userRepository = UserRepository(apiService);

        // Call getUser
        final result = await userRepository.getUser();

        // Property: Profile fetch should succeed
        expect(result, isA<Ok<User>>());

        // Property: Returned user should match the expected profile
        final user = (result as Ok<User>).value;
        expect(user.id, equals(profileData['id']));
        expect(user.name, equals(profileData['name']));
        expect(user.email, equals(profileData['email']));
        expect(
          user.status,
          equals(
            profileData['status'] == 'active'
                ? UserStatus.active
                : UserStatus.inactive,
          ),
        );
      }
    });

    /// Property: Cache consistency
    /// For any user data, fetching twice should return the same data without additional API calls
    test('Property: Cache returns consistent data', () async {
      final testUsers = [
        {'name': 'Alice', 'email': 'alice@test.com'},
        {'name': 'Bob', 'email': 'bob@test.com'},
        {'name': 'Charlie', 'email': 'charlie@test.com'},
      ];

      for (final userData in testUsers) {
        var apiCallCount = 0;

        final mockClient = MockClient((request) async {
          apiCallCount++;
          final response = {
            'id': 'user-${userData['name']}',
            'name': userData['name'],
            'email': userData['email'],
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

        // First call
        final result1 = await userRepository.getUser();
        expect(result1, isA<Ok<User>>());
        final user1 = (result1 as Ok<User>).value;

        // Second call - should use cache
        final result2 = await userRepository.getUser();
        expect(result2, isA<Ok<User>>());
        final user2 = (result2 as Ok<User>).value;

        // Property: Only one API call should be made
        expect(apiCallCount, equals(1));

        // Property: Both results should be identical
        expect(user1.id, equals(user2.id));
        expect(user1.name, equals(user2.name));
        expect(user1.email, equals(user2.email));
      }
    });

    /// Property: Refresh bypasses cache
    /// For any cached user data, refresh should always fetch fresh data from API
    test('Property: Refresh always fetches from API', () async {
      // Test multiple times to ensure consistency
      for (var i = 0; i < 3; i++) {
        var apiCallCount = 0;

        final mockClient = MockClient((request) async {
          apiCallCount++;
          final response = {
            'id': 'user-123',
            'name': 'User $apiCallCount',
            'email': 'user@test.com',
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

        // Initial fetch
        await userRepository.getUser();
        final initialCallCount = apiCallCount;

        // Refresh
        final result = await userRepository.refreshUser();

        // Property: Refresh should make a new API call
        expect(apiCallCount, equals(initialCallCount + 1));

        // Property: Result should be successful
        expect(result, isA<Ok<User>>());
      }
    });

    /// Property: Clear removes cache
    /// For any cached user data, clearing should remove it and force next getUser to fetch from API
    test('Property: Clear removes cached data', () async {
      final testUsers = [
        'Alice',
        'Bob',
        'Charlie',
      ];

      for (final userName in testUsers) {
        var apiCallCount = 0;

        final mockClient = MockClient((request) async {
          apiCallCount++;
          final response = {
            'id': 'user-$userName',
            'name': userName,
            'email': '$userName@test.com',
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

        // Fetch and cache
        await userRepository.getUser();
        expect(apiCallCount, equals(1));

        // Property: user getter should return cached data
        expect(userRepository.user, isNotNull);
        expect(userRepository.user!.name, equals(userName));

        // Clear cache
        userRepository.clearUser();

        // Property: user getter should return null after clear
        expect(userRepository.user, isNull);

        // Fetch again - should make new API call
        await userRepository.getUser();

        // Property: Should have made 2 API calls total
        expect(apiCallCount, equals(2));
      }
    });
  });
}
