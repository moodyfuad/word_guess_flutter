import 'package:get/get.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:word_guess/features/multi_player/dtos/get_online_players_response_dto.dart';
import 'package:word_guess/features/multi_player/dtos/join_room_response_dto.dart';
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
  HubConnection get _connection => _initialized ??= _init();
  set _connection(HubConnection val) {
    _initialized = val;
  }

  HubConnection? _initialized;
  HubConnectionState? get connectionState => _connection.state;

  Future<void> start() async {
    _connection = _init();
    if (_connection.state == HubConnectionState.disconnected) {
      _connection.on(
        'ReceiveOpponentSelectedItsWord',
        _handleReceiveOpponentSelectedItsWord,
      );
      _connection.on('ReceiveOpponentGuess', _handelReceiveOpponentGuess);
      _connection.on('ReceiveGameRoomCreated', _handleReceiveGameRoomCreated);
      _connection.on('ReceiveGameRoomJoined', _handleReceiveGameRoomJoined);
      _connection.on('ReceiveOnlineUser', _handleReceiveOnlineUser);
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
      await _connection.start();
    }
  }

  Future<void> stop() async {
    _connection.off('ReceiveOpponentSelectedItsWord');
    _connection.off('ReceiveOpponentGuess');
    _connection.off('ReceiveGameRoomCreated');
    _connection.off('ReceiveGameRoomJoined');
    _connection.off('ReceiveOnlineUser');
    _connection.off('OnOpponentDisconnected');
    _connection.off('OnReciveOnlinePlayers');
    _connection.off('OnNewPlayerConnected');
    await _connection.stop();
  }

  // invokes
  Future<dynamic> sendWord(Map<String, dynamic> selectWordRequestDto) async {
    return await _connection.invoke(
      'SelectWord',
      args: <Object>[selectWordRequestDto],
    );
  }

  Future<dynamic> sendMyGuess(String playerId, String word) async {
    return await _connection.invoke(
      'SendMyGuess',
      args: <Object>[playerId, word],
    );
  }

  // Future<dynamic> createRoom(
  //   Map<String, dynamic> createGameRoomRequestDto,
  // ) async {
  //   return await _connection.invoke(
  //     'CreateRoom',
  //     args: <Object>[createGameRoomRequestDto],
  //   );
  // }

  // Future<dynamic> joinRoom(Map<String, dynamic> joinGameRequestDto) async {
  //   return await _connection.invoke(
  //     'JoinRoom',
  //     args: <Object>[joinGameRequestDto],
  //   );
  // }

  Future<dynamic> leaveGame() async {
    return await _connection.invoke('LeaveGame', args: <Object>[]);
  }

  Future<dynamic> invitePlayer(
    Map<String, dynamic> sendInvitationRequestDto,
  ) async {
    return await _connection.invoke(
      'InvitePlayer',
      args: <Object>[sendInvitationRequestDto],
    );
  }

  Future<dynamic> responseToInvitation(
    Map<String, dynamic> sendInvitationResponseDto,
  ) async {
    return await _connection.invoke(
      'ResponseToInvitation',
      args: <Object>[sendInvitationResponseDto],
    );
  }

  // handlers
  void Function(String playerId, String word)? onReceiveOpponentSelectedItsWord;
  void Function(String playerId, String word)? onReceiveOpponentGuess;
  void Function(RoomDto room)? onReceiveGameRoomCreated;
  void Function(RoomDto room, PlayerModel creator, PlayerModel joiner)?
  onReceiveGameRoomJoined;
  void Function(String connectionId)? onReceiveOnlineUser;
  void Function()? onOpponentLeaveGame;
  void Function(GetOnlinePlayersResponseDto pagedPlayers)?
  onReceiveOnlinePlayers;
  void Function(PlayerModel player)? onNewPlayerConnected;
  void Function(PlayerModel player)? onPlayerDisConnected;
  void Function(RoomDto room, PlayerModel creator, PlayerModel joiner)?
  onGetsInvitationResponse;
  void Function(PlayerModel response)? onInvitationReceived;
  void Function(String state)? onInvitationRejected;

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

  void _handleReceiveOnlineUser(List? connectionId) {
    onReceiveOnlineUser?.call(connectionId?[0] as String);
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
    onInvitationReceived?.call(response);
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

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
