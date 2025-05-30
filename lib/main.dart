import 'package:flutter/material.dart';
import 'package:mobile_labs/data/user_storage_secure.dart';
import 'package:mobile_labs/domain/user_service.dart';
import 'package:mobile_labs/pages/counter/view/counter_page.dart';
import 'package:mobile_labs/pages/home/view/home_page.dart';
import 'package:mobile_labs/pages/login/view/login_page.dart';
import 'package:mobile_labs/pages/profile/view/profile_page.dart';
import 'package:mobile_labs/pages/settings/view/settings_page.dart';
import 'package:mobile_labs/pages/signup/view/signup_page.dart';
import 'package:mobile_labs/service/internet_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = SecureUserStorage();
  final service = UserService(storage);
  final user = await service.getUser();
  final isLoggedIn = await storage.isLoggedIn();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
      ],
      child: MyApp(
        userService: service,
        initialUser: user,
        initialRoute: isLoggedIn ? '/home' : '/login',
      ),
    ),
  );
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
            final args = settings.arguments as Map<String, String>?
                ?? initialUser;
            if (args == null) {
              return MaterialPageRoute(
                builder: (_) => LoginPage(userService: userService),
              );
            }
            return MaterialPageRoute(
              builder: (_) => HomePage(
                username: args['username']!,
                email: args['email']!,
                userService: userService,
              ),
            );
          case '/profile':
            return MaterialPageRoute(
              builder: (_) => ProfilePage(userService: userService),
            );
          case '/settings':
            return MaterialPageRoute(
              builder: (_) => const SettingsPage(),
            );
          case '/counter':
            return MaterialPageRoute(
              builder: (_) => const CounterPage(),
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
