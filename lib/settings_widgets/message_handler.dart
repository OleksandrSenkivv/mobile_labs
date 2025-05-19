import 'dart:convert';
import 'package:flutter/material.dart';

typedef SetDeviceInfo = void Function(String?, String?, bool);
typedef ShowSerialEditor = void Function();
typedef ShowError = void Function(String);
typedef IsExpectingConfirmation = bool Function();
typedef ClearConfirmation = void Function();

void handleMqttMessage({
  required BuildContext context,
  required String topic,
  required String payload,
  required SetDeviceInfo setDeviceInfo,
  required ShowSerialEditor showSerialEditor,
  required ShowError showError,
  required IsExpectingConfirmation isExpectingConfirmation,
  required ClearConfirmation clearConfirmation,
}) {
  try {
    final decoded = jsonDecode(payload);

    if (topic == 'device/info_response' || (decoded['serial'] != null
        && decoded['device'] != null)) {
      final serial = decoded['serial'] as String?;
      final device = decoded['device'] as String?;
      setDeviceInfo(serial, device, true);
      return;
    }

    if (decoded is Map) {
      if (decoded['status'] == 'success') {
        if (isExpectingConfirmation()) {
          clearConfirmation();
          showSerialEditor();
        }
      } else if (decoded['error'] != null) {
        showError('Невірні креденшинали');
      } else {
        showError('Невідома відповідь: $decoded');
      }
    } else {
      showError('Невідомий формат: $payload');
    }
  } catch (e) {
    showError('Помилка декодування відповіді');
  }
}
