import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/domain/user_service.dart';
import 'package:mobile_labs/functions/network_status_bar.dart';
import 'package:mobile_labs/pages/profile/cubit/profile_cubit.dart';
import 'package:mobile_labs/pages/profile/cubit/profile_state.dart';

class ProfilePage extends StatelessWidget {
  final UserService userService;

  const ProfilePage({required this.userService, super.key});

  Widget _buildField(String label, String value, TextEditingController?
  controller,) {
    return controller != null
        ? TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    )
        : Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildButtons(BuildContext context, ProfileState state, ProfileCubit
  cubit,) {
    if (state.isEditing) {
      return Row(
        children: [
          ElevatedButton(
            onPressed: () async {
              await cubit.saveChanges();
            },
            child: const Text('Зберегти'),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: cubit.cancelEditing,
            child: const Text('Скасувати'),
          ),
        ],
      );
    }
    return Row(
      children: [
        ElevatedButton(
          onPressed: cubit.startEditing,
          child: const Text('Редагувати'),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: () async {
            final confirm = await cubit.confirmDelete(context);
            if (confirm) {
              await cubit.deleteAccount();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route)
                => false,);
              }
            }
          },
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Видалити акаунт'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(userService: userService),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Профіль'),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            const NetworkStatusBar(),
            Expanded(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final cubit = context.read<ProfileCubit>();

                  if (state.user == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final user = state.user!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.lightGreen,
                          child: Icon(Icons.person, size: 50, color:
                          Colors.white,),
                        ),
                        const SizedBox(height: 30),
                        if (state.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              state.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        _buildField('Логін користувача', user['username'] ?? '',
                            state.isEditing ? cubit.usernameController : null,),
                        const SizedBox(height: 10),
                        _buildField('Пошта користувача', user['email'] ?? '',
                            state.isEditing ? cubit.emailController : null,),
                        const SizedBox(height: 30),
                        _buildButtons(context, state, cubit),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
