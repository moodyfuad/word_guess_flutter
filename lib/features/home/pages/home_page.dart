import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/home/controllers/home_page_controller.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/util/helpers/helper.dart';
import 'package:word_guess/widgets/secondary_button.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final _pageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مرحبا ${_pageController.playerName.value}',

          style: TextStyle(inherit: true),
        ),
        leadingWidth: 100,
        leading: IconButton(
          onPressed: () {
            _pageController.showProfileBottomSheet();
          },
          icon: Icon(Icons.person_outline_rounded),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          _pageController.isWaitingForConnection.value
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 20,
                                  ),
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : Switch(
                                  inactiveThumbColor: XAppColorsLight.border,
                                  activeThumbColor:
                                      XAppColorsLight.bg_primary_action,
                                  value: _pageController.playOnlineSwitch.value,
                                  onChanged: (val) => val
                                      ? _pageController.enableOnlinePlay()
                                      : _pageController.disableOnlinePlay(),
                                ),
                          SizedBox(width: 10),
                          FittedBox(
                            child: _pageController.isWaitingForConnection.value
                                ? Text(
                                    'جاري الاتصال...',
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                      color: XAppColorsLight.secondary_text,
                                    ),
                                  )
                                : _pageController.playOnlineSwitch.value
                                ? Text(XHomePageStrings.onlinePlayEnabled.tr)
                                : Text(XHomePageStrings.onlinePlayDisabled.tr),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: Get.width * 0.95,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 50,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SecondaryButton(
                      XHomePageStrings.singlePlay.tr,
                      icon: Icons.person,
                      onPressed: () => Get.toNamed(XRoutes.levels),
                    ),
                    Obx(
                      () => SecondaryButton(
                        enabled: _pageController.playOnlineSwitch.value,
                        XHomePageStrings.multiPlay.tr,
                        icon: Icons.people,
                        onPressed: () =>
                            Get.toNamed(XRoutes.multiplayerOptions),
                      ),
                    ),
                    SecondaryButton(
                      XHomePageStrings.gameRoles.tr,
                      icon: Icons.info_outline,
                      onPressed: Helper.showGameRoles,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
