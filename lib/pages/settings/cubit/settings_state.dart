import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool connected;
  final bool infoLoaded;
  final bool expectingSerialConfirmation;
  final bool expectSerialEditorRequest;
  final String? serial;
  final String? deviceId;
  final String? errorMessage;

  const SettingsState({
    this.connected = false,
    this.infoLoaded = false,
    this.expectingSerialConfirmation = false,
    this.expectSerialEditorRequest = false,
    this.serial,
    this.deviceId,
    this.errorMessage,
  });

  SettingsState copyWith({
    bool? connected,
    bool? infoLoaded,
    bool? expectingSerialConfirmation,
    bool? expectSerialEditorRequest,
    String? serial,
    String? deviceId,
    String? errorMessage,
  }) {
    return SettingsState(
      connected: connected ?? this.connected,
      infoLoaded: infoLoaded ?? this.infoLoaded,
      expectingSerialConfirmation:
      expectingSerialConfirmation ?? this.expectingSerialConfirmation,
      expectSerialEditorRequest:
      expectSerialEditorRequest ?? this.expectSerialEditorRequest,
      serial: serial ?? this.serial,
      deviceId: deviceId ?? this.deviceId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    connected,
    infoLoaded,
    expectingSerialConfirmation,
    expectSerialEditorRequest,
    serial,
    deviceId,
    errorMessage,
  ];
}
