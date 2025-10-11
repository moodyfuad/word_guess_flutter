import 'package:get/get.dart';
import 'package:word_guess/controllers/single_player_page_controller.dart';

class XSinglePlayerPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    // Get.put(XSinglePlayerPageController());
  }
}
class XLevelsPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(XSinglePlayerPageController());
  }
}
