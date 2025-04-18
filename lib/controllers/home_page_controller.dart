import 'package:flutter/material.dart';
import 'package:mobile_labs/data/user_storage_secure.dart';

class HomePageController {
  final SecureUserStorage _storage = SecureUserStorage();

  final ValueNotifier<bool> isPlugOn = ValueNotifier(false);
  final voltage = 220.0;

  double getCurrentConsumption() => isPlugOn.value ? 75.0 : 0.0;

  HomePageController() {
    _loadSmartPlugStatus();
  }

  Future<void> _loadSmartPlugStatus() async {
    final savedStatus = await _storage.getSmartPlugStatus();
    isPlugOn.value = savedStatus;
  }

  void togglePlug() async {
    isPlugOn.value = !isPlugOn.value;
    await _storage.saveSmartPlugStatus(isPlugOn.value);
  }

  Future<void> logout() async {
    await _storage.saveUserLoginStatus(false);
  }

  void dispose() {
    isPlugOn.dispose();
  }
}
