import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();

    Connectivity().onConnectivityChanged.listen((result) {
      if (result is ConnectivityResult) {
        isConnected.value = result != ConnectivityResult.none;
      }else{
        isConnected.value = result.any((r) => r != ConnectivityResult.none);
      }
        
    });

    // Initial check (single result)
    Connectivity().checkConnectivity().then((result) {
      isConnected.value = result != ConnectivityResult.none;
    });
  }
}
