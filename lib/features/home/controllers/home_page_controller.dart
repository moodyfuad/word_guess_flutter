import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:word_guess/features/multi_player/controllers/multiplayer_options_page_controller.dart';
import 'package:word_guess/features/multi_player/controllers/room_controller.dart';
import 'package:word_guess/features/multi_player/dtos/join_room_response_dto.dart';
import 'package:word_guess/features/multi_player/dtos/send_invitation_response_dto.dart';
import 'package:word_guess/features/multi_player/models/invitation_states.dart';
import 'package:word_guess/features/multi_player/models/player_model.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/services/api_service.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/services/hub_services.dart';
import 'package:word_guess/services/network_services.dart';
import 'package:word_guess/theme/app_colors.dart';

class HomePageController extends GetxController {
  HomePageController({
    required HubServices hub,
    required NetworkService networkService,
    required StorageService storageService,
  }) : _networkService = networkService,
       _hub = hub,
       _storage = storageService;
  final StorageService _storage;
  HubServices _hub;
  final NetworkService _networkService;
  final ApiService _api = Get.find();
  // final _options = Get.find<MultiplayerOptionsPageController>();
  final _options = Get.find<RoomController>();
  // Rx
  final playOnlineSwitch = false.obs;
  final nameFieldVisible = false.obs;
  RxString get playerName => _storage.playerName.obs;
  RxInt get playedCount => _storage.playedCount.obs;
  late RxInt winCount;
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
      await _storage.updatePlayerName(nameController.text);
      _hub = HubServices(_storage.playerId, _storage.playerName);
      onInit();
    }
    if (_storage.playerName.isEmpty) {
      nameFieldVisible.value = true;
      return;
    } else {
      nameFieldVisible.value = false;
    }
    _hub.onReceiveOnlineUser = _handleReceiveConnectionIdAsync;

    await _hub.start();
    playOnlineSwitch.value = true;
    // await Future.delayed(1.seconds.abs());
    if (_hub.connectionState == HubConnectionState.connected) {
    } else {
      showCanNotConnectToServerSnackbar();
      await _hub.stop();
      playOnlineSwitch.value = false;
    }
  }

  void enablePlayerName() {
    nameController.text = playerName.value;
    nameFieldVisible.value = true;
  }

  void disableOnlinePlay() {
    _hub.stop();
    // showNoInternetAccessSnackbar();
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
      'هناك مشكلة في السيرفر',
      'عذرا البرنامج لا يستطيع الاتصال بالسيرفر حاليا، لكن يمكنك دائما اللعب فرديا',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onInit() {
    // playedCount = _storage.playedCount.obs;
    winCount = _storage.winCount.obs;
    _hub.onInvitationRejected = _showInvitationResponseSnackbar;
    _hub.onInvitationReceived = _showInvitationReceivedDialog;
    _hub.onGetsInvitationResponse = _handleOnInvitationResponse;

    super.onInit();
  }

  @override
  void dispose() {
    _internetSubscription.cancel();
    nameController.dispose();
    super.dispose();
  }

  _showInvitationResponseSnackbar(String state) {
    if (state == InvitationStates.accepted) {
      Get.snackbar(
        'تمت الموفق على الدعوة',
        'سيتم تحويلكم للعب الان استمتعوا بالتجربة',
      );
    } else {
      Get.snackbar(
        'تم رفض الدعوة',
        'للاسف قام اللاعب برفض الدعوة حاول مرة اخرى لاحقا',
        colorText: Colors.white,
        backgroundColor: XAppColorsLight.danger,
      );
    }
  }

  void _showInvitationReceivedDialog(PlayerModel player) {
    Get.defaultDialog(
      title: 'لقد وصلتك دعوة للعب',
      content: Column(children: [Text("تمت دعوتك للعب من قبل ${player.name}")]),
      confirm: ElevatedButton(
        onPressed: () {
          final res = SendInvitationResponseDto(
            toPlayerId: player.id,
            fromPlayerId: _storage.playerId,
            state: InvitationStates.accepted,
          ).toMap();
          _api.post('player/invite/response', data: res);
          // hub.responseToInvitation(
          //   SendInvitationResponseDto(
          //     toPlayerId: player.id,
          //     fromPlayerId: storage.playerId,
          //     state: InvitationStates.accepted,
          //   ).toMap(),
          // );
          Get.back();
        },
        child: Text('موافقة'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          final res = SendInvitationResponseDto(
            toPlayerId: player.id,
            fromPlayerId: _storage.playerId,
            state: InvitationStates.rejected,
          ).toMap();
          _api.post('player/invite/response', data: res);
          Get.back();
        },
        child: Text('رفض'),
      ),
    );
  }

  void _handleOnInvitationResponse(
    RoomDto room,
    PlayerModel creator,
    PlayerModel joiner,
  ) async {
    // this.room.value = room;
    final invitedPlayer = (_storage.playerId == creator.id) ? joiner : creator;
    final me = (_storage.playerId != creator.id) ? joiner : creator;

    Get.snackbar(
      'تم الانضمام',
      'تم الانضمام الى غرفة ${invitedPlayer.name} بنجاح',
    );
    update();

    _options.room = room;
    _options.me = me;
    _options.opponent = invitedPlayer;

    await Future.delayed(
      1.seconds.abs(),
      () => Get.toNamed(XRoutes.selectWord),
    );
  }
}
