import 'package:flutter/material.dart';
import 'package:mobile_labs/domain/user_service.dart';

class SignUpPageController {
  final UserService userService;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final ValueNotifier<String?> error = ValueNotifier(null);

  SignUpPageController({required this.userService});

  Future<bool> register() async {
    final msg = await userService.register(
      usernameController.text.trim(),
      emailController.text.trim(),
      passwordController.text,
    );
    if (msg == null) {
      error.value = null;
      return true;
    } else {
      error.value = msg;
      return false;
    }
  }

  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    error.dispose();
  }
}
