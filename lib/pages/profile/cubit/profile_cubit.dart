import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/domain/user_service.dart';
import 'package:mobile_labs/pages/profile/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserService userService;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  ProfileCubit({required this.userService})
      : super(ProfileState(user: null, isEditing: false, error: null)) {
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await userService.getUser();
    if (user != null) {
      usernameController.text = user['username'] ?? '';
      emailController.text = user['email'] ?? '';
    }
    emit(state.copyWith(user: user));
  }

  Future<void> saveChanges() async {
    final newUsername = usernameController.text.trim();
    final newEmail = emailController.text.trim();
    final password = state.user?['password'] ?? '';

    final msg = await userService.register(newUsername, newEmail, password);
    if (msg != null) {
      emit(state.copyWith(error: msg));
    } else {
      emit(state.copyWith(isEditing: false));
      await loadUser();
    }
  }

  void startEditing() {
    emit(state.copyWith(isEditing: true));
  }

  void cancelEditing() {
    usernameController.text = state.user?['username'] ?? '';
    emailController.text = state.user?['email'] ?? '';
    emit(state.copyWith(isEditing: false));
  }

  Future<bool> confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Видалити акаунт'),
        content: const Text('Ви впевнені, що хочете видалити акаунт?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Так'),
          ),
        ],
      ),
    );
    return result == true;
  }

  Future<void> deleteAccount() async {
    await userService.deleteUser();
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    emailController.dispose();
    return super.close();
  }
}
