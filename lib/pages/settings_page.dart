import 'package:flutter/material.dart';
import 'package:mobile_labs/service/mqtt_device_service.dart';
import 'package:mobile_labs/settings_widgets/device_info.dart';
import 'package:mobile_labs/settings_widgets/message_handler.dart';
import 'package:mobile_labs/settings_widgets/notification_dialog.dart';
import 'package:mobile_labs/settings_widgets/qr_scanner_dialog.dart';
import 'package:mobile_labs/settings_widgets/serial_editor_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final mqtt = MqttDeviceService();
  bool connected = false, infoLoaded = false;
  bool expectingSerialConfirmation = false;
  String? serial, deviceId;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    try {
      await mqtt.connect(
        _handleMessage,
            () => setState(() => connected = true),
            () => setState(() => connected = false),
      );
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorDialog(context, 'Помилка зʼєднання: $e');
      });
    }
  }

  void _handleMessage(String topic, String payload) {
    handleMqttMessage(
      context: context,
      topic: topic,
      payload: payload,
      setDeviceInfo: (s, d, loaded) => setState(() {
        serial = s;
        deviceId = d;
        infoLoaded = loaded;
      }),
      showSerialEditor: _showSerialEditor,
      showError: (msg) => showErrorDialog(context, msg),
      isExpectingConfirmation: () => expectingSerialConfirmation,
      clearConfirmation: () => setState(() =>
      expectingSerialConfirmation = false,),
    );
  }

  void _sendCredentials() {
    mqtt.publishMessage('device/request',
        '{"user":"DeviceName","pass":"1234passworD"}',);
    setState(() => expectingSerialConfirmation = true);
  }

  void _openQRScanner() {
    if (!connected) return showErrorDialog(context, 'MQTT не підключено');
    showQRScannerDialog(
      context,
      onScanned: (_) => _sendCredentials(),
    );
  }

  void _showSerialEditor() {
    if (!connected) return showErrorDialog(context, 'MQTT не підключено');
    showSerialEditorDialog(
      context,
      onSubmitted: (newSerial) {
        mqtt.publishMessage('device/set_serial', '{"serial":"$newSerial"}');
        setState(() => expectingSerialConfirmation = true);
        showSuccessDialog(context, 'Серійник "$newSerial" надіслано');
      },
    );
  }

  void _requestDeviceInfo() =>
      mqtt.publishMessage('device/info_request', '{"request":"info"}');

  @override
  void dispose() {
    mqtt.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = connected ? Colors.green : Colors.red;
    final statusText = connected ? 'MQTT зʼєднано' : 'MQTT не зʼєднано';

    return Scaffold(
      appBar: AppBar(title: const Text('Налаштування пристрою')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  connected ? Icons.cloud_done : Icons.cloud_off,
                  color: statusColor,
                ),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: TextStyle(fontWeight: FontWeight.bold, color:
                  statusColor,),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Сканувати QR'),
              onPressed: connected ? _openQRScanner : null,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.info_outline),
              label: const Text('Отримати дані пристрою'),
              onPressed: connected ? _requestDeviceInfo : null,
            ),
            if (infoLoaded)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),),
                margin: const EdgeInsets.only(top: 30),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Інформація про пристрій',
                          style: Theme.of(context).textTheme.titleLarge,),
                      const SizedBox(height: 12),
                      DeviceInfoTable(serial: serial, device: deviceId),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
