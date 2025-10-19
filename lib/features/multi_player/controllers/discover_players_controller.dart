import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/dtos/get_online_players_request_dto.dart';
import 'package:word_guess/features/multi_player/dtos/get_online_players_response_dto.dart';
import 'package:word_guess/features/multi_player/dtos/invitation_states.dart';
import 'package:word_guess/features/multi_player/dtos/send_invitation_request_dto.dart';
import 'package:word_guess/features/multi_player/dtos/send_invitation_response_dto.dart';
import 'package:word_guess/features/multi_player/models/player_model.dart';
import 'package:word_guess/services/hub_services.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/theme/app_colors.dart';

class DiscoverPlayersController extends GetxController {
  final hub = Get.find<HubServices>();
  final storage = Get.find<StorageService>();
  var players = <PlayerModel>[].obs;

  sendInvitation(String playerId) {
    hub.invitePlayer(
      SendInvitationRequestDto(
        toPlayerId: playerId,
        fromPlayerId: storage.playerId,
      ).toMap(),
    );
  }

  //overrides
  @override
  void onInit() {
    hub.GetOnlinePlayers(
      GetOnlinePlayersRequestDto(pageNumber: 1, pageSize: 10).toMap(),
    );
    hub.onReceiveOnlinePlayers = _handleOnReceiveOnlinePlayers;
    hub.onNewPlayerConnected = _handleOnNewPlayerConnected;
    hub.onPlayerDisConnected = _handleOnPlayerDisconnected;
    hub.onInvitationReceived = _handleOnInvitationReceived;
    hub.onGetsInvitationResponse = _handleOnInvitationResponse;
    super.onInit();
  }

  void _handleOnReceiveOnlinePlayers(GetOnlinePlayersResponseDto pagedPlayers) {
    players.addAll(pagedPlayers.players);
  }

  void _handleOnNewPlayerConnected(PlayerModel player) {
    players.add(player);
  }

  void _handleOnPlayerDisconnected(PlayerModel player) {
    players.removeWhere((p) => p.id == player.id);
  }

  void _handleOnInvitationReceived(PlayerModel player) {
    _showInvitationReceivedDialog(player);
  }

  void _handleOnInvitationResponse(SendInvitationResponseDto response) {
    _showInvitationResponseSnackbar(response);
  }

  void _showInvitationReceivedDialog(PlayerModel player) {
    Get.defaultDialog(
      title: 'لقد وصلتك دعوة للعب',
      content: Column(children: [Text("تمت دعوتك للعب من قبل ${player.name}")]),
      confirm: ElevatedButton(
        onPressed: () {
          hub.responseToInvitation(
            SendInvitationResponseDto(
              toPlayerId: player.id,
              fromPlayerId: storage.playerId,
              state: InvitationStates.accepted,
            ).toMap(),
          );
          Get.back();
        },
        child: Text('موافقة'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          {
            hub.responseToInvitation(
              SendInvitationResponseDto(
                toPlayerId: player.id,
                fromPlayerId: storage.playerId,
                state: InvitationStates.rejected,
              ).toMap(),
            );
            Get.back();
          }
        },
        child: Text('رفض'),
      ),
    );
  }

  void _showInvitationResponseSnackbar(SendInvitationResponseDto response) {
    if (response.state == InvitationStates.accepted) {
      Get.snackbar(
        'تمت الموفق على الدعوة',
        'سيتم تحويلكم للعب الان استمتعوا بالتجربة',
      );
    } else {
      Get.snackbar(
        'تم رفض الدعوة',
        'للاسف قام اللاعب برفض الدعوة حاول مرة اخرى لاحقا',
        backgroundColor: XAppColorsLight.danger,
      );
    }
  }
}
