import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_ai_testing/data/services/api/models/category/category_api_model.dart';
import 'package:firebase_ai_testing/data/services/api/models/category/category_request/category_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/login_request/login_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/login_response/login_response.dart';
import 'package:firebase_ai_testing/data/services/api/models/register_request/register_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_api.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_request/create_transaction_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_response/transactions_response.dart';
import 'package:firebase_ai_testing/data/services/api/models/user/user_api.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

/// Exception thrown when an API request fails
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final int? statusCode;
  final String message;

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

/// Service that wraps REST API endpoints and exposes asynchronous response objects.
/// This is a stateless service that only handles HTTP communication.
/// According to Flutter architecture guidelines, services wrap external APIs
/// and expose Future/Stream objects.
@lazySingleton
class ApiService {
  ApiService(this._tokenStorage, this._httpClient);

  static const String _baseUrl = 'http://localhost:8080';
  static const Duration _timeout = Duration(seconds: 30);

  final TokenStorageService _tokenStorage;
  final http.Client _httpClient;

  /// Current authentication token for requests
  String? authToken;

  /// Initialize the service by loading the stored token
  @postConstruct
  Future<void> init() async {
    authToken = await _tokenStorage.getToken();
  }

  /// Build headers for requests
  Map<String, String> _buildHeaders({Map<String, String>? additionalHeaders}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add Bearer token if available
    if (authToken != null && authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    // Add any additional headers
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Build full URL from path
  String _buildUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    return '$_baseUrl$path';
  }

  /// Handle HTTP response and throw appropriate exceptions
  Future<dynamic> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      try {
        return json.decode(response.body);
      } catch (e) {
        throw ApiException(
          'Failed to parse response: $e',
          statusCode: response.statusCode,
        );
      }
    }

    // Handle 401 Unauthorized - clear token and auth state
    if (response.statusCode == 401) {
      await _handle401Error();
    }

    // Handle error responses
    String errorMessage;
    try {
      final errorBody = json.decode(response.body) as Map<String, dynamic>;
      errorMessage =
          (errorBody['message'] as String?) ??
          (errorBody['error'] as String?) ??
          'Unknown error';
    } on FormatException {
      errorMessage = response.body.isNotEmpty ? response.body : 'Unknown error';
    }

    throw ApiException(
      _mapErrorMessage(response.statusCode, errorMessage),
      statusCode: response.statusCode,
    );
  }

  /// Handle 401 Unauthorized errors globally
  /// Clears authentication token and state
  Future<void> _handle401Error() async {
    // Clear token from storage
    await _tokenStorage.deleteToken();

    // Clear token from service
    authToken = null;
  }

  /// Map HTTP status codes to user-friendly error messages
  String _mapErrorMessage(int statusCode, String? serverMessage) {
    switch (statusCode) {
      case 400:
        return serverMessage ?? 'Dados inválidos';
      case 401:
        return 'Sessão expirada. Faça login novamente';
      case 403:
        return 'Você não tem permissão para esta ação';
      case 404:
        return 'Recurso não encontrado';
      case 500:
        return 'Erro no servidor. Tente novamente mais tarde';
      default:
        return serverMessage ?? 'Erro desconhecido';
    }
  }

  /// Perform GET request
  Future<dynamic> _get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(_buildUrl(path));
      final uriWithParams = queryParams != null
          ? uri.replace(
              queryParameters: queryParams.map(
                (key, value) => MapEntry(key, value.toString()),
              ),
            )
          : uri;

      final response = await _httpClient
          .get(
            uriWithParams,
            headers: _buildHeaders(additionalHeaders: headers),
          )
          .timeout(_timeout);

      return await _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Tempo esgotado. Verifique sua conexão');
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro de rede: $e');
    }
  }

  /// Perform POST request
  Future<dynamic> _post(
    String path, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse(_buildUrl(path)),
            headers: _buildHeaders(additionalHeaders: headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      return await _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Tempo esgotado. Verifique sua conexão');
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro de rede: $e');
    }
  }

  /// Perform PUT request
  Future<dynamic> _put(
    String path, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _httpClient
          .put(
            Uri.parse(_buildUrl(path)),
            headers: _buildHeaders(additionalHeaders: headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      return await _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Tempo esgotado. Verifique sua conexão');
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro de rede: $e');
    }
  }

  /// Perform DELETE request
  Future<dynamic> _delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _httpClient
          .delete(
            Uri.parse(_buildUrl(path)),
            headers: _buildHeaders(additionalHeaders: headers),
          )
          .timeout(_timeout);

      return await _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Tempo esgotado. Verifique sua conexão');
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro de rede: $e');
    }
  }

  // Authentication endpoints

  /// Register a new user
  /// Returns Result with the created user data as UserApi model
  Future<Result<UserApiModel>> registerUser(RegisterRequest request) async {
    try {
      final response = await _post(
        '/api/users/register',
        body: request.toJson(),
      );
      final userApi = UserApiModel.fromJson(response as Map<String, dynamic>);
      return Result.ok(userApi);
    } on ApiException catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to register user: $e'));
    }
  }

  /// Login with email and password
  /// Returns Result with token and user data as LoginResponse model
  Future<Result<LoginResponse>> loginUser(LoginRequest request) async {
    try {
      final response = await _post('/api/users/login', body: request.toJson());
      final loginResponse = LoginResponse.fromJson(
        response as Map<String, dynamic>,
      );
      return Result.ok(loginResponse);
    } on ApiException catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to login: $e'));
    }
  }

  /// Get authenticated user profile
  /// Requires valid authentication token
  /// Returns Result with UserApi model
  Future<Result<UserApiModel>> getUserProfile() async {
    try {
      final response = await _get('/api/users/me');
      final userApi = UserApiModel.fromJson(response as Map<String, dynamic>);
      return Result.ok(userApi);
    } on ApiException catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to get profile: $e'));
    }
  }

  // Category endpoints

  /// Get all categories for authenticated user
  /// Returns Result with list of CategoryApi models
  Future<Result<List<CategoryApiModel>>> getCategories() async {
    try {
      final response = await _get('/api/categories');
      final categoriesJson = response as List<dynamic>;
      final categories = categoriesJson
          .map(
            (json) => CategoryApiModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      return Result.ok(categories);
    } on ApiException catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to get categories: $e'));
    }
  }

  /// Create a new category
  /// Returns Result with the created CategoryApi model
  Future<Result<CategoryApiModel>> createCategory(
    CategoryRequest request,
  ) async {
    try {
      final response = await _post(
        '/api/categories',
        body: request.toJson(),
      );
      final categoryApi = CategoryApiModel.fromJson(
        response as Map<String, dynamic>,
      );
      return Result.ok(categoryApi);
    } on ApiException catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to create category: $e'));
    }
  }

  /// Update an existing category
  /// Returns Result with the updated CategoryApi model
  Future<Result<CategoryApiModel>> updateCategory(
    String categoryId,
    CategoryRequest request,
  ) async {
    try {
      final response = await _put(
        '/api/categories/$categoryId',
        body: request.toJson(),
      );
      final categoryApi = CategoryApiModel.fromJson(
        response as Map<String, dynamic>,
      );
      return Result.ok(categoryApi);
    } on ApiException catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to update category: $e'));
    }
  }

  /// Delete a category
  /// Returns Result<void> on success
  Future<Result<void>> deleteCategory(String categoryId) async {
    try {
      await _delete('/api/categories/$categoryId');
      return const Result.ok(null);
    } on ApiException catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to delete category: $e'));
    }
  }

  // Transaction endpoints

  /// Create a new transaction
  /// Returns Result with the created TransactionApi model
  Future<Result<TransactionApiModel>> createTransaction(
    CreateTransactionRequest request,
  ) async {
    try {
      final response = await _post(
        '/api/transactions',
        body: request.toJson(),
      );
      final transactionApi = TransactionApiModel.fromJson(
        response as Map<String, dynamic>,
      );
      return Result.ok(transactionApi);
    } on ApiException catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to create transaction: $e'));
    }
  }

  /// Get transactions with pagination and optional filters
  /// Returns Result with TransactionsResponse model containing transactions and pagination metadata
  Future<Result<TransactionsResponse>> getTransactions({
    int page = 1,
    int pageSize = 20,
    String? type,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      };

      if (type != null) {
        queryParams['type'] = type;
      }

      final response = await _get(
        '/api/transactions',
        queryParams: queryParams,
      );
      final transactionsResponse = TransactionsResponse.fromJson(
        response as Map<String, dynamic>,
      );
      return Result.ok(transactionsResponse);
    } on ApiException catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to get transactions: $e'));
    }
  }
}
