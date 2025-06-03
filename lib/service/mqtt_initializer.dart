import'package:mobile_labs/constants/mqtt_constants.dart';
import 'package:mobile_labs/pages/home/cubit/home_cubit.dart';
import 'package:mobile_labs/service/mqtt_service.dart';

MQTTService initMQTT(HomeCubit cubit) {
  final service = MQTTService(
    username: mqttUsername,
    password: mqttPassword,
    mqttBroker: mqttBroker,
    topics: [
      'home/voltage',
      'home/consumption',
    ],
    onMessageReceived: (topic, message) {
      final double? value = double.tryParse(message.trim());
      if (value == null) return;

      cubit.updateSensorData(topic, value);
    },
  );

  service.connect();
  return service;
}
