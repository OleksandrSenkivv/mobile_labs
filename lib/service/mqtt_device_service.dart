import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef MessageHandler = void Function(String topic, String payload);

class MqttDeviceService {
  final _client = MqttServerClient.withPort(
    'd92fdeed0d5d48028f3ae826a28a79e0.s1.eu.hivemq.cloud',
    'flutter_client',
    8883,
  );

  bool connected = false;

  Future<void> connect(
      MessageHandler onMessage,
      VoidCallback onConnected,
      VoidCallback onDisconnected,
      ) async {
    _client.secure = true;
    _client.setProtocolV311();
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);

    _client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .authenticateAs('DeviceName', '1234passworD')
        .startClean();

    _client.onConnected = () {
      connected = true;
      onConnected();
    };

    _client.onDisconnected = () {
      connected = false;
      onDisconnected();
    };

    try {
      final result = await _client.connect();
      if (result?.state != MqttConnectionState.connected) {
        throw Exception('MQTT зʼєднання не встановлено: ${result?.state}');
      }

      _client.subscribe('device/response', MqttQos.atLeastOnce);
      _client.subscribe('device/info_response', MqttQos.atLeastOnce);

      _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> events) {
        final recMess = events.first.payload as MqttPublishMessage;
        final payload =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        final topic = events.first.topic;
        onMessage(topic, payload);
      });
    } catch (e) {
      throw Exception('Помилка MQTT-підключення: $e');
    }
  }

  void publishMessage(String topic, String message) {
    if (!connected || _client.connectionStatus?.state !=
        MqttConnectionState.connected) {
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void disconnect() {
    _client.disconnect();
    connected = false;
  }
}
