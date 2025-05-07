import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef MultiMessageCallback = void Function(String topic, String message);

class MQTTService {
  final String username;
  final String password;
  final String mqttBroker;
  final List<String> topics;
  final MultiMessageCallback onMessageReceived;

  late MqttServerClient _mqttClient;

  MQTTService({
    required this.username,
    required this.password,
    required this.mqttBroker,
    required this.topics,
    required this.onMessageReceived,
  }) {
    _mqttClient = MqttServerClient.withPort(mqttBroker,
        'mqtt_flutter_client', 8883,);
    _mqttClient.logging(on: false);
    _mqttClient.secure = true;
    _mqttClient.keepAlivePeriod = 20;
    _mqttClient.setProtocolV311();
    _mqttClient.securityContext = SecurityContext.defaultContext;
  }

  Future<void> connect() async {
    final connMessage = MqttConnectMessage()
        .withClientIdentifier('mqtt_flutter_client')
        .authenticateAs(username, password)
        .withWillQos(MqttQos.atMostOnce);
    _mqttClient.connectionMessage = connMessage;

    try {
      await _mqttClient.connect();
      if (_mqttClient.connectionStatus!.state == MqttConnectionState.connected)
      {
        for (final topic in topics) {
          _mqttClient.subscribe(topic, MqttQos.atMostOnce);
        }

        _mqttClient.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
          final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
          final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
          final topic = c[0].topic;

          onMessageReceived(topic, payload);
        });
      } else {
        mqttDisconnect();
      }
    } catch (e) {
      mqttDisconnect();
    }
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    final payload = builder.payload;
    if (payload != null) {
      _mqttClient.publishMessage(topic, MqttQos.atMostOnce, payload);
    }
  }


  void mqttDisconnect() {
    _mqttClient.disconnect();
  }
}
