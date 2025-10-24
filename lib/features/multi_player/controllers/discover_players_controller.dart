import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/dtos/get_online_players_request_dto.dart';
import 'package:word_guess/features/multi_player/dtos/get_online_players_response_dto.dart';
import 'package:word_guess/features/multi_player/dtos/join_room_response_dto.dart';
import 'package:word_guess/features/multi_player/dtos/send_invitation_request_dto.dart';
import 'package:word_guess/features/multi_player/models/player_model.dart';
import 'package:word_guess/services/api_service.dart';
import 'package:word_guess/services/hub_services.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/util/helpers/helper.dart';

class DiscoverPlayersController extends GetxController {
  final hub = Get.find<HubServices>();
  final _storage = Get.find<StorageService>();
  final _api = Get.find<ApiService>();
  var players = <PlayerModel>[].obs;
  Rx<RoomDto?> room = Rx<RoomDto?>(null);
  Rx<PlayerModel?> invitedPlayer = Rx(null);
  Rx<PlayerModel?> me = Rx(null);

  void sendInvitation(String playerId) async {
    int? wordLength = await _showSelectWordLengthDialog();
    final data = SendInvitationRequestDto(
      toPlayerId: playerId,
      fromPlayerId: _storage.playerId,
      wordLength: wordLength,
    ).toMap();

    await _api.post('player/invite', data: data);
  }

  getPlayers() async {
    final map = GetOnlinePlayersRequestDto(pageNumber: 1, pageSize: 10).toMap();
    try {
      final response = (await _api.get('players',
        body: map,
        fromJsonT: (map) => GetOnlinePlayersResponseDto.fromMap(map),
      )).data;

      players.value = response?.players ?? [];
      players.removeWhere((p) => p.id == _storage.playerId);
    } on Exception catch (e) {
      ApiService.handleApiError(e);
    }
  }

  //overrides
  @override
  void onInit() {
    getPlayers();
    hub.onNewPlayerConnected = _handleOnNewPlayerConnected;
    hub.onPlayerDisConnected = _handleOnPlayerDisconnected;
    super.onInit();
  }

  void _handleOnNewPlayerConnected(PlayerModel player) {
    if (player.id != _storage.playerId) {
      players.removeWhere((p) => p.id == player.id);
      players.add(player);
    }
  }

  void _handleOnPlayerDisconnected(PlayerModel player) {
    players.removeWhere((p) => p.id == player.id);
  }

  Future<int> _showSelectWordLengthDialog() async {
    final lengthController = TextEditingController();
    await Get.defaultDialog<int>(
      title: 'اعدادات الغرفة',
      titleStyle: Get.textTheme.displaySmall,
      content: Column(
        children: [
          Text("حدد عدد الاحرف", style: Get.textTheme.titleLarge),
          Helper.buildTextFieldForCreateRoom(
            lengthController,
            "عدد الاحرف",
            "يجب ان لا يزيد على 8",
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          final parsed = int.tryParse(
            utf8.decode(lengthController.text.codeUnits),
          );
          final len = parsed == null
              ? 5
              : parsed > 8
              ? 8
              : parsed;
          Get.back(result: len);
          return;
        },
        child: Text('موافق'),
      ),
    );
    return int.tryParse(lengthController.text) ?? 5;
  }
}
