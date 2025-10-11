import 'package:signalr_core/signalr_core.dart';

typedef GameUpdateCallback = void Function(Map<String, dynamic> data);
typedef GuessResultCallback = void Function(Map<String, dynamic> data);

class SignalRService {
  late HubConnection _hub;
  final String baseUrl;
  final GameUpdateCallback onGameUpdate;
  final GuessResultCallback onGuessResult;

  SignalRService({
    required this.baseUrl,
    required this.onGameUpdate,
    required this.onGuessResult,
  });

  Future<void> connect(String gameKey, String clientId) async {
    _hub = HubConnectionBuilder()
        .withUrl('$baseUrl/hubs/game')
        .build();

    _hub.on('ReceiveGameStateAsync', (args) {
      if (args != null && args.isNotEmpty) onGameUpdate(args.first as Map<String, dynamic>);
    });
    _hub.on('ReceiveGuessResultAsync', (args) {
      if (args != null && args.isNotEmpty) onGuessResult(args.first as Map<String, dynamic>);
    });

    await _hub.start();
    await _hub.invoke('JoinGroup', args: [gameKey, clientId]);
  }

  Future<void> disconnect(String gameKey, String clientId) async {
    await _hub.invoke('LeaveGroup', args: [gameKey, clientId]);
    await _hub.stop();
  }
}
