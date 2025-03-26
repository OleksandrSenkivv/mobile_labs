import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final Map<String, String>? args =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    final String username = args?['username'] ?? 'Guest';
    final String email = args?['email'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Plug'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Smart Plug',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    email.isNotEmpty ? 'Email: $email' : '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Головна'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home',
                    arguments: {'username': username, 'email': email},);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Профіль'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile',
                    arguments: {'username': username, 'email': email},);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Вийти'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Вітаю, $username!',
                style: const TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/profile',
                arguments: {'username': username, 'email': email},
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
                foregroundColor: Colors.black,
                minimumSize: Size(screenWidth * 0.6, 50),
              ),
              child: const Text(
                'Profile',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
