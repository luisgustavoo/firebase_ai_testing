import 'dart:async';
import 'dart:io';

import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/api/models/register_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/user_api.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ApiService Unit Tests', () {
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    group('Endpoint Methods', () {
      test('getUserProfile returns UserApi model', () async {
        final mockClient = MockClient((request) async {
          expect(request.method, equals('GET'));
          expect(request.url.path, equals('/api/users/me'));
          return http.Response(
            '{"id":"123","name":"Test","email":"test@example.com","status":"active","created_at":"2024-01-01T00:00:00Z","updated_at":"2024-01-01T00:00:00Z"}',
            200,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final result = await apiService.getUserProfile();
        expect(result, isA<Ok<UserApi>>());
        final userApi = (result as Ok<UserApi>).value;
        expect(userApi.id, equals('123'));
        expect(userApi.name, equals('Test'));
        expect(userApi.email, equals('test@example.com'));
      });

      test('getTransactions with query parameters', () async {
        final mockClient = MockClient((request) async {
          expect(request.url.queryParameters['page'], equals('2'));
          expect(request.url.queryParameters['pageSize'], equals('10'));
          expect(request.url.queryParameters['type'], equals('income'));
          return http.Response(
            '{"transactions":[],"pagination":{"page":2,"pageSize":10,"total":0,"totalPages":0,"hasNext":false,"hasPrevious":true}}',
            200,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        await apiService.getTransactions(
          page: 2,
          pageSize: 10,
          type: 'income',
        );
      });

      test('registerUser sends JSON body and returns UserApi', () async {
        final mockClient = MockClient((request) async {
          expect(request.method, equals('POST'));
          expect(
            request.body,
            equals(
              '{"name":"Test","email":"test@example.com","password":"password123"}',
            ),
          );
          expect(request.headers['Content-Type'], equals('application/json'));
          return http.Response(
            '{"id":"123","name":"Test","email":"test@example.com","status":"active","created_at":"2024-01-01T00:00:00Z","updated_at":"2024-01-01T00:00:00Z"}',
            201,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        const request = RegisterRequest(
          name: 'Test',
          email: 'test@example.com',
          password: 'password123',
        );
        final result = await apiService.registerUser(request);
        expect(result, isA<Ok<UserApi>>());
        final userApi = (result as Ok<UserApi>).value;
        expect(userApi.id, equals('123'));
        expect(userApi.name, equals('Test'));
        expect(userApi.email, equals('test@example.com'));
      });

      test('updateCategory sends JSON body', () async {
        final mockClient = MockClient((request) async {
          expect(request.method, equals('PUT'));
          expect(request.url.path, equals('/api/categories/cat-123'));
          expect(request.body, equals('{"description":"Updated"}'));
          return http.Response('{"success": true}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final response =
            await apiService.updateCategory(
                  'cat-123',
                  {'description': 'Updated'},
                )
                as Map<String, dynamic>;
        expect(response, equals({'success': true}));
      });

      test('deleteCategory succeeds', () async {
        final mockClient = MockClient((request) async {
          expect(request.method, equals('DELETE'));
          expect(request.url.path, equals('/api/categories/cat-123'));
          return http.Response('', 204);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final response = await apiService.deleteCategory('cat-123');
        expect(response, isNull);
      });
    });

    group('Error Handling', () {
      test('400 Bad Request returns Error with ApiException', () async {
        final mockClient = MockClient((request) async {
          return http.Response('{"message": "Invalid data"}', 400);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final result = await apiService.getUserProfile();
        expect(result, isA<Error<UserApi>>());
        final error = (result as Error<UserApi>).error;
        expect(error, isA<ApiException>());
        expect((error as ApiException).statusCode, equals(400));
        expect(error.message, contains('Invalid data'));
      });

      test(
        '401 Unauthorized returns Error with session expired message',
        () async {
          final mockClient = MockClient((request) async {
            return http.Response('{"error": "Unauthorized"}', 401);
          });

          apiService = ApiService(tokenStorage, mockClient);
          await apiService.init();

          final result = await apiService.getUserProfile();
          expect(result, isA<Error<UserApi>>());
          final error = (result as Error<UserApi>).error;
          expect(error, isA<ApiException>());
          expect((error as ApiException).statusCode, equals(401));
          expect(
            error.message,
            equals('Sessão expirada. Faça login novamente'),
          );
        },
      );

      test(
        '403 Forbidden returns Error with permission message',
        () async {
          final mockClient = MockClient((request) async {
            return http.Response('{"error": "Forbidden"}', 403);
          });

          apiService = ApiService(tokenStorage, mockClient);
          await apiService.init();

          final result = await apiService.getUserProfile();
          expect(result, isA<Error<UserApi>>());
          final error = (result as Error<UserApi>).error;
          expect(error, isA<ApiException>());
          expect((error as ApiException).statusCode, equals(403));
          expect(
            error.message,
            equals('Você não tem permissão para esta ação'),
          );
        },
      );

      test('404 Not Found returns Error', () async {
        final mockClient = MockClient((request) async {
          return http.Response('{"error": "Not found"}', 404);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final result = await apiService.getUserProfile();
        expect(result, isA<Error<UserApi>>());
        final error = (result as Error<UserApi>).error;
        expect(error, isA<ApiException>());
        expect((error as ApiException).statusCode, equals(404));
        expect(error.message, equals('Recurso não encontrado'));
      });

      test('500 Internal Server Error returns Error', () async {
        final mockClient = MockClient((request) async {
          return http.Response('{"error": "Server error"}', 500);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final result = await apiService.getUserProfile();
        expect(result, isA<Error<UserApi>>());
        final error = (result as Error<UserApi>).error;
        expect(error, isA<ApiException>());
        expect((error as ApiException).statusCode, equals(500));
        expect(
          error.message,
          equals('Erro no servidor. Tente novamente mais tarde'),
        );
      });

      test('Invalid JSON response returns Error', () async {
        final mockClient = MockClient((request) async {
          return http.Response('invalid json', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final result = await apiService.getUserProfile();
        expect(result, isA<Error<UserApi>>());
        final error = (result as Error<UserApi>).error;
        expect(error, isA<ApiException>());
        expect((error as ApiException).message, contains('Failed to parse'));
      });
    });

    group('Network Error Handling', () {
      test('Timeout returns Error with timeout message', () async {
        final mockClient = MockClient((request) async {
          // Simulate a timeout by throwing TimeoutException
          throw TimeoutException('Connection timeout');
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final result = await apiService.getUserProfile();
        expect(result, isA<Error<UserApi>>());
        final error = (result as Error<UserApi>).error;
        expect(error, isA<ApiException>());
        expect(
          (error as ApiException).message,
          equals('Tempo esgotado. Verifique sua conexão'),
        );
      });

      test(
        'SocketException returns Error with no internet message',
        () async {
          final mockClient = MockClient((request) async {
            throw const SocketException('No internet');
          });

          apiService = ApiService(tokenStorage, mockClient);
          await apiService.init();

          final result = await apiService.getUserProfile();
          expect(result, isA<Error<UserApi>>());
          final error = (result as Error<UserApi>).error;
          expect(error, isA<ApiException>());
          expect(
            (error as ApiException).message,
            equals('Sem conexão com a internet'),
          );
        },
      );

      test(
        'Generic exception returns Error with network error message',
        () async {
          final mockClient = MockClient((request) async {
            throw Exception('Unknown error');
          });

          apiService = ApiService(tokenStorage, mockClient);
          await apiService.init();

          final result = await apiService.getUserProfile();
          expect(result, isA<Error<UserApi>>());
          final error = (result as Error<UserApi>).error;
          expect(error, isA<ApiException>());
          expect((error as ApiException).message, contains('Erro de rede'));
        },
      );
    });

    group('Headers', () {
      test('Default headers include Content-Type and Accept', () async {
        final mockClient = MockClient((request) async {
          expect(request.headers['Content-Type'], equals('application/json'));
          expect(request.headers['Accept'], equals('application/json'));
          return http.Response(
            '{"transactions":[],"pagination":{"page":1,"pageSize":20,"total":0,"totalPages":0,"hasNext":false,"hasPrevious":false}}',
            200,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        await apiService.getTransactions();
      });
    });

    group('URL Building', () {
      test('Relative path is appended to base URL', () async {
        final mockClient = MockClient((request) async {
          expect(
            request.url.toString(),
            startsWith('http://localhost:8080/api/users/me'),
          );
          return http.Response(
            '{"id":"123","name":"Test","email":"test@example.com","status":"active","created_at":"2024-01-01T00:00:00Z","updated_at":"2024-01-01T00:00:00Z"}',
            200,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        await apiService.getUserProfile();
      });
    });
  });
}
