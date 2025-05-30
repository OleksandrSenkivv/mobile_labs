import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/pages/settings/cubit/settings_state.dart';
import 'package:mobile_labs/service/mqtt_device_service.dart';
import 'package:mobile_labs/settings_widgets/message_handler.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final MqttDeviceService mqtt;

  SettingsCubit(this.mqtt) : super(const SettingsState());

  Future<void> connect() async {
    try {
      await mqtt.connect(
        _handleMessage,
            () => emit(state.copyWith(connected: true)),
            () => emit(state.copyWith(connected: false)),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Помилка зʼєднання: $e'));
    }
  }

  void _handleMessage(String topic, String payload) {
    processMqttMessage(
      topic: topic,
      payload: payload,
      setDeviceInfo: (serial, deviceId, loaded) {
        emit(state.copyWith(serial: serial, deviceId: deviceId, infoLoaded:
        loaded,),);
      },
      onSerialConfirmed: () {
        emit(state.copyWith(expectSerialEditorRequest: true));
      },
      showError: (msg) {
        emit(state.copyWith(errorMessage: msg));
      },
      isExpectingConfirmation: () => state.expectingSerialConfirmation,
      clearConfirmation: () {
        emit(state.copyWith(expectingSerialConfirmation: false));
      },
    );
  }

  void sendCredentials() {
    mqtt.publishMessage('device/request',
        '{"user":"DeviceName","pass":"1234passworD"}',);
    emit(state.copyWith(expectingSerialConfirmation: true));
  }

  void sendSerial(String serial) {
    mqtt.publishMessage('device/set_serial', '{"serial":"$serial"}');
    emit(state.copyWith(expectingSerialConfirmation: true));
  }

  void requestDeviceInfo() {
    mqtt.publishMessage('device/info_request', '{"request":"info"}');
  }

  void clearError() {
    emit(state.copyWith());
  }

  void resetSerialEditorFlag() {
    emit(state.copyWith(expectSerialEditorRequest: false));
  }

  Future<void> disconnect() async {
    mqtt.disconnect();
    emit(state.copyWith(connected: false));
  }
}
