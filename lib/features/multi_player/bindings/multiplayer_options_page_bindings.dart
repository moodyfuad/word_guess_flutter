import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/multiplayer_options_page_controller.dart';

class XMultiplayerOptionsPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MultiplayerOptionsPageController());
  }
}
