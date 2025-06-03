part of 'login_cubit.dart';

class LoginState {
  final String username;
  final String password;
  final bool isLoading;
  final String? errorMessage;
  final Map<String, String>? user;

  const LoginState({
    required this.username,
    required this.password,
    required this.isLoading,
    this.errorMessage,
    this.user,
  });

  factory LoginState.initial() => const LoginState(
    username: '',
    password: '',
    isLoading: false,
  );

  LoginState copyWith({
    String? username,
    String? password,
    bool? isLoading,
    String? errorMessage,
    Map<String, String>? user,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user,
    );
  }
}
