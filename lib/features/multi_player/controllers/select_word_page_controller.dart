import 'package:flutter/src/widgets/editable_text.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/multiplayer_options_page_controller.dart';
import 'package:word_guess/features/multi_player/models/select_word_request_dto.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/services/hub_services.dart';

class XSelectWordPageController extends GetxController {
  final wordController = TextEditingController();
  final hub = Get.find<XHubServices>().connection;
  final storage = Get.find<StorageService>();
  final room = Get.find<XMultiplayerOptionsPageController>().room;
  final opponentGuess = ''.obs;

  RxBool wordSelected = false.obs;
  RxBool isOpponentSelect = false.obs;
  RxBool isWordLengthError = false.obs;
  // final seconds = 60.obs;
  // Timer? _timer;

  // void startTimer() {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (seconds.value == 0) {
  //       timer.cancel();
  //       onTimerFinish();
  //     } else {
  //       seconds.value--;
  //     }
  //   });
  // }

  // void onTimerFinish() {
  //   // 👉 Perform your action here
  //   Get.snackbar('⏰ انتهى الوقت', '');
  //   Get.toNamed(XRoutes.multiplayerGame);
  // }

  void submitRandomWord() {
    wordController.text = "محمدز";
    submitWord();
  }

  void submitWord() async {
    if (wordController.text.length == room?.wordLength) {
      var dto = SelectWordRequestDto(
        roomkey: room!.key,
        id: storage.playerId!,
        word: wordController.text,
      );
      await hub.invoke('SelectWord', args: <Object>[dto.toMap()]);
      setMyWord();
      wordSelected.value = true;
      Get.toNamed(XRoutes.multiplayerGame);
    } else {
      isWordLengthError.value = true;
    }
  }

  setMyWord() {
    if (storage.playerId == room?.creator.clientId) {
      room?.creatorWord = wordController.text;
    } else {
      room?.jonerWord = wordController.text;
    }
  }

  void sendGuess() {
    hub.invoke(
      'SendMyGuess',
      args: <Object>[storage.playerId!, wordController.text],
    );
  }

  @override
  void onInit() {
    hub.on(
      'ReceiveOpponentSelectedItsWord',
      _handleReceiveOpponentSelectedItsWord,
    );
    hub.on('ReceiveOpponentGuess', _handelReceiveOpponentGuess);

    super.onInit();
  }

  @override
  void onClose() {
    // _timer?.cancel();
    hub.off('ReceiveOpponentSelectedItsWord');
    hub.off('ReceiveOpponentGuess');
    super.onClose();
  }

  void _handleReceiveOpponentSelectedItsWord(List? arguments) {
    isOpponentSelect.value = true;
    arguments = arguments as List;
    final (id, word) = (arguments[0] as String, arguments[1] as String);
    if (room?.creator.clientId == id) {
      room?.creatorWord = word;
    } else {
      room?.jonerWord = word;
    }
  }

  void _handelReceiveOpponentGuess(List? arguments) {
    arguments = arguments as List;
    final (id, guess) = (arguments[0] as String, arguments[1] as String);

    opponentGuess.value = guess;
  }
}
