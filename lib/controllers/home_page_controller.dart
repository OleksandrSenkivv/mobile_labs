import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_labs/data/user_storage_secure.dart';
import 'package:mobile_labs/functions/amper_measure.dart';
import 'package:mobile_labs/service/mqtt_service.dart';

class HomePageController {
  final SecureUserStorage _storage = SecureUserStorage();

  final ValueNotifier<bool> isPlugOn = ValueNotifier(false);
  final ValueNotifier<double> voltage = ValueNotifier(220);
  final ValueNotifier<double> consumption = ValueNotifier(0);
  final ValueNotifier<double> amper = ValueNotifier(0);

  MQTTService? _mqttService;

  HomePageController() {
    _loadSmartPlugStatus();
    _startAmperMeasure();
  }

  Future<void> _loadSmartPlugStatus() async {
    final savedStatus = await _storage.getSmartPlugStatus();
    isPlugOn.value = savedStatus;

    if (isPlugOn.value) {
      _startListeningData();
    }
  }

  void togglePlug() async {
    isPlugOn.value = !isPlugOn.value;
    await _storage.saveSmartPlugStatus(isPlugOn.value);

    if (isPlugOn.value) {
      _startListeningData();
    } else {
      _stopListeningData();
      voltage.value = 220.0;
      consumption.value = 0.0;
    }
  }

  void _startListeningData() {
    _mqttService ??= MQTTService(
      username: 'My_Cred',
      password: 'MyCred1234',
      mqttBroker: 'd92fdeed0d5d48028f3ae826a28a79e0.s1.eu.hivemq.cloud',
      topics: ['home/voltage', 'home/consumption'],
      onMessageReceived: (topic, message) {
        final value = double.tryParse(message.trim());
        if (value == null) return;
        if (topic == 'home/voltage') {
          voltage.value = value;
        } else if (topic == 'home/consumption') {
          consumption.value = value;
        }
      },
    );

    _mqttService!.connect();
  }

  void _stopListeningData() {
    _mqttService?.mqttDisconnect();
  }

  void _startAmperMeasure() {
    AmperMeasure.start((a) => amper.value = a);
  }

  void _stopAmperMeasure() {
    AmperMeasure.stop();
  }

  Future<void> logout() async {
    await _storage.saveUserLoginStatus(false);
  }

  void dispose() {
    isPlugOn.dispose();
    voltage.dispose();
    consumption.dispose();
    amper.dispose();
    _stopListeningData();
    _stopAmperMeasure();
  }
}
