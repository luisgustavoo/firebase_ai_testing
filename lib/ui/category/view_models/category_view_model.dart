import 'package:firebase_ai_testing/data/repositories/category_repository.dart';
import 'package:firebase_ai_testing/data/repositories/user_repository.dart';
import 'package:firebase_ai_testing/domain/models/category.dart';
import 'package:firebase_ai_testing/utils/command.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:injectable/injectable.dart';

/// ViewModel for category operations
///
/// Coordinates between UI and CategoryRepository.
/// Does NOT perform validation - validation is handled in UI layer (TextFormField validators).
/// Uses Command pattern for async operations with loading/error states.
@injectable
class CategoryViewModel extends ChangeNotifier {
  CategoryViewModel(
    this._categoryRepository,
    this._userRepository,
  );

  final CategoryRepository _categoryRepository;
  final UserRepository _userRepository;

  List<Category> _categories = [];

  /// Current list of categories
  List<Category> get categories => _categories;

  late final Command0<void> loadCategoriesCommand = Command0(_loadCategories);
  late final Command1<void, CreateCategoryParams> createCategoryCommand =
      Command1(_createCategory);
  late final Command1<void, UpdateCategoryParams> updateCategoryCommand =
      Command1(_updateCategory);
  late final Command1<void, String> deleteCategoryCommand = Command1(
    _deleteCategory,
  );

  /// Load all categories
  ///
  /// Fetches categories from repository and updates the list.
  Future<Result<void>> _loadCategories() async {
    final result = await _userRepository.getUser();

    switch (result) {
      case Ok(:final value):
        return _loadCategoriesForUser(value.id);
      case Error(:final error):
        return Result.error(error);
    }
  }

  Future<Result<void>> _loadCategoriesForUser(String userId) async {
    final result = await _categoryRepository.getCategories(userId);

    return switch (result) {
      Ok(:final value) => _handleLoadSuccess(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful category load
  Result<void> _handleLoadSuccess(List<Category> categories) {
    _categories = categories;
    notifyListeners();
    return const Result.ok(null);
  }

  /// Create a new category
  ///
  /// Note: Input validation should be done in UI layer (TextFormField validators).
  /// Adds the new category to the list on success.
  Future<Result<void>> _createCategory(CreateCategoryParams params) async {
    final result = await _categoryRepository.createCategory(
      params.description,
      params.icon,
    );

    return switch (result) {
      Ok(:final value) => _handleCreateSuccess(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful category creation
  Result<void> _handleCreateSuccess(Category category) {
    _categories = [..._categories, category];
    notifyListeners();
    return const Result.ok(null);
  }

  /// Update an existing category
  ///
  /// Note: Input validation should be done in UI layer (TextFormField validators).
  /// Updates the category in the list on success.
  Future<Result<void>> _updateCategory(UpdateCategoryParams params) async {
    final result = await _categoryRepository.updateCategory(
      params.id,
      params.description,
      params.icon,
    );

    return switch (result) {
      Ok(:final value) => _handleUpdateSuccess(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful category update
  Result<void> _handleUpdateSuccess(Category updatedCategory) {
    _categories = _categories.map((category) {
      return category.id == updatedCategory.id ? updatedCategory : category;
    }).toList();
    notifyListeners();
    return const Result.ok(null);
  }

  /// Delete a category
  ///
  /// Removes the category from the list on success.
  Future<Result<void>> _deleteCategory(String id) async {
    final result = await _categoryRepository.deleteCategory(id);

    return switch (result) {
      Ok() => _handleDeleteSuccess(id),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful category deletion
  Result<void> _handleDeleteSuccess(String id) {
    _categories = _categories.where((category) => category.id != id).toList();
    notifyListeners();
    return const Result.ok(null);
  }
}

/// Parameters for create category command
class CreateCategoryParams {
  CreateCategoryParams({
    required this.description,
    this.icon,
  });

  final String description;
  final String? icon;
}

/// Parameters for update category command
class UpdateCategoryParams {
  UpdateCategoryParams({
    required this.id,
    required this.description,
    this.icon,
  });

  final String id;
  final String description;
  final String? icon;
}
