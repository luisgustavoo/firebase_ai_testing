import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/api/models/category/category_request/category_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/register_request/register_request.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ApiService Property Tests', () {
    late ApiService apiService;
    late TokenStorageService tokenStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const secureStorage = FlutterSecureStorage();
      tokenStorage = TokenStorageService(secureStorage);
    });

    /// **Feature: api-integration, Property 26: Authenticated requests include Bearer token**
    /// **Validates: Requirements 10.5, 12.2**
    ///
    /// For any authenticated API request, the Authorization header should contain "Bearer {token}".
    test('Property 26: Authenticated requests include Bearer token', () async {
      // Test with multiple different tokens to verify the property holds
      final testTokens = [
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.test',
        'simple_token_123',
        'very_long_token_${'x' * 500}',
        r'token-with-special-chars-!@#$%^&*()',
      ];

      for (final token in testTokens) {
        // Track if the Authorization header was checked
        var headerChecked = false;

        // Create a mock HTTP client that verifies the Authorization header
        final mockClient = MockClient((request) async {
          headerChecked = true;

          // Property: Authorization header must be present
          expect(
            request.headers.containsKey('Authorization'),
            isTrue,
            reason:
                'Authorization header must be present for authenticated requests',
          );

          // Property: Authorization header must contain "Bearer {token}"
          final authHeader = request.headers['Authorization'];
          expect(
            authHeader,
            equals('Bearer $token'),
            reason: 'Authorization header must be "Bearer $token"',
          );

          // Return appropriate response based on endpoint
          if (request.url.path.contains('/categories/')) {
            return http.Response(
              '{"id":"cat-123","user_id":"user-1","description":"test","is_default":false,"created_at":"2024-01-01T00:00:00Z","updated_at":"2024-01-01T00:00:00Z"}',
              200,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          }

          // Return a successful response with valid UserApi data
          return http.Response(
            '{"id":"123","name":"Test","email":"test@example.com","status":"active","created_at":"2024-01-01T00:00:00Z","updated_at":"2024-01-01T00:00:00Z"}',
            200,
          );
        });

        // Create API service with the mock
        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        // Set the authentication token
        apiService.authToken = token;

        // Test all endpoint methods to ensure they all include the token
        await apiService.getUserProfile();
        expect(
          headerChecked,
          isTrue,
          reason: 'GET request should include token',
        );

        headerChecked = false;
        const request = RegisterRequest(
          name: 'Test',
          email: 'test@example.com',
          password: 'password123',
        );
        await apiService.registerUser(request);
        expect(
          headerChecked,
          isTrue,
          reason: 'POST request should include token',
        );

        headerChecked = false;
        const categoryRequest = CategoryRequest(
          description: 'test',
        );
        await apiService.updateCategory('cat-123', categoryRequest);
        expect(
          headerChecked,
          isTrue,
          reason: 'PUT request should include token',
        );

        headerChecked = false;
        await apiService.deleteCategory('cat-123');
        expect(
          headerChecked,
          isTrue,
          reason: 'DELETE request should include token',
        );
      }
    });

    /// Property: Requests without token should not include Authorization header
    test(
      'Property: Requests without token do not include Authorization header',
      () async {
        var headerChecked = false;

        final mockClient = MockClient((request) async {
          headerChecked = true;

          // Property: Authorization header should not be present when no token is set
          expect(
            request.headers.containsKey('Authorization'),
            isFalse,
            reason: 'Authorization header should not be present without token',
          );

          return http.Response(
            '{"id":"123","name":"Test","email":"test@example.com","status":"active","created_at":"2024-01-01T00:00:00Z","updated_at":"2024-01-01T00:00:00Z"}',
            200,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        // Don't set any token
        await apiService.getUserProfile();
        expect(headerChecked, isTrue);
      },
    );

    /// Property: Empty token should not include Authorization header
    test(
      'Property: Empty token does not include Authorization header',
      () async {
        var headerChecked = false;

        final mockClient = MockClient((request) async {
          headerChecked = true;

          // Property: Authorization header should not be present for empty token
          expect(
            request.headers.containsKey('Authorization'),
            isFalse,
            reason:
                'Authorization header should not be present for empty token',
          );

          return http.Response(
            '{"id":"123","name":"Test","email":"test@example.com","status":"active","created_at":"2024-01-01T00:00:00Z","updated_at":"2024-01-01T00:00:00Z"}',
            200,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        // Set empty token
        apiService.authToken = '';

        await apiService.getUserProfile();
        expect(headerChecked, isTrue);
      },
    );

    /// Property: Token changes are reflected in subsequent requests
    test(
      'Property: Token changes are reflected in subsequent requests',
      () async {
        final tokens = ['token1', 'token2', 'token3'];
        var requestCount = 0;

        final mockClient = MockClient((request) async {
          final expectedToken = tokens[requestCount];
          requestCount++;

          // Property: Each request should have the current token
          final authHeader = request.headers['Authorization'];
          expect(
            authHeader,
            equals('Bearer $expectedToken'),
            reason: 'Request should use the most recently set token',
          );

          return http.Response(
            '{"id":"123","name":"Test","email":"test@example.com","status":"active","created_at":"2024-01-01T00:00:00Z","updated_at":"2024-01-01T00:00:00Z"}',
            200,
          );
        });

        apiService = ApiService(tokenStorage, mockClient);
        await apiService.init();

        // Make requests with different tokens
        for (final token in tokens) {
          apiService.authToken = token;
          await apiService.getUserProfile();
        }

        expect(requestCount, equals(tokens.length));
      },
    );

    /// Property: Token persisted in storage is loaded on init
    test('Property: Token persisted in storage is loaded on init', () async {
      const testToken = 'persisted_token_123';

      // Save token to storage
      await tokenStorage.saveToken(testToken);

      var headerChecked = false;

      final mockClient = MockClient((request) async {
        headerChecked = true;

        // Property: Persisted token should be used automatically
        final authHeader = request.headers['Authorization'];
        expect(
          authHeader,
          equals('Bearer $testToken'),
          reason: 'Persisted token should be loaded and used',
        );

        return http.Response(
          '{"id":"123","name":"Test","email":"test@example.com","status":"active","created_at":"2024-01-01T00:00:00Z","updated_at":"2024-01-01T00:00:00Z"}',
          200,
        );
      });

      // Create new API service (simulating app restart)
      apiService = ApiService(tokenStorage, mockClient);
      await apiService.init(); // This should load the token

      // Make request without explicitly setting token
      await apiService.getUserProfile();
      expect(headerChecked, isTrue);
    });
  });
}
