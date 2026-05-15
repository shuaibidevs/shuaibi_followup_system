import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class Connection {
  static final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get onStatusChange =>
      _connectivity.onConnectivityChanged;

  static Future<bool> isConnected() async {
    List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  // static Future<bool> hasInternet() async {
  //   try {
  //     final result = await InternetAddress.lookup('https://www.google.com');
  //     return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  //   } catch (_) {
  //     return false;
  //   }
  // }
  // static Future<bool> hasInternet() async {
  //   try {
  //     final response = await http
  //         .get(Uri.parse('https://clients3.google.com/generate_204'))
  //         .timeout(const Duration(seconds: 5));

  //     return response.statusCode == 200;
  //   } catch (_) {
  //     return false;
  //   }
  // }
}
