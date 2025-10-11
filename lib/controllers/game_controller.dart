import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../services/api_service.dart';
import '../services/signalr_service.dart';

class GameController extends GetxController {
  final uuid = const Uuid();

  String clientId = '';
  RxString gameKey = ''.obs;
  String? secretWord;

  final gameState = {}.obs;
  final guesses = [].obs;
  final currentTurn = 0.obs;

  late SignalRService _signalR;

  @override
  void onInit() {
    super.onInit();
    clientId = uuid.v4();
  }

  Future<void> createGame() async {
    final res = await ApiService.createGame();
    gameKey.value = res['GameKey'];
    await connectSignalR();
  }

  Future<void> joinGame(String key) async {
    gameKey.value = key;
    await ApiService.joinGame(gameKey.value, clientId);
    await connectSignalR();
  }

  Future<void> connectSignalR() async {
    _signalR = SignalRService(
      baseUrl: 'http://guesswordar.runasp.net',
      onGameUpdate: (data) => gameState.value = data,
      onGuessResult: (data) {
        guesses.add(data);
      },
    );
    await _signalR.connect(gameKey.value, clientId);
  }

  Future<void> submitSecret(String word) async {
    secretWord = word;
    await ApiService.submitSecret(gameKey.value, clientId, word);
  }

  Future<void> submitGuess(String word) async {
    await ApiService.submitGuess(gameKey.value, clientId, word);
  }
}
