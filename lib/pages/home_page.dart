import 'package:flutter/material.dart';
import 'package:mobile_labs/controllers/home_page_controller.dart';
import 'package:mobile_labs/functions/log_out_dialog.dart';
import 'package:mobile_labs/functions/network_status_bar.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String email;

  const HomePage({required this.username, required this.email, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageController controller;

  @override
  void initState() {
    super.initState();
    controller = HomePageController();
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
        title: const Text('Smart Plug'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Smart Plug', style: TextStyle(color:
                  Colors.white, fontSize: 24,),),
                  Text(widget.email, style:
                  const TextStyle(color: Colors.white70),),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Профіль'),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Вийти'),
                onTap: () async {
                  final confirm = await showLogoutDialog(context);
                  if (confirm == true) {
                    await controller.logout();
                    if (!context.mounted) return;
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const NetworkStatusBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: controller.isPlugOn,
                  builder: (context, isPlugOn, _) {
                    return ValueListenableBuilder<double>(
                      valueListenable: controller.voltage,
                      builder: (context, voltage, _) {
                        return ValueListenableBuilder<double>(
                          valueListenable: controller.consumption,
                          builder: (context, consumption, _) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Вітаю, ${widget.username}!',
                                    style: const TextStyle(fontSize: 24),),
                                const SizedBox(height: 30),
                                Icon(
                                  isPlugOn ? Icons.power : Icons.power_off,
                                  color: isPlugOn ? Colors.green : Colors.grey,
                                  size: 100,
                                ),
                                const SizedBox(height: 20),
                                Text('Вольтаж: ${voltage.toStringAsFixed(1)} V',
                                    style: const TextStyle(fontSize: 22),),
                                const SizedBox(height: 10),
                                Text('Споживання: ${consumption.toStringAsFixed
                                  (1)} W', style:
                                const TextStyle(fontSize: 22),),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: controller.togglePlug,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isPlugOn ? Colors.red :
                                    Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16,),
                                  ),
                                  child: Text(
                                    isPlugOn ? 'Вимкнути розетку' :
                                    'Увімкнути розетку',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
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
