import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/domain/user_service.dart';
import 'package:mobile_labs/functions/log_out_dialog.dart';
import 'package:mobile_labs/functions/network_status_bar.dart';
import 'package:mobile_labs/pages/home/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  final String username;
  final String email;
  final UserService userService;

  const HomePage({
    required this.username,
    required this.email,
    required this.userService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: HomeView(
        username: username,
        email: email,
        userService: userService,
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  final String username;
  final String email;
  final UserService userService;

  const HomeView({
    required this.username,
    required this.email,
    required this.userService,
    super.key,
  });

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
                  const Text('Smart Plug',
                      style: TextStyle(color: Colors.white, fontSize: 24),),
                  Text(email, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Профіль'),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Налаштування'),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Лічильник'),
              onTap: () => Navigator.pushNamed(context, '/counter'),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Вийти'),
              onTap: () async {
                final cubit = context.read<HomeCubit>();
                final navigator = Navigator.of(context);
                final confirm = await showLogoutDialog(context);
                if (confirm == true) {
                  await cubit.logout();
                  await userService.storage.clearLoginStatus();
                  navigator.pushReplacementNamed('/login');
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
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Вітаю, $username!',
                            style: const TextStyle(fontSize: 24),),
                        const SizedBox(height: 30),
                        Icon(
                          state.isPlugOn ? Icons.power : Icons.power_off,
                          color: state.isPlugOn ? Colors.green : Colors.grey,
                          size: 100,
                        ),
                        const SizedBox(height: 20),
                        Text('Вольтаж: ${state.voltage.toStringAsFixed(1)} V',
                            style: const TextStyle(fontSize: 22),),
                        const SizedBox(height: 10),
                        Text('Споживання: ${state.consumption.toStringAsFixed(1)
                        } W',
                            style: const TextStyle(fontSize: 22),),
                        const SizedBox(height: 10),
                        Text('Ампераж: ${state.amper.toStringAsFixed(1)} A',
                            style: const TextStyle(fontSize: 22),),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<HomeCubit>().togglePlug(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            state.isPlugOn ? Colors.red : Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16,),
                          ),
                          child: Text(
                            state.isPlugOn
                                ? 'Вимкнути розетку'
                                : 'Увімкнути розетку',
                            style: const TextStyle(fontSize: 18),
                          ),
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
