import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/services/hub_services.dart';
import 'package:word_guess/services/network_services.dart';

class HomePageController extends GetxController {
  HomePageController({
    required HubServices hub,
    required NetworkService networkService,
    required StorageService storageService,
  }) : _networkService = networkService,
       _hub = hub,
       _storageService = storageService;
  final StorageService _storageService;
  final HubServices _hub;
  final NetworkService _networkService;
  // Rx
  final playOnlineSwitch = false.obs;
  final nameFieldVisible = false.obs;
  String get playerName => _storageService.playerName ?? '';
  RxBool get hasInternet => _networkService.isOnline;
  // controllers
  final nameController = TextEditingController();
  //listeners
  late StreamSubscription _internetSubscription;

  void enableOnlinePlay() async {
    if (!hasInternet.value) {
      showNoInternetAccessSnackbar();
      return;
    }
    if (nameController.text.isNotEmpty) {
      await _storageService.updatePlayerName(nameController.text);
    }
    if (_storageService.playerName == null ||
        _storageService.playerName!.isEmpty) {
      nameFieldVisible.value = true;
      return;
    } else {
      nameFieldVisible.value = false;
    }
    _hub.onReceiveOnlineUser = _handleReceiveConnectionIdAsync;

    await _hub.start().then((_) async {
      if (_hub.connectionState == HubConnectionState.connected) {
        playOnlineSwitch.value = true;
      } else {
        showCanNotConnectToServerSnackbar();
        await _hub.stop();
      }
    });
  }

  void enablePlayerName() {
    nameController.text = playerName;
    nameFieldVisible.value = true;
  }

  void disableOnlinePlay() {
    _hub.stop();
    showNoInternetAccessSnackbar();
    playOnlineSwitch.value = false;
  }

  void _handleReceiveConnectionIdAsync(String connectionId) {
    Get.snackbar('Connection Id', connectionId, backgroundColor: Colors.green);
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

  void showCanNotConnectToServerSnackbar() {
    Get.snackbar(
      'هناك مشكلة فيي السيرفر',
      'عذرا البرنامج لا يستطيع الاتصال بالسيرفر حاليا، لكن يمكنك دائما اللعب فرديا',
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
        // disableOnlinePlay();
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    _internetSubscription.cancel();
    nameController.dispose();
    super.dispose();
  }
}
