import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TokenStorageService Property Tests', () {
    late TokenStorageService tokenStorageService;
    late FlutterSecureStorage secureStorage;

    setUp(() {
      // Use FlutterSecureStorage with mock implementation for testing
      FlutterSecureStorage.setMockInitialValues({});
      secureStorage = const FlutterSecureStorage();
      tokenStorageService = TokenStorageService(secureStorage);
    });

    /// **Feature: api-integration, Property 30: Token is stored securely after login**
    /// **Validates: Requirements 12.1**
    ///
    /// For any valid JWT token string, after saving it should be retrievable
    test('Property 30: Token is stored securely after login', () async {
      // Generate multiple random token strings to test the property
      final testTokens = [
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
        'token_abc123',
        'very_long_token_${'x' * 500}',
        r'token-with-special-chars-!@#$%',
        'short',
        '',
      ];

      for (final token in testTokens) {
        // Clear storage before each test
        await tokenStorageService.deleteToken();

        // Save the token
        await tokenStorageService.saveToken(token);

        // Retrieve the token
        final retrievedToken = await tokenStorageService.getToken();

        // Property: The retrieved token should match the saved token
        expect(
          retrievedToken,
          equals(token),
          reason: 'Token "$token" should be retrievable after saving',
        );

        // Additional property: hasToken should return true for non-empty tokens
        final hasToken = await tokenStorageService.hasToken();
        if (token.isNotEmpty) {
          expect(
            hasToken,
            isTrue,
            reason: 'hasToken should return true after saving non-empty token',
          );
        }
      }
    });

    /// **Feature: api-integration, Property 31: Logout clears stored token**
    /// **Validates: Requirements 12.4**
    ///
    /// For any stored token, after deletion it should not be retrievable
    test('Property 31: Logout clears stored token', () async {
      final testTokens = [
        'token1',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test',
        'very_long_token_${'y' * 1000}',
      ];

      for (final token in testTokens) {
        // Save a token
        await tokenStorageService.saveToken(token);

        // Verify it's stored
        expect(await tokenStorageService.hasToken(), isTrue);

        // Delete the token (logout)
        await tokenStorageService.deleteToken();

        // Property: Token should be null after deletion
        final retrievedToken = await tokenStorageService.getToken();
        expect(
          retrievedToken,
          isNull,
          reason: 'Token should be null after deletion',
        );

        // Property: hasToken should return false after deletion
        final hasToken = await tokenStorageService.hasToken();
        expect(
          hasToken,
          isFalse,
          reason: 'hasToken should return false after deletion',
        );
      }
    });

    /// **Feature: api-integration, Property 32: App restart retrieves stored token**
    /// **Validates: Requirements 12.5**
    ///
    /// For any stored token, creating a new service instance should still retrieve it
    test('Property 32: App restart retrieves stored token', () async {
      final testTokens = [
        'persistent_token_1',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.persistent',
        'token_${'z' * 200}',
      ];

      for (final token in testTokens) {
        // Save token with first service instance
        await tokenStorageService.saveToken(token);

        // Simulate app restart by creating a new service instance
        // (using the same storage instance to simulate persistence)
        final newServiceInstance = TokenStorageService(secureStorage);

        // Property: Token should be retrievable after "restart"
        final retrievedToken = await newServiceInstance.getToken();
        expect(
          retrievedToken,
          equals(token),
          reason:
              'Token should persist across service instances (simulating app restart)',
        );

        // Property: hasToken should return true after "restart"
        final hasToken = await newServiceInstance.hasToken();
        expect(
          hasToken,
          isTrue,
          reason: 'hasToken should return true after app restart',
        );

        // Clean up for next iteration
        await newServiceInstance.deleteToken();
      }
    });

    /// Combined property test: Round-trip consistency
    /// For any token, save → retrieve → delete → retrieve should follow expected pattern
    test('Round-trip property: save → get → delete → get', () async {
      final testTokens = [
        'roundtrip_token_1',
        'roundtrip_token_2',
        'roundtrip_${'a' * 100}',
      ];

      for (final token in testTokens) {
        // Initial state: no token
        await tokenStorageService.deleteToken();
        expect(await tokenStorageService.getToken(), isNull);
        expect(await tokenStorageService.hasToken(), isFalse);

        // After save: token exists
        await tokenStorageService.saveToken(token);
        expect(await tokenStorageService.getToken(), equals(token));
        expect(await tokenStorageService.hasToken(), isTrue);

        // After delete: no token
        await tokenStorageService.deleteToken();
        expect(await tokenStorageService.getToken(), isNull);
        expect(await tokenStorageService.hasToken(), isFalse);
      }
    });

    /// Edge case: Multiple saves should overwrite previous token
    test('Property: Multiple saves overwrite previous token', () async {
      final tokens = ['token1', 'token2', 'token3'];

      for (final token in tokens) {
        await tokenStorageService.saveToken(token);
        final retrieved = await tokenStorageService.getToken();

        // Property: Only the most recent token should be stored
        expect(
          retrieved,
          equals(token),
          reason: 'Most recent token should overwrite previous ones',
        );
      }
    });
  });
}
