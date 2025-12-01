import 'dart:convert';

import 'package:firebase_ai_testing/data/repositories/auth_repository.dart';
import 'package:firebase_ai_testing/data/repositories/user_repository.dart';
import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/ui/auth/logout/view_models/logout_viewmodel.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('LogoutViewModel Unit Tests', () {
    late LogoutViewModel logoutViewModel;
    late AuthRepository authRepository;
    late UserRepository userRepository;
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    group('logout command', () {
      test('should clear authentication and user cache', () async {
        // Setup with token and user data
        const token = 'valid_token';
        await tokenStorage.saveToken(token);

        final mockClient = MockClient((request) async {
          if (request.url.path == '/api/users/me') {
            final response = {
              'id': 'user-123',
              'name': 'John Doe',
              'email': 'john@example.com',
              'status': 'active',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            };
            return http.Response(json.encode(response), 200);
          }
          return http.Response('{}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = token;
        authRepository = AuthRepository(apiService, tokenStorage);
        userRepository = UserRepository(apiService);

        // Load user data
        await userRepository.getUser();
        expect(userRepository.user, isNotNull);
        expect(await authRepository.isAuthenticated, isTrue);

        logoutViewModel = LogoutViewModel(
          authRepository: authRepository,
          userRepository: userRepository,
        );

        // Execute logout
        await logoutViewModel.logout.execute();

        // Verify logout completed successfully
        expect(logoutViewModel.logout.completed, isTrue);
        expect(logoutViewModel.logout.error, isFalse);

        // Verify authentication is cleared
        expect(await authRepository.isAuthenticated, isFalse);
        expect(await tokenStorage.hasToken(), isFalse);
        expect(apiService.authToken, isNull);

        // Verify user cache is cleared
        expect(userRepository.user, isNull);
      });

      test('should handle logout errors', () async {
        final mockClient = MockClient((request) async {
          return http.Response('{}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);
        userRepository = UserRepository(apiService);

        logoutViewModel = LogoutViewModel(
          authRepository: authRepository,
          userRepository: userRepository,
        );

        // Execute logout (should succeed even without token)
        await logoutViewModel.logout.execute();

        expect(logoutViewModel.logout.completed, isTrue);
      });

      test('should return success result on successful logout', () async {
        const token = 'valid_token';
        await tokenStorage.saveToken(token);

        final mockClient = MockClient((request) async {
          return http.Response('{}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = token;
        authRepository = AuthRepository(apiService, tokenStorage);
        userRepository = UserRepository(apiService);

        logoutViewModel = LogoutViewModel(
          authRepository: authRepository,
          userRepository: userRepository,
        );

        await logoutViewModel.logout.execute();

        expect(logoutViewModel.logout.result, isA<Ok<void>>());
      });
    });

    group('command state', () {
      test('should track running state during logout', () async {
        const token = 'valid_token';
        await tokenStorage.saveToken(token);

        final mockClient = MockClient((request) async {
          // Simulate slow network
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return http.Response('{}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = token;
        authRepository = AuthRepository(apiService, tokenStorage);
        userRepository = UserRepository(apiService);

        logoutViewModel = LogoutViewModel(
          authRepository: authRepository,
          userRepository: userRepository,
        );

        // Start logout without awaiting
        final logoutFuture = logoutViewModel.logout.execute();

        // Check running state
        expect(logoutViewModel.logout.running, isTrue);

        // Wait for completion
        await logoutFuture;

        expect(logoutViewModel.logout.running, isFalse);
        expect(logoutViewModel.logout.completed, isTrue);
      });

      test('should allow clearing result', () async {
        final mockClient = MockClient((request) async {
          return http.Response('{}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);
        userRepository = UserRepository(apiService);

        logoutViewModel = LogoutViewModel(
          authRepository: authRepository,
          userRepository: userRepository,
        );

        await logoutViewModel.logout.execute();
        expect(logoutViewModel.logout.completed, isTrue);

        logoutViewModel.logout.clearResult();
        expect(logoutViewModel.logout.completed, isFalse);
      });
    });

    group('coordination', () {
      test('should coordinate both repositories in correct order', () async {
        const token = 'valid_token';
        await tokenStorage.saveToken(token);

        final mockClient = MockClient((request) async {
          if (request.url.path == '/api/users/me') {
            final response = {
              'id': 'user-123',
              'name': 'John Doe',
              'email': 'john@example.com',
              'status': 'active',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            };
            return http.Response(json.encode(response), 200);
          }
          return http.Response('{}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = token;
        authRepository = AuthRepository(apiService, tokenStorage);
        userRepository = UserRepository(apiService);

        // Setup initial state
        await userRepository.getUser();
        expect(userRepository.user, isNotNull);
        expect(await authRepository.isAuthenticated, isTrue);

        logoutViewModel = LogoutViewModel(
          authRepository: authRepository,
          userRepository: userRepository,
        );

        // Execute logout
        await logoutViewModel.logout.execute();

        // Both should be cleared
        expect(await authRepository.isAuthenticated, isFalse);
        expect(userRepository.user, isNull);
      });
    });
  });
}
