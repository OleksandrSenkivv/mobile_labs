import 'dart:async';
import 'dart:isolate';
import 'dart:math';

class AmperMeasure {
  static Isolate? _isolate;
  static ReceivePort? _receivePort;

  static Future<void> start(void Function(double) onAmperUpdate) async {
    _receivePort = ReceivePort();
    _receivePort!.listen((message) {
      if (message is double) {
        onAmperUpdate(message);
      }
    });

    _isolate = await Isolate.spawn<_IsolateMessage>(
      _amperIsolateEntry,
      _IsolateMessage(_receivePort!.sendPort),
    );
  }

  static void stop() {
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
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
