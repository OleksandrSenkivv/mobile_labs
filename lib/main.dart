import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/data/user_storage_secure.dart';
import 'package:mobile_labs/domain/user_service.dart';
import 'package:mobile_labs/pages/home_page.dart';
import 'package:mobile_labs/pages/login_page.dart';
import 'package:mobile_labs/pages/profile_page.dart';
import 'package:mobile_labs/pages/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = SecureUserStorage();
  final service = UserService(storage);
  final user = await service.getUser();
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final String? isLoggedIn = await secureStorage.read(key: 'isLoggedIn');

  runApp(MyApp(
    userService: service,
    initialUser: user,
    initialRoute: isLoggedIn == 'true' ? '/home' : '/login',
  ),);
}

class MyApp extends StatelessWidget {
  final UserService userService;
  final Map<String, String>? initialUser;
  final String initialRoute;

  const MyApp({
    required this.userService,
    required this.initialUser,
    required this.initialRoute,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Plug',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              builder: (_) => LoginPage(userService: userService),
            );
          case '/signup':
            return MaterialPageRoute(
              builder: (_) => SignUpPage(userService: userService),
            );
          case '/home':
            final args = settings.arguments as Map<String, String>? ?? initialUser;
            if (args == null) {
              return MaterialPageRoute(
                builder: (_) => LoginPage(userService: userService),
              );
            }
            return MaterialPageRoute(
              builder: (_) => HomePage(
                username: args['username']!,
                email: args['email']!,
              ),
            );
          case '/profile':
            return MaterialPageRoute(
              builder: (_) => ProfilePage(userService: userService),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => LoginPage(userService: userService),
            );
        }
      },
    );
  }
}
