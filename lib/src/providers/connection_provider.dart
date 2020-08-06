import 'package:connectivity/connectivity.dart';

class ConnectionProvider {
  Future<bool> checkConnection() async {
    bool status = false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      status = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      status = true;
    }
    return status;
  }
}
