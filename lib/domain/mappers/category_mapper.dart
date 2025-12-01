import 'package:firebase_ai_testing/data/services/api/models/category_api.dart';
import 'package:firebase_ai_testing/domain/models/category.dart';

class CategoryMapper {
  /// Converts CategoryApi (API model) to Category (domain model)
  static Category toDomain(CategoryApi api) {
    return Category(
      id: api.id,
      userId: api.userId,
      description: api.description,
      isDefault: api.isDefault,
      createdAt: api.createdAt,
      updatedAt: api.updatedAt,
      icon: api.icon,
    );
  }

  /// Converts Category (domain model) to CategoryApi (API model)
  static CategoryApi toApi(Category domain) {
    return CategoryApi(
      id: domain.id,
      userId: domain.userId,
      description: domain.description,
      isDefault: domain.isDefault,
      createdAt: domain.createdAt,
      updatedAt: domain.updatedAt,
      icon: domain.icon,
    );
  }
}
