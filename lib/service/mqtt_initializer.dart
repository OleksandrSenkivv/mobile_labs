import 'package:mobile_labs/controllers/home_page_controller.dart';
import 'package:mobile_labs/service/mqtt_service.dart';

MQTTService initMQTT(HomePageController controller) {
  return MQTTService(
    username: 'My_Cred',
    password: 'MyCred1234',
    mqttBroker: '28c5545e26094092b6785f4d24098c1f.s1.eu.hivemq.cloud',
    topics: [
      'home/voltage',
      'home/consumption',
    ],
    onMessageReceived: (topic, message) {
      final double? value = double.tryParse(message.trim());
      if (value == null) return;

      if (!controller.isPlugOn.value) return;

      switch (topic) {
        case 'home/voltage':
          controller.voltage.value = value;
          break;
        case 'home/consumption':
          controller.consumption.value = value;
          break;
      }
    },
  );
}
