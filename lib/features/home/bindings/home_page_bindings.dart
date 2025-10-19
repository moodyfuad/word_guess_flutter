import 'package:get/get.dart';
import 'package:word_guess/features/home/controllers/home_page_controller.dart';
import 'package:word_guess/services/hub_services.dart';
import 'package:word_guess/services/network_services.dart';
import 'package:word_guess/services/storage_service.dart';

class HomePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomePageController>(
      () => HomePageController(
        hub: Get.find<HubServices>(),
        networkService: Get.find<NetworkService>(),
        storageService: Get.find<StorageService>(),
      ),
    );
  }
}
