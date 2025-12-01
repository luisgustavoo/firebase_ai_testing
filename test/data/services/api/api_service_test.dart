import 'dart:async';
import 'dart:io';

import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
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

    group('Request Methods', () {
      test('GET request returns parsed JSON response', () async {
        final mockClient = MockClient((request) async {
          expect(request.method, equals('GET'));
          expect(request.url.path, equals('/api/test'));
          return http.Response('{"data": "test"}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final response = await apiService.get('/api/test');
        expect(response, equals({'data': 'test'}));
      });

      test('GET request with query parameters', () async {
        final mockClient = MockClient((request) async {
          expect(request.url.queryParameters['page'], equals('1'));
          expect(request.url.queryParameters['limit'], equals('10'));
          return http.Response('{"data": []}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        await apiService.get(
          '/api/test',
          queryParams: {'page': 1, 'limit': 10},
        );
      });

      test('POST request sends JSON body', () async {
        final mockClient = MockClient((request) async {
          expect(request.method, equals('POST'));
          expect(request.body, equals('{"name":"test","value":123}'));
          expect(request.headers['Content-Type'], equals('application/json'));
          return http.Response('{"id": "123"}', 201);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final response = await apiService.post(
          '/api/test',
          body: {'name': 'test', 'value': 123},
        );
        expect(response, equals({'id': '123'}));
      });

      test('PUT request sends JSON body', () async {
        final mockClient = MockClient((request) async {
          expect(request.method, equals('PUT'));
          expect(request.body, equals('{"name":"updated"}'));
          return http.Response('{"success": true}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final response = await apiService.put(
          '/api/test',
          body: {'name': 'updated'},
        );
        expect(response, equals({'success': true}));
      });

      test('DELETE request succeeds', () async {
        final mockClient = MockClient((request) async {
          expect(request.method, equals('DELETE'));
          return http.Response('', 204);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final response = await apiService.delete('/api/test');
        expect(response, isNull);
      });

      test('Request with empty response body returns null', () async {
        final mockClient = MockClient((request) async {
          return http.Response('', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        final response = await apiService.get('/api/test');
        expect(response, isNull);
      });
    });

    group('Error Handling', () {
      test('400 Bad Request throws ApiException with message', () async {
        final mockClient = MockClient((request) async {
          return http.Response('{"message": "Invalid data"}', 400);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        expect(
          () => apiService.get('/api/test'),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 400)
                .having((e) => e.message, 'message', contains('Invalid data')),
          ),
        );
      });

      test(
        '401 Unauthorized throws ApiException with session expired message',
        () async {
          final mockClient = MockClient((request) async {
            return http.Response('{"error": "Unauthorized"}', 401);
          });

          apiService = ApiService(tokenStorage, mockClient);
          await apiService.init();

          expect(
            () => apiService.get('/api/test'),
            throwsA(
              isA<ApiException>()
                  .having((e) => e.statusCode, 'statusCode', 401)
                  .having(
                    (e) => e.message,
                    'message',
                    'Sessão expirada. Faça login novamente',
                  ),
            ),
          );
        },
      );

      test(
        '403 Forbidden throws ApiException with permission message',
        () async {
          final mockClient = MockClient((request) async {
            return http.Response('{"error": "Forbidden"}', 403);
          });

          apiService = ApiService(tokenStorage, mockClient);
          await apiService.init();

          expect(
            () => apiService.get('/api/test'),
            throwsA(
              isA<ApiException>()
                  .having((e) => e.statusCode, 'statusCode', 403)
                  .having(
                    (e) => e.message,
                    'message',
                    'Você não tem permissão para esta ação',
                  ),
            ),
          );
        },
      );

      test('404 Not Found throws ApiException', () async {
        final mockClient = MockClient((request) async {
          return http.Response('{"error": "Not found"}', 404);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        expect(
          () => apiService.get('/api/test'),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 404)
                .having((e) => e.message, 'message', 'Recurso não encontrado'),
          ),
        );
      });

      test('500 Internal Server Error throws ApiException', () async {
        final mockClient = MockClient((request) async {
          return http.Response('{"error": "Server error"}', 500);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        expect(
          () => apiService.get('/api/test'),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 500)
                .having(
                  (e) => e.message,
                  'message',
                  'Erro no servidor. Tente novamente mais tarde',
                ),
          ),
        );
      });

      test('Invalid JSON response throws ApiException', () async {
        final mockClient = MockClient((request) async {
          return http.Response('invalid json', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        expect(
          () => apiService.get('/api/test'),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              contains('Failed to parse'),
            ),
          ),
        );
      });
    });

    group('Network Error Handling', () {
      test('Timeout throws ApiException with timeout message', () async {
        final mockClient = MockClient((request) async {
          // Simulate a timeout by throwing TimeoutException
          throw TimeoutException('Connection timeout');
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        expect(
          () => apiService.get('/api/test'),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              'Tempo esgotado. Verifique sua conexão',
            ),
          ),
        );
      });

      test(
        'SocketException throws ApiException with no internet message',
        () async {
          final mockClient = MockClient((request) async {
            throw const SocketException('No internet');
          });

          apiService = ApiService(tokenStorage, mockClient);
          await apiService.init();

          expect(
            () => apiService.get('/api/test'),
            throwsA(
              isA<ApiException>().having(
                (e) => e.message,
                'message',
                'Sem conexão com a internet',
              ),
            ),
          );
        },
      );

      test(
        'Generic exception throws ApiException with network error message',
        () async {
          final mockClient = MockClient((request) async {
            throw Exception('Unknown error');
          });

          apiService = ApiService(tokenStorage, mockClient);
          await apiService.init();

          expect(
            () => apiService.get('/api/test'),
            throwsA(
              isA<ApiException>().having(
                (e) => e.message,
                'message',
                contains('Erro de rede'),
              ),
            ),
          );
        },
      );
    });

    group('Headers', () {
      test('Default headers include Content-Type and Accept', () async {
        final mockClient = MockClient((request) async {
          expect(request.headers['Content-Type'], equals('application/json'));
          expect(request.headers['Accept'], equals('application/json'));
          return http.Response('{}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        await apiService.get('/api/test');
      });

      test('Additional headers are included in request', () async {
        final mockClient = MockClient((request) async {
          expect(request.headers['X-Custom-Header'], equals('custom-value'));
          return http.Response('{}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        await apiService.get(
          '/api/test',
          headers: {'X-Custom-Header': 'custom-value'},
        );
      });
    });

    group('URL Building', () {
      test('Relative path is appended to base URL', () async {
        final mockClient = MockClient((request) async {
          expect(
            request.url.toString(),
            equals('http://localhost:8080/api/test'),
          );
          return http.Response('{}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        await apiService.get('/api/test');
      });

      test('Absolute URL is used as-is', () async {
        final mockClient = MockClient((request) async {
          expect(
            request.url.toString(),
            equals('https://example.com/api/test'),
          );
          return http.Response('{}', 200);
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        await apiService.get('https://example.com/api/test');
      });
    });
  });
}
