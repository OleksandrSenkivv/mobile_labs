import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/domain/user_service.dart';
import 'package:mobile_labs/functions/network_status_bar.dart';
import 'package:mobile_labs/pages/login/cubit/login_cubit.dart';
import 'package:mobile_labs/service/internet_service.dart';

class LoginPage extends StatelessWidget {
  final UserService userService;

  const LoginPage({required this.userService, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(userService: userService),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final networkProvider = context.watch<NetworkProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          const NetworkStatusBar(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state.user != null) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/home',
                        arguments: state.user,
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        if (state.errorMessage != null)
                          Text(
                            state.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 10),
                        TextField(
                          onChanged: (value) => context.read<LoginCubit>()
                              .updateUsername(value),
                          decoration: const InputDecoration(labelText:
                          'Username',),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          onChanged: (value) => context.read<LoginCubit>()
                              .updatePassword(value),
                          decoration: const InputDecoration(labelText:
                          'Password',),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                            if (!networkProvider.isConnected) {
                              context.read<LoginCubit>().showError('Немає '
                                  'підключення до Інтернету');
                            } else {
                              context.read<LoginCubit>().login();
                            }
                          },
                          child: state.isLoading
                              ? const CircularProgressIndicator(color:
                          Colors.white,)
                              : const Text('Login'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/signup'),
                          child: const Text('Sign Up'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
