import 'package:flutter/material.dart';
import 'package:mobile_labs/controllers/signup_page_controller.dart';
import 'package:mobile_labs/domain/user_service.dart';

class SignUpPage extends StatefulWidget {
  final UserService userService;
  const SignUpPage({required this.userService, super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late SignUpPageController controller;

  @override
  void initState() {
    super.initState();
    controller = SignUpPageController(userService: widget.userService);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<String?>(
                valueListenable: controller.error,
                builder: (_, error, __) => error != null
                    ? Text(error, style: const TextStyle(color: Colors.red))
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    final success = await controller.register();
                    if (success) {
                      final user = await widget.userService.getUser();
                      if (user != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            Navigator.pushReplacementNamed(context, '/home', arguments: user);
                          }
                        });
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
          ),
        ),
      ),
    );
  }
}
