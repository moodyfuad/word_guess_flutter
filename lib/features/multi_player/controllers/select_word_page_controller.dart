import 'package:flutter/src/widgets/editable_text.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/multiplayer_options_page_controller.dart';
import 'package:word_guess/features/multi_player/models/join_room_response_dto.dart';
import 'package:word_guess/features/multi_player/models/player_model.dart';
import 'package:word_guess/features/multi_player/models/select_word_request_dto.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/services/hub_services.dart';

class XSelectWordPageController extends GetxController {
  final wordController = TextEditingController();
  final hub = Get.find<HubServices>();
  final storage = Get.find<StorageService>();
  final _options = Get.find<MultiplayerOptionsPageController>();
  RoomDto get room => _options.room!;
  PlayerModel get creator => room.creatorId == _options.me!.id ? _options.me!: _options.opponent! ;
  PlayerModel get joiner => room.joinerId == _options.me!.id ? _options.me!: _options.opponent! ;
  final opponentGuess = ''.obs;

  RxBool wordSelected = false.obs;
  RxBool isOpponentSelect = false.obs;
  RxBool isWordLengthError = false.obs;

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
      await hub.sendWord(dto.toMap());

      setMyWord();
      wordSelected.value = true;
      Get.toNamed(XRoutes.multiplayerGame);
    } else {
      isWordLengthError.value = true;
    }
  }

  setMyWord() {
    if (storage.playerId == room?.creatorId) {
      room?.creatorWord = wordController.text;
    } else {
      room?.joinerWord = wordController.text;
    }
  }

  void sendGuess() {
    hub.sendMyGuess(storage.playerId!, wordController.text);
  }

  @override
  void onInit() {
    hub.onReceiveOpponentSelectedItsWord = (id, word) {
      if (storage.playerId == room?.creatorId) {
        room?.joinerWord = word;
      } else {
        room?.creatorWord = word;
      }
    };

    hub.onReceiveOpponentGuess = (id, guess) {
      opponentGuess.value = guess;
    };
    

    super.onInit();
  }

  @override
  void onClose() {
    
    super.onClose();
  }
  
}
