import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/models/create_game_room_request_dto.dart';
import 'package:word_guess/features/multi_player/models/join_game_request_Dto.dart';
import 'package:word_guess/features/multi_player/models/join_room_response_dto.dart';
import 'package:word_guess/features/multi_player/models/player_model.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/services/hub_services.dart';

class MultiplayerOptionsPageController extends GetxController {
  // Rx
  final RxString key = ''.obs;
  RoomDto? room;
  PlayerModel? opponent;
  PlayerModel? me;
  // services
  final HubServices hubServices = Get.find<HubServices>();
  final StorageService storage = Get.find<StorageService>();
  // controllers
  final maxAttemptsController = TextEditingController();
  final wordLengthController = TextEditingController();
  final nameController = TextEditingController();
  final keyController = TextEditingController();

  void enableEditRoom() {
    key.value = '';
    update();
  }

  Future<void> createRoom() async {
    final mayAttempts = int.tryParse(maxAttemptsController.text) ?? 6;
    final wordLength = int.tryParse(wordLengthController.text) ?? 5;
    final params = CreateGameRoomRequestDto(
      creatorId: storage.playerId!,
      creatorName: storage.playerName ?? nameController.text,
      maxAttempts: mayAttempts,
      wordLength: wordLength,
    );
    hubServices.createRoom(params.toMap());
  }

  void joinRoom() {
    final params = JoinGameRequestDto(
      GameKey: keyController.text,
      JoinerId: storage.playerId!,
      JoinerName: storage.playerName,
    );
    hubServices.joinRoom(params.toMap());
  }

  @override
  void onInit() {
    hubServices.onOpponentLeaveGame = _showOpponentDisconnectedSnackbar;
    hubServices.onReceiveGameRoomCreated = (room) {
      Get.snackbar('تم انشاء الغرفة', 'لقد قامت بانشاء غرفة للعب');
      key.value = room.key;
      room = room;
      update();
    };
    hubServices.onReceiveGameRoomJoined = (room, creator, joiner) {
      key.value = room.key;
      opponent = (storage.playerId == creator.id) ? joiner : creator;
      me = (storage.playerId != creator.id) ? joiner : creator;

      Get.snackbar(
        'تم الانضمام',
        'تم الانضمام الى غرفة ${opponent?.name} بنجاح',
      );
      this.room = room;

      update();

      Get.toNamed(XRoutes.selectWord);
    };
    super.onInit();
  }

  @override
  void dispose() {
    maxAttemptsController.dispose();
    wordLengthController.dispose();
    nameController.dispose();
    keyController.dispose();
    super.dispose();
  }

  //private
  _showOpponentDisconnectedSnackbar() {
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
