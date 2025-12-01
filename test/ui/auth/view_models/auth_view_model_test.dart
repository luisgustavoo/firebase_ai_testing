import 'dart:convert';

import 'package:firebase_ai_testing/data/repositories/auth_repository.dart';
import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/ui/auth/view_models/auth_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('AuthViewModel Unit Tests', () {
    late AuthViewModel authViewModel;
    late AuthRepository authRepository;
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    group('register command', () {
      test('should update currentUser with valid data', () async {
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
        authRepository = AuthRepository(apiService, tokenStorage);
        authViewModel = AuthViewModel(authRepository);

        await authViewModel.registerCommand.execute(
          RegisterParams(
            name: 'John Doe',
            email: 'john@example.com',
            password: 'password123',
          ),
        );

        expect(authViewModel.registerCommand.completed, isTrue);
        expect(authViewModel.currentUser, isNotNull);
        expect(authViewModel.currentUser!.name, equals('John Doe'));
        expect(authViewModel.currentUser!.email, equals('john@example.com'));
      });
    });

    group('login command', () {
      test('should update currentUser and isAuthenticated', () async {
        final mockClient = MockClient((request) async {
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

        apiService = ApiService(mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);
        authViewModel = AuthViewModel(authRepository);

        expect(await authViewModel.isAuthenticated, isFalse);

        await authViewModel.loginCommand.execute(
          LoginParams(
            email: 'john@example.com',
            password: 'password123',
          ),
        );

        expect(authViewModel.loginCommand.completed, isTrue);
        expect(authViewModel.currentUser, isNotNull);
        expect(authViewModel.currentUser!.name, equals('John Doe'));
        expect(authViewModel.currentUser!.email, equals('john@example.com'));
        expect(await authViewModel.isAuthenticated, isTrue);
      });
    });

    group('logout command', () {
      test('should clear currentUser', () async {
        // First login
        final mockClient = MockClient((request) async {
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

        apiService = ApiService(mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);
        authViewModel = AuthViewModel(authRepository);

        // Login first
        await authViewModel.loginCommand.execute(
          LoginParams(
            email: 'john@example.com',
            password: 'password123',
          ),
        );

        expect(await authViewModel.isAuthenticated, isTrue);
        expect(authViewModel.currentUser, isNotNull);

        // Now logout
        await authViewModel.logoutCommand.execute();

        expect(authViewModel.logoutCommand.completed, isTrue);
        expect(authViewModel.currentUser, isNull);
        expect(await authViewModel.isAuthenticated, isFalse);
      });
    });

    group('notifyListeners', () {
      test('should be called after state changes', () async {
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
        authRepository = AuthRepository(apiService, tokenStorage);
        authViewModel = AuthViewModel(authRepository);

        var notificationCount = 0;
        authViewModel.addListener(() {
          notificationCount++;
        });

        // Register should trigger notifications
        await authViewModel.registerCommand.execute(
          RegisterParams(
            name: 'John Doe',
            email: 'john@example.com',
            password: 'password123',
          ),
        );

        expect(notificationCount, greaterThan(0));
      });

      test('should be called after logout', () async {
        final mockClient = MockClient((request) async {
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

        apiService = ApiService(mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);
        authViewModel = AuthViewModel(authRepository);

        // Login first
        await authViewModel.loginCommand.execute(
          LoginParams(
            email: 'john@example.com',
            password: 'password123',
          ),
        );

        var notificationCount = 0;
        authViewModel.addListener(() {
          notificationCount++;
        });

        // Logout should trigger notifications
        await authViewModel.logoutCommand.execute();

        expect(notificationCount, greaterThan(0));
      });
    });

    group('error handling', () {
      test('should handle API errors', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Invalid credentials'}),
            401,
          );
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);
        authViewModel = AuthViewModel(authRepository);

        await authViewModel.loginCommand.execute(
          LoginParams(
            email: 'john@example.com',
            password: 'wrongpassword',
          ),
        );

        // Command should be in error state
        expect(authViewModel.loginCommand.error, isTrue);
        expect(authViewModel.loginCommand.completed, isFalse);
        expect(authViewModel.currentUser, isNull);
        expect(await authViewModel.isAuthenticated, isFalse);
      });

      test('should clear error with clearResult()', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Server error'}),
            500,
          );
        });

        apiService = ApiService(mockClient);
        await apiService.init();
        authRepository = AuthRepository(apiService, tokenStorage);
        authViewModel = AuthViewModel(authRepository);

        // Trigger API error
        await authViewModel.registerCommand.execute(
          RegisterParams(
            name: 'Valid Name',
            email: 'valid@example.com',
            password: 'password123',
          ),
        );

        expect(authViewModel.registerCommand.error, isTrue);

        // Clear the command result
        authViewModel.registerCommand.clearResult();

        expect(authViewModel.registerCommand.error, isFalse);
        expect(authViewModel.registerCommand.completed, isFalse);
      });
    });
  });
}
