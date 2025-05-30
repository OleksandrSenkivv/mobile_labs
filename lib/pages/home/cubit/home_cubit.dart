import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/data/user_storage_secure.dart';
import 'package:mobile_labs/service/mqtt_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SecureUserStorage _storage = SecureUserStorage();
  MQTTService? _mqttService;

  Isolate? _amperIsolate;
  ReceivePort? _receivePort;

  HomeCubit() : super(HomeState.initial()) {
    _loadSmartPlugStatus();
    _startAmperMeasure();
  }

  Future<void> _loadSmartPlugStatus() async {
    final savedStatus = await _storage.getSmartPlugStatus();
    emit(state.copyWith(isPlugOn: savedStatus));
    if (savedStatus) {
      _startListeningData();
    }
  }

  void togglePlug() async {
    final newStatus = !state.isPlugOn;
    emit(state.copyWith(isPlugOn: newStatus));

    await _storage.saveSmartPlugStatus(newStatus);

    if (newStatus) {
      _startListeningData();
    } else {
      _stopListeningData();
      emit(state.copyWith(voltage: 220, consumption: 0));
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
          emit(state.copyWith(voltage: value));
        } else if (topic == 'home/consumption') {
          emit(state.copyWith(consumption: value));
        }
      },
    );

    _mqttService!.connect();
  }

  void _stopListeningData() {
    _mqttService?.mqttDisconnect();
  }

  void _startAmperMeasure() async {
    _receivePort = ReceivePort();
    _receivePort!.listen((message) {
      if (message is double) {
        emit(state.copyWith(amper: message));
      }
    });

    _amperIsolate = await Isolate.spawn<_IsolateMessage>(
      _amperIsolateEntry,
      _IsolateMessage(_receivePort!.sendPort),
    );
  }

  void _stopAmperMeasure() {
    _receivePort?.close();
    _amperIsolate?.kill(priority: Isolate.immediate);
    _amperIsolate = null;
  }

  Future<void> logout() async {
    await _storage.saveUserLoginStatus(false);
    emit(state.copyWith(loggedOut: true));
  }

  @override
  Future<void> close() {
    _stopListeningData();
    _stopAmperMeasure();
    return super.close();
  }

  static void _amperIsolateEntry(_IsolateMessage message) {
    final sendPort = message.sendPort;
    final random = Random();

    Timer.periodic(const Duration(seconds: 5), (timer) {
      final amper = 1 + random.nextDouble() * 9;
      sendPort.send(amper);
    });
  }
}

class _IsolateMessage {
  final SendPort sendPort;
  _IsolateMessage(this.sendPort);
}
