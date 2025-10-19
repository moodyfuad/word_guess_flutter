import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/home/controllers/home_page_controller.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/util/helpers/helper.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
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
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                    Column(
                      children: [
                        _buildPlayerScore(
                          'عدد مرات اللعب',
                          _pageController.playedCount.value,
                        ),
                        _buildPlayerScore(
                          'عدد مرات الفوز',
                          _pageController.winCount.value,
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
                      onPress: Helper.showGameRoles,
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

  Widget _buildPlayerScore(String title, int playedCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Get.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                playedCount.toString(),
                style: Get.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
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
