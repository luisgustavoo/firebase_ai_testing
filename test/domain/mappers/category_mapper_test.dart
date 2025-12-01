import 'package:firebase_ai_testing/data/services/api/models/category_api.dart';
import 'package:firebase_ai_testing/domain/mappers/category_mapper.dart';
import 'package:firebase_ai_testing/domain/models/category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryMapper', () {
    final testDate = DateTime(2024, 1, 15, 10, 30);

    group('toDomain', () {
      test('converts CategoryApi to Category with icon', () {
        final categoryApi = CategoryApi(
          id: 'cat-123',
          userId: 'user-123',
          description: 'Food & Dining',
          isDefault: false,
          createdAt: testDate,
          updatedAt: testDate,
          icon: '🍔',
        );

        final category = CategoryMapper.toDomain(categoryApi);

        expect(category.id, 'cat-123');
        expect(category.userId, 'user-123');
        expect(category.description, 'Food & Dining');
        expect(category.isDefault, false);
        expect(category.createdAt, testDate);
        expect(category.updatedAt, testDate);
        expect(category.icon, '🍔');
      });

      test('converts CategoryApi to Category without icon', () {
        final categoryApi = CategoryApi(
          id: 'cat-456',
          userId: 'user-123',
          description: 'Transportation',
          isDefault: true,
          createdAt: testDate,
          updatedAt: testDate,
          // icon: null,
        );

        final category = CategoryMapper.toDomain(categoryApi);

        expect(category.id, 'cat-456');
        expect(category.description, 'Transportation');
        expect(category.isDefault, true);
        expect(category.icon, null);
      });

      test('converts default category correctly', () {
        final categoryApi = CategoryApi(
          id: 'cat-default',
          userId: 'system',
          description: 'Default Category',
          isDefault: true,
          createdAt: testDate,
          updatedAt: testDate,
        );

        final category = CategoryMapper.toDomain(categoryApi);

        expect(category.isDefault, true);
      });
    });

    group('toApi', () {
      test('converts Category to CategoryApi with icon', () {
        final category = Category(
          id: 'cat-123',
          userId: 'user-123',
          description: 'Food & Dining',
          isDefault: false,
          createdAt: testDate,
          updatedAt: testDate,
          icon: '🍔',
        );

        final categoryApi = CategoryMapper.toApi(category);

        expect(categoryApi.id, 'cat-123');
        expect(categoryApi.userId, 'user-123');
        expect(categoryApi.description, 'Food & Dining');
        expect(categoryApi.isDefault, false);
        expect(categoryApi.createdAt, testDate);
        expect(categoryApi.updatedAt, testDate);
        expect(categoryApi.icon, '🍔');
      });

      test('converts Category to CategoryApi without icon', () {
        final category = Category(
          id: 'cat-456',
          userId: 'user-123',
          description: 'Transportation',
          isDefault: true,
          createdAt: testDate,
          updatedAt: testDate,
        );

        final categoryApi = CategoryMapper.toApi(category);

        expect(categoryApi.icon, null);
      });
    });

    group('round-trip conversion', () {
      test('toDomain then toApi preserves data with icon', () {
        final originalApi = CategoryApi(
          id: 'cat-123',
          userId: 'user-123',
          description: 'Food & Dining',
          isDefault: false,
          createdAt: testDate,
          updatedAt: testDate,
          icon: '🍔',
        );

        final domain = CategoryMapper.toDomain(originalApi);
        final convertedApi = CategoryMapper.toApi(domain);

        expect(convertedApi.id, originalApi.id);
        expect(convertedApi.userId, originalApi.userId);
        expect(convertedApi.description, originalApi.description);
        expect(convertedApi.isDefault, originalApi.isDefault);
        expect(convertedApi.createdAt, originalApi.createdAt);
        expect(convertedApi.updatedAt, originalApi.updatedAt);
        expect(convertedApi.icon, originalApi.icon);
      });

      test('toDomain then toApi preserves data without icon', () {
        final originalApi = CategoryApi(
          id: 'cat-456',
          userId: 'user-123',
          description: 'Transportation',
          isDefault: true,
          createdAt: testDate,
          updatedAt: testDate,
        );

        final domain = CategoryMapper.toDomain(originalApi);
        final convertedApi = CategoryMapper.toApi(domain);

        expect(convertedApi.icon, null);
      });

      test('toApi then toDomain preserves data', () {
        final originalDomain = Category(
          id: 'cat-789',
          userId: 'user-456',
          description: 'Entertainment',
          isDefault: false,
          createdAt: testDate,
          updatedAt: testDate,
          icon: '🎬',
        );

        final api = CategoryMapper.toApi(originalDomain);
        final convertedDomain = CategoryMapper.toDomain(api);

        expect(convertedDomain.id, originalDomain.id);
        expect(convertedDomain.userId, originalDomain.userId);
        expect(convertedDomain.description, originalDomain.description);
        expect(convertedDomain.isDefault, originalDomain.isDefault);
        expect(convertedDomain.createdAt, originalDomain.createdAt);
        expect(convertedDomain.updatedAt, originalDomain.updatedAt);
        expect(convertedDomain.icon, originalDomain.icon);
      });
    });
  });
}
