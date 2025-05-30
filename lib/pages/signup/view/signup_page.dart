import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/domain/user_service.dart';
import 'package:mobile_labs/functions/network_status_bar.dart';
import 'package:mobile_labs/pages/signup/cubit/signup_cubit.dart';

class SignUpPage extends StatelessWidget {
  final UserService userService;

  const SignUpPage({required this.userService, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(userService: userService),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            const NetworkStatusBar(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state.errorMessage != null)
                            Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          const SizedBox(height: 10),
                          TextField(
                            onChanged: context.read<SignUpCubit>().emailChanged,
                            decoration: const InputDecoration(labelText:
                            'Email',),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            onChanged: context.read<SignUpCubit>()
                                .usernameChanged,
                            decoration: const InputDecoration(labelText:
                            'Username',),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            onChanged: context.read<SignUpCubit>()
                                .passwordChanged,
                            decoration: const InputDecoration(labelText:
                            'Password',),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          if (state.isLoading)
                            const CircularProgressIndicator()
                          else
                            ElevatedButton(
                              onPressed: () async {
                                final success = await context
                                    .read<SignUpCubit>().register();
                                if (success) {
                                  final user = await userService.getUser();
                                  if (user != null && context.mounted) {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/home',
                                      arguments: user,
                                    );
                                  }
                                }
                              },
                              child: const Text('Register'),
                            ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Log In'),
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
      ),
    );
  }
}
