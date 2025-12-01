import 'dart:convert';

import 'package:firebase_ai_testing/data/repositories/user_repository.dart';
import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/ui/home/view_models/home_viewmodel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('HomeViewModel Unit Tests', () {
    late HomeViewModel homeViewModel;
    late UserRepository userRepository;
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    group('initialization', () {
      test('should load user data on initialization', () async {
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

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = 'valid_token';
        userRepository = UserRepository(apiService);

        homeViewModel = HomeViewModel(userRepository: userRepository);

        // Wait for async initialization
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(homeViewModel.currentUser, isNotNull);
        expect(homeViewModel.currentUser!.name, equals('John Doe'));
        expect(homeViewModel.userName, equals('John Doe'));
      });

      test('should handle API errors gracefully', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Server error'}),
            500,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = 'valid_token';
        userRepository = UserRepository(apiService);

        homeViewModel = HomeViewModel(userRepository: userRepository);

        // Wait for async initialization
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Should handle error gracefully
        expect(homeViewModel.currentUser, isNull);
        expect(homeViewModel.userName, equals('Usuário'));
      });
    });

    group('userName getter', () {
      test('should return user name when user is loaded', () async {
        final mockClient = MockClient((request) async {
          final response = {
            'id': 'user-123',
            'name': 'Alice Smith',
            'email': 'alice@example.com',
            'status': 'active',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          return http.Response(json.encode(response), 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = 'valid_token';
        userRepository = UserRepository(apiService);

        homeViewModel = HomeViewModel(userRepository: userRepository);

        // Wait for async initialization
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(homeViewModel.userName, equals('Alice Smith'));
      });

      test('should return default name when user is null', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode({'error': 'Not found'}),
            404,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = 'valid_token';
        userRepository = UserRepository(apiService);

        homeViewModel = HomeViewModel(userRepository: userRepository);

        // Wait for async initialization
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(homeViewModel.userName, equals('Usuário'));
      });
    });

    group('repository listener', () {
      test('should update when repository data changes', () async {
        var apiCallCount = 0;

        final mockClient = MockClient((request) async {
          apiCallCount++;
          final response = {
            'id': 'user-123',
            'name': 'User $apiCallCount',
            'email': 'user@example.com',
            'status': 'active',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          return http.Response(json.encode(response), 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = 'valid_token';
        userRepository = UserRepository(apiService);

        homeViewModel = HomeViewModel(userRepository: userRepository);

        // Wait for initial load
        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(homeViewModel.userName, equals('User 1'));

        // Refresh user data in repository
        await userRepository.refreshUser();

        // ViewModel should update automatically
        expect(homeViewModel.userName, equals('User 2'));
      });

      test('should notify listeners when user data changes', () async {
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

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = 'valid_token';
        userRepository = UserRepository(apiService);

        homeViewModel = HomeViewModel(userRepository: userRepository);

        // Wait for initial load
        await Future<void>.delayed(const Duration(milliseconds: 100));

        homeViewModel.addListener(() {
          notificationCount++;
        });

        // Trigger repository change
        await userRepository.refreshUser();

        expect(notificationCount, greaterThan(0));
      });
    });

    group('dispose', () {
      test('should remove listener from repository', () async {
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

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();
        apiService.authToken = 'valid_token';
        userRepository = UserRepository(apiService);

        homeViewModel = HomeViewModel(userRepository: userRepository);

        // Wait for initial load
        await Future<void>.delayed(const Duration(milliseconds: 100));

        var notificationCount = 0;
        homeViewModel
          ..addListener(() {
            notificationCount++;
          })
          // Dispose should remove listener
          ..dispose();

        // Trigger repository change
        await userRepository.refreshUser();

        // ViewModel should not be notified after dispose
        expect(notificationCount, equals(0));
      });
    });
  });
}
