import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/services/hub_services.dart';
import 'package:word_guess/services/network_services.dart';

class HomePageController extends GetxController {
  final playOnlineSwitch = false.obs;
  final nameFieldVisible = false.obs;
  final nameController = TextEditingController();
  final storage = Get.find<StorageService>();
  final hub = Get.find<XHubServices>();
  final hasInternet = Get.find<NetworkService>().isOnline;
  late StreamSubscription _internetSubscription;
  String get playerName => storage.playerName ?? '';

  void enableOnlinePlay() async {
    if (!hasInternet.value) {
      showNoInternetAccessSnackbar();
      return;
    }
    if (nameController.text.isNotEmpty) {
      await storage.updatePlayerName(nameController.text);
    }
    if (storage.playerName == null || storage.playerName!.isEmpty) {
      nameFieldVisible.value = true;
      return;
    } else {
      nameFieldVisible.value = false;
    }
    hub.connection.on(
      'ReceiveOnlineUser',
      (arg) => _handleReceiveConnectionIdAsync(arg),
    );
    await hub.start();

    playOnlineSwitch.value = true;
  }

  void enablePlayerName() {
    nameController.text = playerName;
    nameFieldVisible.value = true;
  }

  void disableOnlinePlay() {
    hub.connection.stop();
    hub.connection.off('ReceiveOnlineUser');
    showNoInternetAccessSnackbar();
    playOnlineSwitch.value = false;
  }

  void _handleReceiveConnectionIdAsync(connectionId) {
    Get.snackbar(
      'Connection Id',
      connectionId[0] as String,
      backgroundColor: Colors.green,
    );
  }

  void showNoInternetAccessSnackbar() {
    Get.snackbar(
      'لا يوجد اتصال انترنت',
      'يجب ان تكون متصلا بالانترنت لتتمكن من اللعب عبر الشبكة',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onInit() {
    _internetSubscription = hasInternet.listen((val) {
      if (!val) {
        disableOnlinePlay();
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    _internetSubscription.cancel();
    nameController.dispose();
    hub.connection.stop();

    super.dispose();
  }
}
