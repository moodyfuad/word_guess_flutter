
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
  final _attempts = 8.obs;
  final _length = 5.obs;

  void sendInvitation(String playerId) async {
    if (await _showSelectWordLengthDialog()) {
      final data = SendInvitationRequestDto(
        toPlayerId: playerId,
        fromPlayerId: _storage.playerId,
        wordLength: _length.value,
        maxAttempts: _attempts.value,
      ).toMap();
      await _api.post('player/invite', data: data);
    }
  }

  getPlayers() async {
    final map = GetOnlinePlayersRequestDto(pageNumber: 1, pageSize: 10).toMap();
    try {
      final response = (await _api.get(
        'players',
        queryParameters: map,
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

  Future<bool> _showSelectWordLengthDialog() async {
    _attempts.value = 8;
    _length.value = 3;
    bool result = false;
    await Helper.showDialog(
      'اعدادات الغرفة',
      confirmText: 'موافق',
      children: [
        Row(
          children: [
            Expanded(
              child: Helper.buildSelectNumberWidget(
                start: _length.value,
                end: 7,
                (selected) => _length.value = selected,
                label: "عدد الاحرف",
              ),
            ),
            Expanded(
              child: Helper.buildSelectNumberWidget(
                start: _attempts.value,
                end: 30,
                (selected) => _attempts.value = selected,
                label: "عدد المحاولات",
              ),
            ),
          ],
        ),
      ],

      onConfirm: () {
        result = true;
      },
    );
    return result;
  }
}
