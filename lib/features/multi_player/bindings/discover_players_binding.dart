import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/discover_players_controller.dart';

class DiscoverPlayersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DiscoverPlayersController());
  }
}
