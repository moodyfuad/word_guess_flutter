import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/v4.dart';

class StorageService extends GetxService {
  late final GetStorage _box;
  Future<StorageService> init() async {
    _box = GetStorage();
    if (playerId == null) {
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

  String? get playerName => _box.read<String>(_playerNameKey);
  String? get playerId => _box.read<String>(_playerIdKey);

  Future<void> updatePlayerName(String name) async {
    await _box.write(_playerNameKey, name);
  }

  Future<void> updatePlayerId(String id) async {
    await _box.write(_playerIdKey, id);
  }
}
