import 'dart:convert';

import 'package:firebase_ai_testing/data/repositories/auth_repository.dart';
import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';
import 'package:firebase_ai_testing/ui/auth/view_models/auth_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('AuthViewModel Property Tests', () {
    late AuthViewModel authViewModel;
    late AuthRepository authRepository;
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    /// **Feature: api-integration, Property 3: Successful registration stores user data**
    /// **Validates: Requirements 1.4**
    ///
    /// For any successful registration, the user information should be available
    /// after the operation completes.
    test('Property 3: Successful registration stores user data', () async {
      // Test with multiple valid user data combinations
      final testCases = [
        {
          'name': 'John Doe',
          'email': 'john@example.com',
          'password': 'password123',
        },
        {
          'name': 'Alice Smith',
          'email': 'alice.smith@test.co.uk',
          'password': '123456',
        },
        {
          'name': 'Bob Johnson',
          'email': 'bob+test@domain.org',
          'password': 'securePass',
        },
      ];

      for (final testData in testCases) {
        final name = testData['name']!;
        final email = testData['email']!;
        final password = testData['password']!;

        final mockClient = MockClient((request) async {
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

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        authRepository = AuthRepository(apiService, tokenStorage);
        authViewModel = AuthViewModel(authRepository);

        // Property: currentUser should be null before registration
        expect(authViewModel.currentUser, isNull);
        expect(await authViewModel.isAuthenticated, isFalse);

        // Call register
        await authViewModel.registerCommand.execute(
          RegisterParams(name: name, email: email, password: password),
        );

        // Property: Registration should succeed
        expect(authViewModel.registerCommand.completed, isTrue);
        expect(authViewModel.registerCommand.error, isFalse);

        // Property: User data should be stored in ViewModel after successful registration
        expect(authViewModel.currentUser, isNotNull);
        expect(authViewModel.currentUser!.name, equals(name));
        expect(authViewModel.currentUser!.email, equals(email));
        expect(authViewModel.currentUser!.status, equals(UserStatus.active));

        // Note: isAuthenticated is false after registration (no token stored)
        // User needs to login to get authenticated
        expect(await authViewModel.isAuthenticated, isFalse);
      }
    });

    /// **Feature: api-integration, Property 6: Stored token enables authentication check**
    /// **Validates: Requirements 2.5**
    ///
    /// For any valid stored token, the AuthViewModel should recognize
    /// the user as authenticated without requiring explicit login.
    test('Property 6: Stored token enables authentication check', () async {
      // Test with multiple tokens
      final testTokens = [
        'token_1',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test',
        'very_long_token_${'x' * 100}',
      ];

      for (final token in testTokens) {
        // Store token (simulating previous login)
        await tokenStorage.saveToken(token);

        final mockClient = MockClient((request) async {
          return http.Response('{}', 200);
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        authRepository = AuthRepository(apiService, tokenStorage);
        authViewModel = AuthViewModel(authRepository);

        // Property: ViewModel should recognize authentication with stored token
        expect(await authViewModel.isAuthenticated, isTrue);
        expect(await authRepository.isAuthenticated, isTrue);

        // Property: Token should be available in storage
        final hasToken = await tokenStorage.hasToken();
        expect(hasToken, isTrue);

        final storedToken = await tokenStorage.getToken();
        expect(storedToken, equals(token));

        // Clean up
        await tokenStorage.deleteToken();
      }
    });

    /// **Feature: api-integration, Property 10: UI reactively reflects data changes**
    /// **Validates: Requirements 1.4, 2.5, 4.5**
    ///
    /// For any data change (category added, transaction created, list updated),
    /// notifyListeners should be called and observers should be notified.
    test('Property 10: UI reactively reflects data changes', () async {
      // Test that notifyListeners is called for various state changes
      final testScenarios = [
        {
          'action': 'register',
          'name': 'Test User',
          'email': 'test@example.com',
          'password': 'password123',
        },
        {
          'action': 'login',
          'email': 'user@example.com',
          'password': '123456',
        },
        {
          'action': 'logout',
        },
      ];

      for (final scenario in testScenarios) {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('register')) {
            final response = {
              'id': 'user-123',
              'name': scenario['name'],
              'email': scenario['email'],
              'status': 'active',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            };
            return http.Response(json.encode(response), 200);
          } else if (request.url.path.contains('login')) {
            final response = {
              'token': 'test_token',
              'user': {
                'id': 'user-123',
                'name': 'Test User',
                'email': scenario['email'],
                'status': 'active',
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              },
            };
            return http.Response(json.encode(response), 200);
          }
          return http.Response('{}', 200);
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        apiService.authHeaderProvider = () => 'Bearer test_token';
        authRepository = AuthRepository(apiService, tokenStorage);
        authViewModel = AuthViewModel(authRepository);

        // Track listener notifications
        var notificationCount = 0;
        authViewModel.addListener(() {
          notificationCount++;
        });

        // Execute action
        if (scenario['action'] == 'register') {
          await authViewModel.registerCommand.execute(
            RegisterParams(
              name: scenario['name']!,
              email: scenario['email']!,
              password: scenario['password']!,
            ),
          );
        } else if (scenario['action'] == 'login') {
          await authViewModel.loginCommand.execute(
            LoginParams(
              email: scenario['email']!,
              password: scenario['password']!,
            ),
          );
        } else if (scenario['action'] == 'logout') {
          await authViewModel.logoutCommand.execute();
        }

        // Property: notifyListeners should be called (notification count > 0)
        expect(notificationCount, greaterThan(0));

        // Clean up
        await tokenStorage.deleteToken();
      }
    });
  });
}
