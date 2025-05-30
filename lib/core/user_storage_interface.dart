abstract class UserStorageInterface {
  Future<void> saveUser(String username, String email, String password);
  Future<Map<String, String>?> getUser();
  Future<bool> validateUser(String username, String password);
  Future<void> clearUser();
  Future<void> clearLoginStatus();
}
