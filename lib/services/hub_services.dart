import 'dart:async';

import 'package:get/get.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:word_guess/features/multi_player/dtos/get_online_players_response_dto.dart';
import 'package:word_guess/features/multi_player/dtos/join_room_response_dto.dart';
import 'package:word_guess/features/multi_player/dtos/send_invitation_request_dto.dart';
import 'package:word_guess/features/multi_player/models/player_model.dart';
import 'package:word_guess/services/api_constants.dart';

class HubServices extends GetxService {
  HubServices(this.userId, this.name) {
    baseUrl = '${ApiConstants.baseUrl}hubs/game?userId="$userId"&name=$name';
    _init();
  }
  HubConnection _init() {
    return _connection = HubConnectionBuilder()
        .withUrl(baseUrl)
        .withAutomaticReconnect()
        .build();
  }

  final String userId;
  final String name;
  late String baseUrl;
  HubConnection get connection => _connection;
  HubConnection get _connection => _initialized ??= _init();
  set _connection(HubConnection val) {
    _initialized = val;
  }

  HubConnection? _initialized;
  HubConnectionState? get connectionState => _connection.state;

  Future<void> start({
    void Function(String error)? onDisconnect,
    void Function(String connectionIs)? onReconnected,
  }) async {
    _connection = _init();

    if (_connection.state == HubConnectionState.disconnected) {
      _connection.on(
        'ReceiveOpponentSelectedItsWord',
        _handleReceiveOpponentSelectedItsWord,
      );
      _connection.on('ReceiveOpponentGuess', _handelReceiveOpponentGuess);
      _connection.on('ReceiveGameRoomCreated', _handleReceiveGameRoomCreated);
      _connection.on('ReceiveGameRoomJoined', _handleReceiveGameRoomJoined);
      _connection.on('OnOpponentLeaveGame', _handleOnOpponentDisconnected);
      _connection.on('OnReciveOnlinePlayers', _handleOnReceiveOnlinePlayers);
      _connection.on('OnNewPlayerConnected', _handleOnNewPlayerConnected);
      _connection.on('OnPlayerDisconnected', _handleOnPlayerDisconnected);
      _connection.on('OnInvitationReceived', _handleOnInvitationReceived);
      _connection.on(
        'OnGetsInvitationResponse',
        _handleOnGetsInvitationResponse,
      );
      _connection.on('OnInvitationRejected', _handleOnInvitationRejected);
      _connection.on('ReceiveOpponentLeftGame', _handleReceiveOpponentLeftGame);
      _connection.onclose(
        (exception) => onDisconnect?.call(exception.toString()),
      );
      _connection.onreconnecting((e) => onDisconnect?.call(e.toString()));
      _connection.onreconnected(
        (connectionId) => onReconnected?.call(connectionId ?? ''),
      );
      await _connection.start();
    }
  }

  Future<void> stop() async {
    _connection.off('ReceiveOpponentSelectedItsWord');
    _connection.off('ReceiveOpponentGuess');
    _connection.off('ReceiveGameRoomCreated');
    _connection.off('ReceiveGameRoomJoined');
    _connection.off('OnOpponentDisconnected');
    _connection.off('OnReciveOnlinePlayers');
    _connection.off('OnNewPlayerConnected');
    await _connection.stop();
  }

  // handlers
  void Function(String playerId, String word)? onReceiveOpponentSelectedItsWord;
  void Function(String playerId, String word)? onReceiveOpponentGuess;
  void Function(RoomDto room)? onReceiveGameRoomCreated;
  void Function(RoomDto room, PlayerModel creator, PlayerModel joiner)?
  onReceiveGameRoomJoined;
  void Function()? onOpponentLeaveGame;
  void Function(GetOnlinePlayersResponseDto pagedPlayers)?
  onReceiveOnlinePlayers;
  void Function(PlayerModel player)? onNewPlayerConnected;
  void Function(PlayerModel player)? onPlayerDisConnected;
  void Function(RoomDto room, PlayerModel creator, PlayerModel joiner)?
  onGetsInvitationResponse;
  void Function(PlayerModel response, SendInvitationRequestDto details)?
  onInvitationReceived;
  void Function(String state)? onInvitationRejected;
  void Function()? onOpponentLeftGame;

  // private
  void _handleReceiveOpponentSelectedItsWord(List? arguments) {
    arguments = arguments as List;
    final (id, word) = (arguments[0] as String, arguments[1] as String);
    onReceiveOpponentSelectedItsWord?.call(id, word);
  }

  void _handelReceiveOpponentGuess(List? arguments) {
    arguments = arguments as List;
    final (id, guess) = (arguments[0] as String, arguments[1] as String);
    onReceiveOpponentGuess?.call(id, guess);
  }

  void _handleReceiveGameRoomCreated(List? createGameRoomRequestDto) {
    final dto = RoomDto.fromMap(
      (createGameRoomRequestDto as List)[0] as Map<String, dynamic>,
    );
    onReceiveGameRoomCreated?.call(dto);
  }

  void _handleReceiveGameRoomJoined(List? createGameRoomRequestDto) {
    final room = RoomDto.fromMap(
      (createGameRoomRequestDto as List)[0] as Map<String, dynamic>,
    );
    final creator = PlayerModel.fromMap(
      (createGameRoomRequestDto)[1] as Map<String, dynamic>,
    );
    final joiner = PlayerModel.fromMap(
      (createGameRoomRequestDto)[2] as Map<String, dynamic>,
    );
    onReceiveGameRoomJoined?.call(room, creator, joiner);
  }

  void _handleOnOpponentDisconnected(List? args) {
    onOpponentLeaveGame?.call();
  }

  void _handleOnReceiveOnlinePlayers(List? args) {
    var response = GetOnlinePlayersResponseDto.fromMap(
      args![0] as Map<String, dynamic>,
    );
    onReceiveOnlinePlayers?.call(response);
  }

  void _handleOnNewPlayerConnected(List? args) {
    var response = PlayerModel.fromMap(args![0] as Map<String, dynamic>);
    onNewPlayerConnected?.call(response);
  }

  void _handleOnPlayerDisconnected(List? args) {
    var response = PlayerModel.fromMap(args![0] as Map<String, dynamic>);
    onPlayerDisConnected?.call(response);
  }

  void _handleOnInvitationReceived(List? args) {
    var response = PlayerModel.fromMap(args![0] as Map<String, dynamic>);
    var details = SendInvitationRequestDto.fromMap(
      args[1] as Map<String, dynamic>,
    );
    onInvitationReceived?.call(response, details);
  }

  void _handleOnInvitationRejected(List? args) {
    onInvitationRejected?.call(args?[0] as String);
  }

  void _handleOnGetsInvitationResponse(List? args) {
    final room = RoomDto.fromMap((args as List)[0] as Map<String, dynamic>);
    final creator = PlayerModel.fromMap((args)[1] as Map<String, dynamic>);
    final joiner = PlayerModel.fromMap((args)[2] as Map<String, dynamic>);
    onGetsInvitationResponse?.call(room, creator, joiner);
  }

  void _handleReceiveOpponentLeftGame(List? args) {
    onOpponentLeftGame?.call();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
