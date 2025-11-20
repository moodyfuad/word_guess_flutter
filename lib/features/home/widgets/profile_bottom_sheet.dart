import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/home/controllers/home_page_controller.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/widgets/secondary_button.dart';

class ProfileBottomSheet extends StatelessWidget {
  const ProfileBottomSheet({super.key, required this.homeController});
  final HomePageController homeController;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: Get.height * .7,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: XAppColorsLight.bg_element_container,
            child: Icon(
              Icons.person,
              size: 50,
              color: XAppColorsLight.primary_text,
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    homeController.playerName.value,
                    style: Get.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SecondaryButton(
                    'تعديل',
                    onPressed: () {
                      Get.back();
                      homeController.enablePlayerName();
                    },
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: homeController.nameFieldVisible.value,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      style: Get.textTheme.bodyMedium,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        homeController.enableOnlinePlay();
                        Get.back(closeOverlays: true);
                        homeController.update();
                      },
                      controller: homeController.nameController,
                      decoration: InputDecoration(
                        label: Text(
                          XHomePageStrings.name.tr,
                          style: Get.textTheme.bodySmall,
                        ),
                        helper: homeController.playerName.value.isNotEmpty
                            ? null
                            : Text(
                                XHomePageStrings.nameNecessaryMsg.tr,
                                style: Get.textTheme.bodySmall!.copyWith(
                                  color: Colors.redAccent[400],
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SecondaryButton(
                      'تأكيد',
                      onPressed: () {
                        homeController.enableOnlinePlay();
                        Get.back(closeOverlays: true);
                        homeController.nameFieldVisible.value = false;
                        homeController.update();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 15,
                    ),
                    child: Text(
                      'لعبت ${homeController.playedCount} مرة',
                      style: Get.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 15,
                    ),
                    child: Text(
                      'فزت ${homeController.winCount} مرة',
                      style: Get.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
