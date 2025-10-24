import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/room_controller.dart';
import 'package:word_guess/features/multi_player/dtos/create_game_room_request_dto.dart';
import 'package:word_guess/features/multi_player/dtos/join_game_request_Dto.dart';
import 'package:word_guess/features/multi_player/dtos/join_room_response_dto.dart';
import 'package:word_guess/services/api_service.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/services/hub_services.dart';

class MultiplayerOptionsPageController extends GetxController {
  // Rx
  final RxString key = ''.obs;
  //
  // services
  final HubServices _hubServices = Get.find<HubServices>();
  final StorageService _storage = Get.find<StorageService>();
  final ApiService _api = Get.find<ApiService>();
  // controllers
  final roomController = Get.find<RoomController>();
  final maxAttemptsController = TextEditingController();
  final wordLengthController = TextEditingController();
  final nameController = TextEditingController();
  final keyController = TextEditingController();

  void enableEditRoom() {
    key.value = '';
    update();
  }

  Future<void> createRoom() async {
    final mayAttempts = int.tryParse(maxAttemptsController.text) ?? 8;

    final wordLength = int.tryParse(wordLengthController.text) ?? 5;
    final params = CreateGameRoomRequestDto(
      creatorId: _storage.playerId,
      creatorName: _storage.playerName,
      maxAttempts: mayAttempts > 20 ? 20 : mayAttempts,
      wordLength: wordLength,
    );
    final response = await _api.post(
      'room',
      data: params.toMap(),
      fromJsonT: (map) => RoomDto.fromMap(map),
    );
    if (!response.success) {
      Get.snackbar('فشل انشاء الغرفة', response.message);
    } else {
      Get.snackbar('تم انشاء الغرفة', 'لقد قمت بانشاء غرفة للعب');
      key.value = response.data?.key ?? "";
      // room = response.data;
      // room;
      Get.find<RoomController>().room = response.data;
    }
    update();
  }

  void joinRoom() {
    final params = JoinGameRequestDto(
      GameKey: keyController.text,
      JoinerId: _storage.playerId,
      JoinerName: _storage.playerName,
    );
    _api.post('room/join', data: params.toMap());
  }

  @override
  void onInit() {
    
    _hubServices.onReceiveGameRoomJoined = (room, creator, joiner) {
      key.value = room.key;
      
      roomController.opponent = (_storage.playerId == creator.id) ? joiner : creator;
      roomController.me = (_storage.playerId != creator.id) ? joiner : creator;
       Get.snackbar(
        'تم الانضمام',
        'تم الانضمام الى غرفة ${roomController.opponent?.name} بنجاح',
      );
      roomController.room = room;
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
  
}
