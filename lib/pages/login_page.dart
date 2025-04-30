import 'package:flutter/material.dart';
import 'package:mobile_labs/controllers/login_page_controller.dart';
import 'package:mobile_labs/domain/user_service.dart';

class LoginPage extends StatefulWidget {
  final UserService userService;
  const LoginPage({required this.userService, super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginPageController controller;
  String? error;

  @override
  void initState() {
    super.initState();
    controller = LoginPageController(userService: widget.userService);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onLoginPressed() async {
    final user = await controller.tryLogin();
    if (!mounted) return;

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home', arguments: user);
    } else {
      setState(() => error = 'Невірний логін або пароль');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (error != null)
                Text(
                  error!,
                  style: const TextStyle(color: Colors.red),
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
                onPressed: _onLoginPressed,
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
