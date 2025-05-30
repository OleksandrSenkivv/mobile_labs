import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_labs/domain/user_service.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final UserService userService;

  SignUpCubit({required this.userService})
      : super(const SignUpState());

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void usernameChanged(String value) {
    emit(state.copyWith(username: value));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  Future<bool> register() async {
    emit(state.copyWith(isLoading: true));
    final msg = await userService.register(
      state.username.trim(),
      state.email.trim(),
      state.password,
    );
    if (msg == null) {
      emit(state.copyWith(isLoading: false));
      return true;
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: msg));
      return false;
    }
  }
}
