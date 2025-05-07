import 'package:flutter/material.dart';
import 'package:mobile_labs/service/internet_service.dart';
import 'package:provider/provider.dart';

class NetworkStatusBar extends StatelessWidget {
  final bool isLoginScreen;

  const NetworkStatusBar({super.key, this.isLoginScreen = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(
      builder: (context, networkProvider, _) {
        if (!networkProvider.hasCheckedOnce) return const SizedBox.shrink();

        final isConnected = networkProvider.isConnected;

        if (isLoginScreen && !isConnected) {
          return Container(
            width: double.infinity,
            color: Colors.red,
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Немає підключення до Інтернету. Вхід може бути обмежено.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!isLoginScreen && !isConnected) {
          return Container(
            width: double.infinity,
            color: Colors.orange,
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Попередження: втрачено підключення до Інтернету',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
