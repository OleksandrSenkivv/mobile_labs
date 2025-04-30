import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/core/user_storage_interface.dart';

class SecureUserStorage implements UserStorageInterface {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<void> saveUser(String username, String email, String password) async {
    await _storage.write(key: 'username', value: username);
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);
  }

  Future<void> saveUserLoginStatus(bool isLoggedIn) async {
    await _storage.write(
      key: 'isLoggedIn',
      value: isLoggedIn ? 'true' : 'false',
    );
  }

  Future<void> saveSmartPlugStatus(bool isPlugOn) async {
    await _storage.write(
      key: 'isPlugOn',
      value: isPlugOn ? 'true' : 'false',
    );
  }

  Future<bool> getSmartPlugStatus() async {
    final value = await _storage.read(key: 'isPlugOn');
    return value == 'true';
  }

  @override
  Future<Map<String, String>?> getUser() async {
    final username = await _storage.read(key: 'username');
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');

    if (username != null && password != null) {
      return {'username': username, 'email': email ?? '', 'password': password};
    }
    return null;
  }


  @override
  Future<bool> validateUser(String username, String password) async {
    final storedUser = await getUser();
    if (storedUser == null) return false;
    return storedUser['username'] == username && storedUser['password']
        == password;
  }

  @override
  Future<void> clearUser() async {
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'password');
  }
}
