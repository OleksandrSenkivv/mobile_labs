import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/pages/counter/cubit/counter_cubit.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  String? _getMessage(int value) {
    if (value < 10) return 'Значення замале';
    if (value > 100) return 'Значення завелике';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Counter Page')),
        body: Center(
          child: BlocBuilder<CounterCubit, int>(
            builder: (context, count) {
              final message = _getMessage(count);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Значення: $count',
                    style: const TextStyle(fontSize: 32),
                  ),
                  if (message != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            context.read<CounterCubit>().incrementBy8(),
                        child: const Text('+8'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<CounterCubit>().decrementBy5(),
                        child: const Text('-5'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
