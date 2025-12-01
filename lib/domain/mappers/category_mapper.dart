import 'package:firebase_ai_testing/data/services/api/models/category/category_api_model.dart';
import 'package:firebase_ai_testing/domain/models/category.dart';

class CategoryMapper {
  /// Converts CategoryApi (API model) to Category (domain model)
  static Category toDomain(CategoryApiModel api) {
    return Category(
      id: api.id,
      userId: api.userId,
      description: api.description,
      icon: api.icon,
      createdAt: api.createdAt,
    );
  }

  /// Converts Category (domain model) to CategoryApi (API model)
  static CategoryApiModel toApi(Category domain) {
    return CategoryApiModel(
      id: domain.id,
      userId: domain.userId,
      description: domain.description,
      icon: domain.icon,
      createdAt: domain.createdAt,
    );
  }
}
