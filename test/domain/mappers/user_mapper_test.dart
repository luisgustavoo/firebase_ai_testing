import 'package:firebase_ai_testing/data/services/api/models/user/user_api.dart';
import 'package:firebase_ai_testing/domain/mappers/user_mapper.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserMapper', () {
    final testDate = DateTime(2024, 1, 15, 10, 30);

    group('toDomain', () {
      test('converts UserApi to User with active status', () {
        final userApi = UserApiModel(
          id: 'user-123',
          name: 'John Doe',
          email: 'john@example.com',
          status: 'active',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final user = UserMapper.toDomain(userApi);

        expect(user.id, 'user-123');
        expect(user.name, 'John Doe');
        expect(user.email, 'john@example.com');
        expect(user.status, UserStatus.active);
        expect(user.createdAt, testDate);
        expect(user.updatedAt, testDate);
      });

      test('converts UserApi to User with inactive status', () {
        final userApi = UserApiModel(
          id: 'user-456',
          name: 'Jane Smith',
          email: 'jane@example.com',
          status: 'inactive',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final user = UserMapper.toDomain(userApi);

        expect(user.status, UserStatus.inactive);
      });

      test('handles case-insensitive status conversion', () {
        final userApi = UserApiModel(
          id: 'user-789',
          name: 'Test User',
          email: 'test@example.com',
          status: 'ACTIVE',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final user = UserMapper.toDomain(userApi);

        expect(user.status, UserStatus.active);
      });

      test('throws ArgumentError for unknown status', () {
        final userApi = UserApiModel(
          id: 'user-999',
          name: 'Test User',
          email: 'test@example.com',
          status: 'unknown',
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(
          () => UserMapper.toDomain(userApi),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('toApi', () {
      test('converts User to UserApi with active status', () {
        final user = User(
          id: 'user-123',
          name: 'John Doe',
          email: 'john@example.com',
          status: UserStatus.active,
          createdAt: testDate,
          updatedAt: testDate,
        );

        final userApi = UserMapper.toApi(user);

        expect(userApi.id, 'user-123');
        expect(userApi.name, 'John Doe');
        expect(userApi.email, 'john@example.com');
        expect(userApi.status, 'active');
        expect(userApi.createdAt, testDate);
        expect(userApi.updatedAt, testDate);
      });

      test('converts User to UserApi with inactive status', () {
        final user = User(
          id: 'user-456',
          name: 'Jane Smith',
          email: 'jane@example.com',
          status: UserStatus.inactive,
          createdAt: testDate,
          updatedAt: testDate,
        );

        final userApi = UserMapper.toApi(user);

        expect(userApi.status, 'inactive');
      });
    });

    group('round-trip conversion', () {
      test('toDomain then toApi preserves data', () {
        final originalApi = UserApiModel(
          id: 'user-123',
          name: 'John Doe',
          email: 'john@example.com',
          status: 'active',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final domain = UserMapper.toDomain(originalApi);
        final convertedApi = UserMapper.toApi(domain);

        expect(convertedApi.id, originalApi.id);
        expect(convertedApi.name, originalApi.name);
        expect(convertedApi.email, originalApi.email);
        expect(convertedApi.status, originalApi.status);
        expect(convertedApi.createdAt, originalApi.createdAt);
        expect(convertedApi.updatedAt, originalApi.updatedAt);
      });

      test('toApi then toDomain preserves data', () {
        final originalDomain = User(
          id: 'user-456',
          name: 'Jane Smith',
          email: 'jane@example.com',
          status: UserStatus.inactive,
          createdAt: testDate,
          updatedAt: testDate,
        );

        final api = UserMapper.toApi(originalDomain);
        final convertedDomain = UserMapper.toDomain(api);

        expect(convertedDomain.id, originalDomain.id);
        expect(convertedDomain.name, originalDomain.name);
        expect(convertedDomain.email, originalDomain.email);
        expect(convertedDomain.status, originalDomain.status);
        expect(convertedDomain.createdAt, originalDomain.createdAt);
        expect(convertedDomain.updatedAt, originalDomain.updatedAt);
      });
    });
  });
}
