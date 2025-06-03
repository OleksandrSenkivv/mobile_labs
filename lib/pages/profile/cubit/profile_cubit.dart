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
