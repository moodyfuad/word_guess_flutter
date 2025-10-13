import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/models/create_game_room_request_dto.dart';
import 'package:word_guess/features/multi_player/models/join_game_request_Dto.dart';
import 'package:word_guess/features/multi_player/models/join_room_response_dto.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/services/hub_services.dart';

class XMultiplayerOptionsPageController extends GetxController {
  final RxString key = ''.obs;
  RoomResponseDto? room;
  final XHubServices hubServices = Get.find<XHubServices>();
  final StorageService storage = Get.find<StorageService>();
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
    hubServices.connection.invoke('CreateRoom', args: <Object>[params.toMap()]);
  }

  void joinRoom() {
    final params = JoinGameRequestDto(
      GameKey: keyController.text,
      JoinerId: storage.playerId!,
      JoinerName: storage.playerName,
    );
    hubServices.connection.invoke('JoinRoom', args: <Object>[params.toMap()]);
  }

  Future<void> _handleReceiveGameRoomCreated(
    dynamic createGameRoomRequestDto,
  ) async {
    final list = createGameRoomRequestDto as List;
    final decoded = list.first;
    var dto = RoomResponseDto.fromMap(decoded as Map<String, dynamic>);
    Get.snackbar(
      'تم انشاء الغرفة',
      'لقد قام ${dto.creator.name} بانشاء غرفة للعب',
    );
    key.value = dto.key;
    room = dto;
    update();
  }

  _handleReceiveGameRoomJoined(dynamic joinGameRequestDto) {
    final res = RoomResponseDto.fromMap(
      (joinGameRequestDto as List).first as Map<String, dynamic>,
    );
    key.value = res.key;

    Get.snackbar(
      'تم الانضمام',
      'تم الانضمام الى غرفة ${res.creator.name} بنجاح',
    );
    room = res;
    update();

    Get.toNamed(XRoutes.selectWord);
  }

  @override
  void onInit() {
    hubServices.connection.on(
      'ReceiveGameRoomCreated',
      (arg) => _handleReceiveGameRoomCreated(arg),
    );
    hubServices.connection.on(
      'ReceiveGameRoomJoined',
      (arg) => _handleReceiveGameRoomJoined(arg),
    );
    hubServices.start();
    super.onInit();
  }

  @override
  void dispose() {
    hubServices.connection.off('ReceiveGameRoomCreated');
    hubServices.connection.off('ReceiveGameRoomJoined');
    hubServices.connection.stop();
    super.dispose();
  }
}
