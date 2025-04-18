import 'package:mobile_labs/core/user_storage_interface.dart';

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
    return null;
  }

  Future<bool> login(String username, String password) {
    return storage.validateUser(username, password);
  }

  Future<void> deleteUser() {
    return storage.clearUser();
  }

  Future<Map<String, String>?> getUser() {
    return storage.getUser();
  }
}
