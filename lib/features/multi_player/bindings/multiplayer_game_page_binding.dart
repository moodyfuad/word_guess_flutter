import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/multiplayer_game_page_controller.dart';

class MultiplayerGamePageBinding implements Bindings {
@override
void dependencies() {
  Get.put(MultiplayerGamePageController());
  }
}