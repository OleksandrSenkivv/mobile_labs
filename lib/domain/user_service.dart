import 'package:mobile_labs/core/user_storage_interface.dart';
import 'package:mobile_labs/data/user_storage_secure.dart';

class UserService {
  final UserStorageInterface storage;

  UserService(this.storage);

  Future<String?> register(String username, String email, String password)
  async {
    if (!email.contains('@')) {
      return 'Невалідна пошта';
    }
    if (username.contains(RegExp(r'[0-9]'))) {
      return 'Ім’я не повинно містити цифр';
    }

    await storage.saveUser(username, email, password);

    if (storage is SecureUserStorage) {
      await (storage as SecureUserStorage).saveUserLoginStatus(true);
    }

    return null;
  }

  Future<bool> login(String username, String password) async {
    final isValid = await storage.validateUser(username, password);

    if (isValid && storage is SecureUserStorage) {
      await (storage as SecureUserStorage).saveUserLoginStatus(true);
    }

    return isValid;
  }

  Future<void> deleteUser() async {
    await storage.clearUser();
    if (storage is SecureUserStorage) {
      await (storage as SecureUserStorage).clearLoginStatus();
    }
  }

  Future<void> logout() async {
    if (storage is SecureUserStorage) {
      await (storage as SecureUserStorage).clearLoginStatus();
    }
  }

  Future<Map<String, String>?> getUser() {
    return storage.getUser();
  }

  Future<bool> isLoggedIn() async {
    if (storage is SecureUserStorage) {
      return await (storage as SecureUserStorage).isLoggedIn();
    }
    return false;
  }
}
