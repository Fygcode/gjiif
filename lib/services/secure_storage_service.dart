import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Singleton instance
  static final SecureStorageService _instance = SecureStorageService._internal();

  // Private constructor
  SecureStorageService._internal();

  // Factory constructor
  factory SecureStorageService() => _instance;

  final _storage = const FlutterSecureStorage();

  // Write data
  Future<void> write(String key, String value) async {
    print("Stored Successfully $key == $value");
    await _storage.write(key: key, value: value);
  }

  // Read data
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Delete data
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Clear all data
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
