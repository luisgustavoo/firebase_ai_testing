import 'package:firebase_ai_testing/data/services/api/models/category/category_api_model.dart';
import 'package:firebase_ai_testing/domain/mappers/category_mapper.dart';
import 'package:firebase_ai_testing/domain/models/category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryMapper', () {
    final testDate = DateTime(2024, 1, 15, 10, 30);

    group('toDomain', () {
      test('converts CategoryApi to Category', () {
        final categoryApi = CategoryApiModel(
          id: 'cat-123',
          userId: 'user-123',
          description: 'Food & Dining',
          icon: '🍔',
          createdAt: testDate,
        );

        final category = CategoryMapper.toDomain(categoryApi);

        expect(category.id, 'cat-123');
        expect(category.userId, 'user-123');
        expect(category.description, 'Food & Dining');
        expect(category.icon, '🍔');
        expect(category.createdAt, testDate);
      });

      test('converts CategoryApi with different icon', () {
        final categoryApi = CategoryApiModel(
          id: 'cat-456',
          userId: 'user-123',
          description: 'Transportation',
          icon: '🚗',
          createdAt: testDate,
        );

        final category = CategoryMapper.toDomain(categoryApi);

        expect(category.id, 'cat-456');
        expect(category.description, 'Transportation');
        expect(category.icon, '🚗');
      });
    });

    group('toApi', () {
      test('converts Category to CategoryApi', () {
        final category = Category(
          id: 'cat-123',
          userId: 'user-123',
          description: 'Food & Dining',
          icon: '🍔',
          createdAt: testDate,
        );

        final categoryApi = CategoryMapper.toApi(category);

        expect(categoryApi.id, 'cat-123');
        expect(categoryApi.userId, 'user-123');
        expect(categoryApi.description, 'Food & Dining');
        expect(categoryApi.icon, '🍔');
        expect(categoryApi.createdAt, testDate);
      });
    });

    group('round-trip conversion', () {
      test('toDomain then toApi preserves data', () {
        final originalApi = CategoryApiModel(
          id: 'cat-123',
          userId: 'user-123',
          description: 'Food & Dining',
          icon: '🍔',
          createdAt: testDate,
        );

        final domain = CategoryMapper.toDomain(originalApi);
        final convertedApi = CategoryMapper.toApi(domain);

        expect(convertedApi.id, originalApi.id);
        expect(convertedApi.userId, originalApi.userId);
        expect(convertedApi.description, originalApi.description);
        expect(convertedApi.icon, originalApi.icon);
        expect(convertedApi.createdAt, originalApi.createdAt);
      });

      test('toApi then toDomain preserves data', () {
        final originalDomain = Category(
          id: 'cat-789',
          userId: 'user-456',
          description: 'Entertainment',
          icon: '🎬',
          createdAt: testDate,
        );

        final api = CategoryMapper.toApi(originalDomain);
        final convertedDomain = CategoryMapper.toDomain(api);

        expect(convertedDomain.id, originalDomain.id);
        expect(convertedDomain.userId, originalDomain.userId);
        expect(convertedDomain.description, originalDomain.description);
        expect(convertedDomain.icon, originalDomain.icon);
        expect(convertedDomain.createdAt, originalDomain.createdAt);
      });
    });
  });
}
