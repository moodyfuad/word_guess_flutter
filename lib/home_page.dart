import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/home_page_controller.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/util/show_game_rules.dart';

class XHomePage extends StatelessWidget {
  XHomePage({super.key});
  final _pageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          XHomePageStrings.appName.tr,
          style: Get.textTheme.displayLarge,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Obx(
            () => Align(
              alignment: AlignmentGeometry.topRight,

              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'مرحبا ${_pageController.playerName}',
                          style: Get.textTheme.displayMedium,
                        ),
                        IconButton(
                          onPressed: _pageController.enablePlayerName,
                          icon: Icon(
                            Icons.settings,
                            size: 30,
                            color: XAppColorsLight.info,
                          ),
                        ),
                      ],
                    ),

                    Card(
                      child: Row(
                        children: [
                          Switch(
                            inactiveThumbColor: XAppColorsLight.border,
                            activeThumbColor: XAppColorsLight.primary_action,
                            value: _pageController.playOnlineSwitch.value,
                            onChanged: (val) => val
                                ? _pageController.enableOnlinePlay()
                                : _pageController.disableOnlinePlay(),
                          ),
                          FittedBox(
                            child: _pageController.playOnlineSwitch.value
                                ? Text(XHomePageStrings.onlinePlayEnabled.tr)
                                : Text(XHomePageStrings.onlinePlayDisabled.tr),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _pageController.nameFieldVisible.value,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            style: Get.textTheme.bodyMedium,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                _pageController.enableOnlinePlay(),
                            controller: _pageController.nameController,
                            decoration: InputDecoration(
                              label: Text(
                                XHomePageStrings.name.tr,
                                style: Get.textTheme.bodySmall,
                              ),
                              helper: Text(
                                XHomePageStrings.nameNecessaryMsg.tr,
                                style: Get.textTheme.bodySmall!.copyWith(
                                  color: Colors.redAccent[400],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.center,
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
                    _HomeButtonWidget(
                      XHomePageStrings.singlePlay.tr,
                      icon: Icons.person,
                      onPress: () => Get.toNamed(XRoutes.levels),
                    ),
                    Obx(
                      () => _HomeButtonWidget(
                        enabled: _pageController.playOnlineSwitch.value,
                        XHomePageStrings.multiPlay.tr,
                        icon: Icons.people,
                        onPress: () => Get.toNamed(XRoutes.multiplayerOptions),
                      ),
                    ),
                    _HomeButtonWidget(
                      XHomePageStrings.gameRoles.tr,
                      icon: Icons.info_outline,
                      onPress: showGameRules,
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

class _HomeButtonWidget extends StatelessWidget {
  const _HomeButtonWidget(
    this.content, {
    this.icon,
    required this.onPress,
    this.enabled = true,
  });
  final String content;
  final bool enabled;
  final IconData? icon;
  final void Function() onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: XAppColorsLight.bg,
        ),
        onPressed: enabled ? onPress : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            SizedBox(width: 5),
            Text(content, style: Get.textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}
