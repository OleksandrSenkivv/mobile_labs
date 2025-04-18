import 'package:flutter/material.dart';
import 'package:mobile_labs/controllers/profile_page_controller.dart';
import 'package:mobile_labs/domain/user_service.dart';


class ProfilePage extends StatefulWidget {
  final UserService userService;
  const ProfilePage({required this.userService, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfilePageController controller;

  @override
  void initState() {
    super.initState();
    controller = ProfilePageController(widget.userService)..loadUser();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildField(String label, String value, TextEditingController?
  controller,) {
    return controller != null
        ? TextField(controller: controller, decoration:
    InputDecoration(labelText: label),)
        : Align(
      alignment: Alignment.centerLeft,
      child: Text('$label: $value', style: const TextStyle(fontSize: 18,
          fontWeight: FontWeight.w500,),),
    );
  }

  Widget _buildButtons(Map<String, String> user) {
    if (controller.isEditing) {
      return Row(
        children: [
          ElevatedButton(
            onPressed: () async {
              await controller.saveChanges();
              setState(() {});
            },
            child: const Text('Зберегти'),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () {
              controller.cancelEditing();
              setState(() {});
            },
            child: const Text('Скасувати'),
          ),
        ],
      );
    }
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            controller.startEditing();
            setState(() {});
          },
          child: const Text('Редагувати'),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: () async {
            final confirm = await controller.confirmDelete(context);
            if (confirm) {
              await controller.deleteAccount();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'),
          backgroundColor: Colors.green,),
      body: ValueListenableBuilder(
        valueListenable: controller.user,
        builder: (context, user, _) {
          if (user == null) {
            return const Center(child:
          CircularProgressIndicator(),);
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.lightGreen,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 30),
                if (controller.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(controller.error!, style: const TextStyle(
                        color: Colors.red,),),
                  ),
                _buildField('Логін користувача', user['username'] ?? '',
                    controller.isEditing ?
                    controller.usernameController : null,),
                const SizedBox(height: 10),
                _buildField('Пошта користувача', user['email'] ?? '',
                    controller.isEditing ? controller.emailController : null,),
                const SizedBox(height: 30),
                _buildButtons(user),
              ],
            ),
          );
        },
      ),
    );
  }
}
