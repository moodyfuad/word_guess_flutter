import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/room_controller.dart';
import 'package:word_guess/features/multi_player/dtos/join_room_response_dto.dart';
import 'package:word_guess/features/multi_player/models/player_model.dart';
import 'package:word_guess/features/multi_player/dtos/select_word_request_dto.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/services/api_service.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/services/hub_services.dart';
import 'package:word_guess/util/helpers/helper.dart';

class XSelectWordPageController extends GetxController {
  //controllers
  final wordController = TextEditingController();
  // services
  final hub = Get.find<HubServices>();
  final api = Get.find<ApiService>();
  final storage = Get.find<StorageService>();
  // final _options = Get.find<RoomController>();
  // getters
  RoomController get roomController => Get.find<RoomController>();
  RoomDto get room => roomController.room!;
  // PlayerModel get creator =>
  //     room.creatorId == _options.me!.id ? _options.me! : _options.opponent!;
  // PlayerModel get joiner =>
  // room.joinerId == _options.me!.id ? _options.me! : _options.opponent!;
  PlayerModel get creator => roomController.creator;
  PlayerModel get joiner => roomController.joiner;
  final opponentGuess = ''.obs;

  late Timer _timer;
  final RxBool isMyWordSelected = false.obs;
  final RxBool isOpponentSelected = false.obs;
  final RxBool canPop = false.obs;
  final RxDouble seconds = 60.0.obs;

  void submitRandomWord() {
    wordController.text = Helper.getRandomWord(room.wordLength);
    isMyWordSelected.value = true;
    _showRandomWordSelectedDialog();
    submitWord();
  }

  void submitWord() async {
    if (wordController.text.length == room.wordLength) {
      var dto = SelectWordRequestDto(
        roomKey: room.key,
        id: storage.playerId,
        word: wordController.text,
      );

      final response = await api.post('room/submitWord', data: dto.toMap());

      setMyWord();
      isMyWordSelected.value = response.success;
      //todo: stop the timer
      _timer.cancel();
      if (isMyWordSelected.value && isOpponentSelected.value) {
        Get.toNamed(XRoutes.multiplayerGame);
      }
    } else {}
  }

  setMyWord() {
    if (storage.playerId == room.creatorId) {
      room.creatorWord = wordController.text;
    } else {
      room.joinerWord = wordController.text;
    }
  }

  // void sendGuess() {
  //   hub.sendMyGuess(storage.playerId!, wordController.text);
  // }
  handelPop() async {
    final d = await Helper.showOnWillPopDialog('تنبيه', [
      'سيتم احتساب النتيجة كخسارة',
      'هل ترغب في مغادرة الغرفة ؟',
    ], onResult: (val) {});

    if (d) {
      Get.back(closeOverlays: true);
    }
  }

  @override
  void onInit() {
    hub.onReceiveOpponentSelectedItsWord = (id, word) {
      if (storage.playerId == room.creatorId) {
        room.joinerWord = word;
      } else {
        room.creatorWord = word;
      }
      isOpponentSelected.value = true;
      if (isMyWordSelected.value) {
        Get.toNamed(XRoutes.multiplayerGame);
      }
    };
    hub.onOpponentLeaveGame = _showOpponentLeftSnackbar;

    hub.onReceiveOpponentGuess = (id, guess) {
      opponentGuess.value = guess;
    };
    _startTimer();

    super.onInit();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (seconds.value <= 0) {
        _timer.cancel();
        if (!isMyWordSelected.value) {
          submitRandomWord();
        }
      } else {
        seconds.value = seconds.value - 0.1;
      }
    });
  }

  _showRandomWordSelectedDialog() async {
    await Future.delayed(1.seconds.abs());
    final dialog = Get.defaultDialog<bool>(
      title: 'لقد تم اختيار كلمة عشوائية',
      content: Column(
        children: [
          Text("كلمتك هي"),
          Text(wordController.text, style: Get.textTheme.displayMedium),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text('موافق'),
      ),
      onConfirm: () => true,
      onWillPop: () => Future.value(true),
    );
  }

  _showOpponentLeftSnackbar() {
    Get.snackbar(
      'انقطع الاتصال عند الخصم',
      'انتظر 20 ثانية ليتم احتساب فوزك بشكل تلقائي',

      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
