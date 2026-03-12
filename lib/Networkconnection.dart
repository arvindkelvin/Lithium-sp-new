import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();
  static MyConnectivity get instance => _instance;

  final Connectivity _connectivity = Connectivity();

  final StreamController<bool> _controller =
  StreamController<bool>.broadcast();

  Stream<bool> get internetStream => _controller.stream;

  void initialise() async {
    final results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);

    _connectivity.onConnectivityChanged.listen((results) {
      _updateConnectionStatus(results);
    });
  }

  Future<void> _updateConnectionStatus(
      List<ConnectivityResult> results) async {
    bool hasInternet = false;

    final ConnectivityResult result =
    results.isNotEmpty ? results.first : ConnectivityResult.none;

    if (result != ConnectivityResult.none) {
      try {
        final response = await http
            .get(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 5));
        hasInternet = response.statusCode == 200;
      } catch (_) {
        hasInternet = false;
      }
    }

    _controller.add(hasInternet);
  }

  void dispose() {
    _controller.close();
  }
}
