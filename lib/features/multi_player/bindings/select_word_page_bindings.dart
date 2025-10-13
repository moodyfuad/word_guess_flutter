import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/select_word_page_controller.dart';

class XSelectWordPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(XSelectWordPageController());
  }
}
