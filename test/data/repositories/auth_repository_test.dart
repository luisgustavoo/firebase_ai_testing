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
  group('AuthRepository Unit Tests', () {
    late AuthRepository authRepository;
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    group('register', () {
      test('should register user with valid data', () async {
        final mockClient = MockClient((request) async {
          expect(request.url.path, equals('/api/users/register'));

          final body = json.decode(request.body) as Map<String, dynamic>;
          expect(body['name'], equals('John Doe'));
          expect(body['email'], equals('john@example.com'));
          expect(body['password'], equals('password123'));

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

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);

        final result = await authRepository.register(
          'John Doe',
          'john@example.com',
          'password123',
        );

        expect(result, isA<Ok<User>>());
        final user = (result as Ok<User>).value;
        expect(user.name, equals('John Doe'));
        expect(user.email, equals('john@example.com'));
        expect(user.status, equals(UserStatus.active));
      });

      test('should handle duplicate email error (400)', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Email already exists'}),
            400,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);

        final result = await authRepository.register(
          'John Doe',
          'existing@example.com',
          'password123',
        );

        expect(result, isA<Error<User>>());
        final error = (result as Error<User>).error;
        expect(error, isA<ApiException>());
        expect((error as ApiException).statusCode, equals(400));
      });
    });

    group('login', () {
      test('should login with valid credentials', () async {
        final mockClient = MockClient((request) async {
          expect(request.url.path, equals('/api/users/login'));

          final body = json.decode(request.body) as Map<String, dynamic>;
          expect(body['email'], equals('john@example.com'));
          expect(body['password'], equals('password123'));

          final response = {
            'token': 'jwt_token_abc123',
            'user': {
              'id': 'user-123',
              'name': 'John Doe',
              'email': 'john@example.com',
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

        final result = await authRepository.login(
          'john@example.com',
          'password123',
        );

        expect(result, isA<Ok<LoginResponse>>());
        final loginResponse = (result as Ok<LoginResponse>).value;
        expect(loginResponse.token, equals('jwt_token_abc123'));
        expect(loginResponse.user.email, equals('john@example.com'));

        // Verify token is stored
        final storedToken = await tokenStorage.getToken();
        expect(storedToken, equals('jwt_token_abc123'));

        // Verify API service has token
        expect(apiService.authToken, equals('jwt_token_abc123'));
      });

      test('should handle invalid credentials (401)', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Invalid credentials'}),
            401,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);

        final result = await authRepository.login(
          'john@example.com',
          'wrongpassword',
        );

        expect(result, isA<Error<LoginResponse>>());
        final error = (result as Error<LoginResponse>).error;
        expect(error, isA<ApiException>());
        expect((error as ApiException).statusCode, equals(401));

        // Verify token is not stored
        final hasToken = await tokenStorage.hasToken();
        expect(hasToken, isFalse);
      });
    });

    group('logout', () {
      test('should clear token', () async {
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

        await authRepository.logout();

        // Verify token is cleared
        expect(await tokenStorage.hasToken(), isFalse);
        expect(apiService.authToken, isNull);
      });
    });

    group('isAuthenticated', () {
      test('should return true when token exists', () async {
        await tokenStorage.saveToken('test_token');

        final mockClient = MockClient((request) async {
          return http.Response('{}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);

        final isAuth = await authRepository.isAuthenticated;
        expect(isAuth, isTrue);
      });

      test('should return false when no token exists', () async {
        final mockClient = MockClient((request) async {
          return http.Response('{}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);

        final isAuth = await authRepository.isAuthenticated;
        expect(isAuth, isFalse);
      });
    });
  });
}
