import 'package:flutter/material.dart';
import 'package:mobile_labs/data/user_storage_secure.dart';
import 'package:mobile_labs/domain/user_service.dart';

class LoginPageController {
  final UserService userService;
  final SecureUserStorage _storage = SecureUserStorage();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPageController({required this.userService});

  Future<Map<String, String>?> tryLogin() async {
    final success = await userService.login(
      usernameController.text.trim(),
      passwordController.text,
    );
    if (!success) return null;

    final user = await userService.getUser();
    if (user != null) {
      await _storage.saveUserLoginStatus(true);
    }
    return user;
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}
