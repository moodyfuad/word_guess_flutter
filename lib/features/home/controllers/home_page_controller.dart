import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:word_guess/features/multi_player/controllers/room_controller.dart';
import 'package:word_guess/features/multi_player/dtos/join_room_response_dto.dart';
import 'package:word_guess/features/multi_player/dtos/send_invitation_response_dto.dart';
import 'package:word_guess/features/multi_player/models/invitation_states.dart';
import 'package:word_guess/features/multi_player/models/player_model.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/services/api_service.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/services/hub_services.dart';
import 'package:word_guess/services/network_services.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/util/helpers/helper.dart';
import 'package:word_guess/widgets/secondary_button.dart';

class HomePageController extends GetxController {
  HomePageController({
    required HubServices hub,
    required NetworkService networkService,
    required StorageService storageService,
  }) : _networkService = networkService,
       _hub = hub,
       _storage = storageService;
  //
  final StorageService _storage;
  HubServices _hub;
  final NetworkService _networkService;
  final ApiService _api = Get.find();
  final _options = Get.find<RoomController>();
  // Rx
  final playOnlineSwitch = false.obs;
  final nameFieldVisible = false.obs;
  final isWaitingForConnection = false.obs;
  RxString get playerName => _storage.playerName.obs;
  RxInt get playedCount => _storage.playedCount.obs;
  late RxInt winCount;
  RxBool get hasInternet => _networkService.isOnline;
  // controllers
  final nameController = TextEditingController();
  //listeners
  late StreamSubscription _internetSubscription;

  void enableOnlinePlay() async {
    isWaitingForConnection.value = true;
    if (!hasInternet.value) {
      _showNoInternetAccessSnackbar();
      isWaitingForConnection.value = false;
      return;
    }
    if (nameController.text.isNotEmpty) {
      await _storage.updatePlayerName(nameController.text);
      _hub = HubServices(_storage.playerId, _storage.playerName);
      onInit();
    }
    if (_storage.playerName.isEmpty) {
      nameFieldVisible.value = true;
      isWaitingForConnection.value = false;
      showProfileBottomSheet();
      return;
    } else {
      nameFieldVisible.value = false;
    }
    await _hub.start();

    if (_hub.connectionState == HubConnectionState.connected) {
      playOnlineSwitch.value = true;
      isWaitingForConnection.value = false;
    } else {
      _showCanNotConnectToServerSnackbar();
      await _hub.stop();
      playOnlineSwitch.value = false;
    }
  }

  void enablePlayerName() {
    nameController.text = playerName.value;
    nameFieldVisible.value = true;
    showProfileBottomSheet();
  }

  void disableOnlinePlay() {
    _hub.stop();
    // showNoInternetAccessSnackbar();
    playOnlineSwitch.value = false;
    isWaitingForConnection.value = false;
  }

  void _showNoInternetAccessSnackbar() {
    
    Helper.showSnackbar(
      'لا يوجد اتصال انترنت',
      'يجب ان تكون متصلا بالانترنت لتتمكن من اللعب عبر الشبكة',
     SnackbarTypes.fail
    );
  }

  void _showCanNotConnectToServerSnackbar() {
    Helper.showSnackbar(
      'هناك مشكلة في السيرفر',
      'عذرا البرنامج لا يستطيع الاتصال بالسيرفر حاليا، لكن يمكنك دائما اللعب فرديا',
     SnackbarTypes.fail
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
     Helper.showSnackbar(
        'تمت الموفق على الدعوة',
        'سيتم تحويلكم للعب الان استمتعوا بالتجربة',
        SnackbarTypes.success
      );
    } else {
     Helper.showSnackbar(
        'تم رفض الدعوة',
        'للاسف قام اللاعب برفض الدعوة حاول مرة اخرى لاحقا',
       SnackbarTypes.fail
      );
    }
  }

  void _showInvitationReceivedDialog(PlayerModel player) {
    Helper.showDialog(
      'لقد وصلتك دعوة للعب',
      children: [Text("تمت دعوتك للعب من قبل ${player.name}")],
      confirmText: 'موافقة',
      onConfirm: () {
        final res = SendInvitationResponseDto(
          toPlayerId: player.id,
          fromPlayerId: _storage.playerId,
          state: InvitationStates.accepted,
        ).toMap();
        _api.post('player/invite/response', data: res);

        Get.back();
      },
      cancelText: 'رفض',
      onCancel: () {
        final res = SendInvitationResponseDto(
          toPlayerId: player.id,
          fromPlayerId: _storage.playerId,
          state: InvitationStates.rejected,
        ).toMap();
        _api.post('player/invite/response', data: res);
        Get.back();
      },
    );
  }

  void _handleOnInvitationResponse(
    RoomDto room,
    PlayerModel creator,
    PlayerModel joiner,
  ) async {
    // this.room.value = room;
    final invitedPlayer = (_storage.playerId == creator.id) ? joiner : creator;
    final me = (_storage.playerId == joiner.id) ? joiner : creator;

   Helper.showSnackbar(
      'تم الانضمام',
      'تم الانضمام الى غرفة ${invitedPlayer.name} بنجاح',
      SnackbarTypes.success

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

  showScoreBottomSheet() {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                child: Text(
                  'لعبت ${_storage.playedCount} مرة',
                  style: Get.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                child: Text(
                  'فزت ${_storage.winCount} مرة',
                  style: Get.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: XAppColorsLight.bg,
    );
  }

  showProfileBottomSheet() async {
    await Get.bottomSheet(
      Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: XAppColorsLight.bg_element_container,
              child: Icon(
                Icons.person,
                size: 50,
                color: XAppColorsLight.primary_text,
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      playerName.value,
                      style: Get.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    SecondaryButton(
                      'تعديل',
                      onPressed: () {
                        Get.back();
                        enablePlayerName();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: nameFieldVisible.value,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        style: Get.textTheme.bodyMedium,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          enableOnlinePlay();
                          Get.back(closeOverlays: true);
                          update();
                        },
                        controller: nameController,
                        decoration: InputDecoration(
                          label: Text(
                            XHomePageStrings.name.tr,
                            style: Get.textTheme.bodySmall,
                          ),
                          helper: _storage.playerName.isNotEmpty
                              ? null
                              : Text(
                                  XHomePageStrings.nameNecessaryMsg.tr,
                                  style: Get.textTheme.bodySmall!.copyWith(
                                    color: Colors.redAccent[400],
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SecondaryButton(
                        'تأكيد',
                        onPressed: () {
                          enableOnlinePlay();
                          Get.back(closeOverlays: true);
                          update();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: XAppColorsLight.bg,
    );
    nameFieldVisible.value = false;
  }
}
