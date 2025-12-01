import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Service for securely storing and retrieving JWT authentication tokens
/// using flutter_secure_storage.
@lazySingleton
class TokenStorageService {
  TokenStorageService(this._secureStorage);
  static const String _tokenKey = 'auth_token';

  final FlutterSecureStorage _secureStorage;

  /// Saves the JWT token securely to storage
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  /// Retrieves the stored JWT token
  /// Returns null if no token is stored
  Future<String?> getToken() async {
    return _secureStorage.read(key: _tokenKey);
  }

  /// Deletes the stored JWT token
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  /// Checks if a token exists in storage
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
