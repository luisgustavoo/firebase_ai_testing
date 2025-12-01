import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/api/models/category_request.dart';
import 'package:firebase_ai_testing/domain/mappers/category_mapper.dart';
import 'package:firebase_ai_testing/domain/models/category.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:injectable/injectable.dart';

/// Repository for handling category operations
///
/// Manages category CRUD operations (Create, Read, Update, Delete).
/// Transforms API models to domain models and handles errors.
@lazySingleton
class CategoryRepository {
  CategoryRepository(this._apiService);

  final ApiService _apiService;

  /// Get all categories for authenticated user
  ///
  /// Returns Result<List<Category>> with all categories (default and custom).
  /// Note: Input validation is not needed for this operation.
  Future<Result<List<Category>>> getCategories() async {
    // Call API service - returns Result<List<CategoryApi>>
    final result = await _apiService.getCategories();

    // Transform Result<List<CategoryApi>> to Result<List<Category>>
    return switch (result) {
      Ok(:final value) => Result.ok(
        value.map(CategoryMapper.toDomain).toList(),
      ),
      Error(:final error) => Result.error(error),
    };
  }

  /// Create a new category
  ///
  /// Returns Result<Category> with the created category.
  /// Note: Input validation should be done in the ViewModel/UI layer.
  Future<Result<Category>> createCategory(
    String description,
    String? icon,
  ) async {
    // Create request
    final request = CategoryRequest(
      description: description,
      icon: icon,
    );

    // Call API service - returns Result<CategoryApi>
    final result = await _apiService.createCategory(request);

    // Transform Result<CategoryApi> to Result<Category>
    return switch (result) {
      Ok(:final value) => Result.ok(CategoryMapper.toDomain(value)),
      Error(:final error) => Result.error(error),
    };
  }

  /// Update an existing category
  ///
  /// Returns Result<Category> with the updated category.
  /// Handles 403 (permission denied) and 404 (not found) errors.
  /// Note: Input validation should be done in the ViewModel/UI layer.
  Future<Result<Category>> updateCategory(
    String id,
    String description,
    String? icon,
  ) async {
    // Create request
    final request = CategoryRequest(
      description: description,
      icon: icon,
    );

    // Call API service - returns Result<CategoryApi>
    final result = await _apiService.updateCategory(id, request);

    // Transform Result<CategoryApi> to Result<Category>
    return switch (result) {
      Ok(:final value) => Result.ok(CategoryMapper.toDomain(value)),
      Error(:final error) => _handleUpdateError(error),
    };
  }

  /// Handle update errors with custom messages for 403 and 404
  Result<Category> _handleUpdateError(Exception error) {
    if (error is ApiException) {
      if (error.statusCode == 403) {
        return Result.error(
          ApiException(
            'Você não tem permissão para editar esta categoria',
            statusCode: 403,
          ),
        );
      } else if (error.statusCode == 404) {
        return Result.error(
          ApiException(
            'Categoria não encontrada',
            statusCode: 404,
          ),
        );
      }
    }
    return Result.error(error);
  }

  /// Delete a category
  ///
  /// Returns Result<void> on success.
  /// Handles 403 (permission denied) and 404 (not found) errors.
  /// Note: When a category is deleted, associated transactions will have
  /// their category_id set to null.
  Future<Result<void>> deleteCategory(String id) async {
    // Call API service - returns Result<void>
    final result = await _apiService.deleteCategory(id);

    // Handle errors with custom messages for 403 and 404
    return switch (result) {
      Ok() => const Result.ok(null),
      Error(:final error) => _handleDeleteError(error),
    };
  }

  /// Handle delete errors with custom messages for 403 and 404
  Result<void> _handleDeleteError(Exception error) {
    if (error is ApiException) {
      if (error.statusCode == 403) {
        return Result.error(
          ApiException(
            'Você não tem permissão para deletar esta categoria',
            statusCode: 403,
          ),
        );
      } else if (error.statusCode == 404) {
        return Result.error(
          ApiException(
            'Categoria não encontrada',
            statusCode: 404,
          ),
        );
      }
    }
    return Result.error(error);
  }
}
