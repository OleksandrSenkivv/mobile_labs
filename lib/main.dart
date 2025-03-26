import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Association App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Association app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  IconData? _selectedIcon;

  void _changeIcon() {
    setState(() {
      final String input = _controller.text.trim();
      final Map<String, IconData> iconMap = {
        'airplane': Icons.airplanemode_active,
        'house': Icons.house,
        'car': Icons.car_repair,
        'phone': Icons.phone_android,
        'headphones': Icons.headphones,
        'football': Icons.sports_football,
        'chair': Icons.chair,
        'bed': Icons.bed,
        'tv': Icons.tv,
        'sun': Icons.sunny,
      };
      _selectedIcon = iconMap[input.toLowerCase()];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_selectedIcon != null)
            Column(
              children: [
                Icon(_selectedIcon, size: 100, color: Colors.deepPurple),
                const SizedBox(height: 20),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter object name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _changeIcon,
            child: const Text('Show Icon'),
          ),
        ],
      ),
    );
  }
}
