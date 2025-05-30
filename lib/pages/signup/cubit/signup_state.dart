part of 'signup_cubit.dart';

class SignUpState extends Equatable {
  final String email;
  final String username;
  final String password;
  final String? errorMessage;
  final bool isLoading;

  const SignUpState({
    this.email = '',
    this.username = '',
    this.password = '',
    this.errorMessage,
    this.isLoading = false,
  });

  SignUpState copyWith({
    String? email,
    String? username,
    String? password,
    String? errorMessage,
    bool? isLoading,
  }) {
    return SignUpState(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [email, username, password, errorMessage,
    isLoading,];
}
