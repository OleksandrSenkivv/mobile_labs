import 'package:flutter/material.dart';
import 'package:mobile_labs/domain/user_service.dart';

class ProfilePageController {
  final UserService userService;

  final ValueNotifier<Map<String, String>?> user = ValueNotifier(null);
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  bool isEditing = false;
  String? error;

  ProfilePageController(this.userService);

  void loadUser() async {
    final currentUser = await userService.getUser();
    if (currentUser != null) {
      user.value = currentUser;
      usernameController.text = currentUser['username']!;
      emailController.text = currentUser['email']!;
    }
  }

  Future<void> saveChanges() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = user.value?['password'] ?? '';

    final msg = await userService.register(username, email, password);
    if (msg != null) {
      error = msg;
    } else {
      isEditing = false;
      error = null;
      loadUser();
    }
  }

  Future<void> deleteAccount() async {
    await userService.deleteUser();
  }

  Future<bool> confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Видалити акаунт'),
        content: const Text('Ви впевнені, що хочете видалити акаунт?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: const Text('Скасувати'),),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: const Text('Так'),),
        ],
      ),
    );
    return confirm == true;
  }

  void startEditing() {
    isEditing = true;
  }

  void cancelEditing() {
    isEditing = false;
    usernameController.text = user.value?['username'] ?? '';
    emailController.text = user.value?['email'] ?? '';
  }

  void dispose() {
    user.dispose();
    usernameController.dispose();
    emailController.dispose();
  }
}
