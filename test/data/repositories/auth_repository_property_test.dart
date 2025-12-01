import 'dart:convert';

import 'package:firebase_ai_testing/data/repositories/auth_repository.dart';
import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/api/models/login_response/login_response.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('AuthRepository Property Tests', () {
    late AuthRepository authRepository;
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    /// **Feature: api-integration, Property 1: Valid registration creates user account**
    /// **Validates: Requirements 1.1**
    ///
    /// For any valid user data (name ≥ 3 chars, valid email format, password ≥ 6 chars),
    /// registration should succeed and return user details with matching name and email.
    test('Property 1: Valid registration creates user account', () async {
      // Test with multiple valid user data combinations
      final testCases = [
        {
          'name': 'John Doe',
          'email': 'john@example.com',
          'password': 'password123',
        },
        {
          'name': 'Alice',
          'email': 'alice.smith@test.co.uk',
          'password': '123456',
        },
        {
          'name': 'Bob Johnson',
          'email': 'bob+test@domain.org',
          'password': 'securePass',
        },
        {
          'name': 'Very Long Name With Many Characters',
          'email': 'test@subdomain.example.com',
          'password': 'aVeryLongPasswordWithManyCharacters123',
        },
      ];

      for (final testData in testCases) {
        final name = testData['name']!;
        final email = testData['email']!;
        final password = testData['password']!;

        final mockClient = MockClient((request) async {
          // Verify the request is to the register endpoint
          expect(request.url.path, equals('/api/users/register'));

          // Parse the request body
          final body = json.decode(request.body) as Map<String, dynamic>;

          // Property: Request should contain the provided data
          expect(body['name'], equals(name));
          expect(body['email'], equals(email));
          expect(body['password'], equals(password));

          // Return a successful response with user data
          final response = {
            'id': 'user-${DateTime.now().millisecondsSinceEpoch}',
            'name': name,
            'email': email,
            'status': 'active',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          return http.Response(json.encode(response), 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);

        // Call register
        final result = await authRepository.register(name, email, password);

        // Property: Registration should succeed
        expect(result, isA<Ok<User>>());

        // Property: Returned user should have matching name and email
        final user = (result as Ok<User>).value;
        expect(user.name, equals(name));
        expect(user.email, equals(email));
        expect(user.status, equals(UserStatus.active));
      }
    });

    /// **Feature: api-integration, Property 4: Valid login returns JWT token**
    /// **Validates: Requirements 2.1**
    ///
    /// For any valid credentials, login should succeed and return a non-empty JWT token.
    test('Property 4: Valid login returns JWT token', () async {
      // Test with multiple valid credential combinations
      final testCases = [
        {
          'email': 'user1@example.com',
          'password': 'password123',
          'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test1',
        },
        {
          'email': 'user2@test.com',
          'password': '123456',
          'token': 'jwt_token_abc123',
        },
        {
          'email': 'admin@domain.org',
          'password': 'securePass',
          'token': 'very_long_token_${'x' * 200}',
        },
      ];

      for (final testData in testCases) {
        final email = testData['email']!;
        final password = testData['password']!;
        final expectedToken = testData['token']!;

        final mockClient = MockClient((request) async {
          // Verify the request is to the login endpoint
          expect(request.url.path, equals('/api/users/login'));

          // Parse the request body
          final body = json.decode(request.body) as Map<String, dynamic>;

          // Property: Request should contain the provided credentials
          expect(body['email'], equals(email));
          expect(body['password'], equals(password));

          // Return a successful response with token and user data
          final response = {
            'token': expectedToken,
            'user': {
              'id': 'user-123',
              'name': 'Test User',
              'email': email,
              'status': 'active',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            },
          };

          return http.Response(json.encode(response), 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);

        // Call login
        final result = await authRepository.login(email, password);

        // Property: Login should succeed
        expect(result, isA<Ok<LoginResponse>>());

        // Property: Response should contain a non-empty JWT token
        final loginResponse = (result as Ok<LoginResponse>).value;
        expect(loginResponse.token, isNotEmpty);
        expect(loginResponse.token, equals(expectedToken));
      }
    });

    /// **Feature: api-integration, Property 5: Successful login persists token**
    /// **Validates: Requirements 2.3**
    ///
    /// For any successful login, the JWT token should be stored and retrievable from secure storage.
    test('Property 5: Successful login persists token', () async {
      // Test with multiple tokens
      final testTokens = [
        'token_1',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test',
        'very_long_token_${'x' * 300}',
      ];

      for (final expectedToken in testTokens) {
        // Clear storage before each test
        await tokenStorage.deleteToken();

        final mockClient = MockClient((request) async {
          final response = {
            'token': expectedToken,
            'user': {
              'id': 'user-123',
              'name': 'Test User',
              'email': 'test@example.com',
              'status': 'active',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            },
          };

          return http.Response(json.encode(response), 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);

        // Verify token is not stored before login
        final hasTokenBefore = await tokenStorage.hasToken();
        expect(hasTokenBefore, isFalse);

        // Call login
        final result = await authRepository.login(
          'test@example.com',
          'password123',
        );

        // Property: Login should succeed
        expect(result, isA<Ok<LoginResponse>>());

        // Property: Token should be stored after successful login
        final hasTokenAfter = await tokenStorage.hasToken();
        expect(hasTokenAfter, isTrue);

        // Property: Stored token should match the returned token
        final storedToken = await tokenStorage.getToken();
        expect(storedToken, equals(expectedToken));

        // Property: API service should have the token set
        expect(apiService.authToken, equals(expectedToken));
      }
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

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = token;
        authRepository = AuthRepository(apiService, tokenStorage);

        // Call getProfile
        final result = await authRepository.getProfile();

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

    /// Property: 401 errors clear stored token
    test('Property: 401 errors clear stored token', () async {
      // Store a token first
      const initialToken = 'expired_token';
      await tokenStorage.saveToken(initialToken);

      final mockClient = MockClient((request) async {
        // Return 401 Unauthorized
        return http.Response(
          json.encode({'error': 'Unauthorized'}),
          401,
        );
      });

      apiService = ApiService(tokenStorage, mockClient);
      await apiService.init();
      apiService.authToken = initialToken;
      authRepository = AuthRepository(apiService, tokenStorage);

      // Verify token exists before the call
      expect(await tokenStorage.hasToken(), isTrue);

      // Call getProfile (should get 401)
      final result = await authRepository.getProfile();

      // Property: Should return error
      expect(result, isA<Error<User>>());

      // Property: Token should be cleared after 401
      expect(await tokenStorage.hasToken(), isFalse);
      expect(apiService.authToken, isNull);
    });

    /// Property: Logout clears token
    test('Property: Logout clears token', () async {
      // Store a token first
      const token = 'valid_token';
      await tokenStorage.saveToken(token);

      final mockClient = MockClient((request) async {
        return http.Response('{}', 200);
      });

      apiService = ApiService(tokenStorage, mockClient);
      await apiService.init();
      apiService.authToken = token;
      authRepository = AuthRepository(apiService, tokenStorage);

      // Verify token exists before logout
      expect(await tokenStorage.hasToken(), isTrue);
      expect(apiService.authToken, equals(token));

      // Call logout
      await authRepository.logout();

      // Property: Token should be cleared after logout
      expect(await tokenStorage.hasToken(), isFalse);
      expect(apiService.authToken, isNull);
    });

    /// Property: isAuthenticated reflects token presence
    test('Property: isAuthenticated reflects token presence', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{}', 200);
      });

      apiService = ApiService(tokenStorage, mockClient);
      await apiService.init();
      authRepository = AuthRepository(apiService, tokenStorage);

      // Property: Should be false when no token
      expect(await authRepository.isAuthenticated, isFalse);

      // Store a token
      await tokenStorage.saveToken('test_token');

      // Property: Should be true when token exists
      expect(await authRepository.isAuthenticated, isTrue);

      // Clear token
      await tokenStorage.deleteToken();

      // Property: Should be false after token is cleared
      expect(await authRepository.isAuthenticated, isFalse);
    });
  });
}
