class GamePhase {
  static const waitingForPlayers = 'waiting';
  static const waitingForSecrets = 'secrets';
  static const inProgress = 'in_progress';
  static const finished = 'finished';
}

class GameModel {
  final String gameKey;
  final bool opponentConnected;
  final String? phase;
  final int? currentTurn;
  final bool? playersReady; // both submitted secret words
  // extend with more fields (history, lastGuessResult, etc.)

  GameModel({
    required this.gameKey,
    required this.opponentConnected,
    this.phase,
    this.currentTurn,
    this.playersReady,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      gameKey: json['gameKey'] ?? '',
      opponentConnected: json['opponentConnected'] ?? false,
      phase: json['phase'],
      currentTurn: json['currentTurn'],
      playersReady: json['playersReady'],
    );
  }
}
