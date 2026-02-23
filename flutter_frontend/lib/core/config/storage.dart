import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _jwtKey = 'JWT';
  static const _usernameKey = 'USERNAME';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _jwtKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _jwtKey);
  }

  Future<void> saveUsername(String username) async {
    await _storage.write(key: _usernameKey, value: username);
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: _usernameKey);
  }

  Future<void> clearAll() async {
    await _storage.delete(key: _jwtKey);
    await _storage.delete(key: _usernameKey);
  }
}
