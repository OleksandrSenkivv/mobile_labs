import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/data/user_storage_secure.dart';
import 'package:mobile_labs/domain/user_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserService userService;
  final SecureUserStorage _storage = SecureUserStorage();

  LoginCubit({required this.userService}) : super(LoginState.initial());

  void updateUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void showError(String message) {
    emit(state.copyWith(errorMessage: message));
  }

  Future<void> login() async {
    emit(state.copyWith(isLoading: true));

    final success = await userService.login(state.username, state.password);
    if (!success) {
      emit(state.copyWith(isLoading: false, errorMessage:
      'Невірний логін або пароль',),);
      return;
    }

    final user = await userService.getUser();
    if (user != null) {
      await _storage.saveUserLoginStatus(true);
      emit(state.copyWith(isLoading: false, user: user));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage:
      'Помилка при отриманні даних користувача',),);
    }
  }
}
