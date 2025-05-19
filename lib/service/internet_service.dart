import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isConnected = true;
  bool _initialCheckDone = false;

  bool get isConnected => _isConnected;
  bool get hasCheckedOnce => _initialCheckDone;

  NetworkProvider() {
    _startMonitoring();
  }

  void _startMonitoring() async {
    final results = await _connectivity.checkConnectivity();
    _setStatus(results, silent: true);
    _initialCheckDone = true;
    notifyListeners();

    _subscription = _connectivity.onConnectivityChanged.listen(_setStatus);
  }

  void _setStatus(List<ConnectivityResult> results, {bool silent = false}) {
    final hasConnection = results.any((r) => r != ConnectivityResult.none);
    if (_isConnected != hasConnection) {
      _isConnected = hasConnection;
      notifyListeners();
    }
    if (!silent && !_isConnected) {
      debugPrint('[NetworkProvider] З’єднання втрачено');
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
