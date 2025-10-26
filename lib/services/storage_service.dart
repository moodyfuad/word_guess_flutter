import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/v4.dart';

class StorageService extends GetxService {
  late final GetStorage _box;
  Future<StorageService> init() async {
    _box = GetStorage();
    if (_box.read<String>(_playerIdKey) == null) {
      await updatePlayerId(UuidV4().generate().toString());
    } else {}
    return this;
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  static const _playerNameKey = 'playerName';
  static const _playerIdKey = 'playerId';
  static const _playedCountKey = 'playedCount';
  static const _winCountKey = 'winCount';
  static const _authTokenKey = 'auth_token';

  String get playerName => _box.read<String>(_playerNameKey).obs.value ?? '';
  String get playerId => _box.read<String>(_playerIdKey).obs.value!;
  String? get token => _box.read<String>(_authTokenKey);
  int get playedCount => _box.read<int>(_playedCountKey).obs.value ?? 0;
  int get winCount => _box.read<int>(_winCountKey).obs.value ?? 0;

  Future<void> updatePlayerName(String name) async {
    await _box.write(_playerNameKey, name);
  }

  Future<void> updatePlayerId(String id) async {
    await _box.write(_playerIdKey, id);
  }

  void setToken(String token) {
    _box.write(_authTokenKey, token);
  }

  void increasePlayedCount() {
    _box.write(_playedCountKey, playedCount + 1);
  }

  void increaseWinCount() {
    _box.write(_winCountKey, winCount + 1);
  }

  void clearToken() {
    _box.remove(_authTokenKey);
  }
}
