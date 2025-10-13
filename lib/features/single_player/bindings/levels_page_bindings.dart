import 'package:get/get.dart';
import 'package:word_guess/features/single_player/controllers/single_player_page_controller.dart';

class XLevelsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(XSinglePlayerPageController());
  }
}