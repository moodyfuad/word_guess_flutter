import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService extends GetxService {
  final RxBool isOnline = false.obs;
  late StreamSubscription _subscription;
  late StreamSubscription _internetSubscription;

  Future<NetworkService> init() async {
    // Initial check
    isOnline.value = await InternetConnection().hasInternetAccess;

    // Listen to changes
    _subscription = Connectivity().onConnectivityChanged.listen((status) async {
      if (status.contains(ConnectivityResult.none)) {
        isOnline.value = false;
      } else {
        isOnline.value = await InternetConnection().hasInternetAccess;
      }
    });
    _internetSubscription = InternetConnection().onStatusChange.listen((event) {
      log(event.name);
      if (event == InternetStatus.connected) {
        isOnline.value = true;
      } else {
        isOnline.value = false;
      }
    });

    return this;
  }

  @override
  void onInit() {
    // init();
    super.onInit();
  }

  @override
  void onClose() {
    _subscription.cancel();
    _internetSubscription.cancel();
    super.onClose();
  }
}
