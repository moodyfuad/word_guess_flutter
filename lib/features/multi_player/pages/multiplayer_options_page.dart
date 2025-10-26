import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/multiplayer_options_page_controller.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/util/helpers/helper.dart';
import 'package:word_guess/widgets/secondary_button.dart';

class XMultiplayerOptionsPage extends StatelessWidget {
  XMultiplayerOptionsPage({super.key});
  final _1ExpansionController = ExpansibleController();
  final _2ExpansionController = ExpansibleController();
  final _controller = Get.find<MultiplayerOptionsPageController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(XHomePageStrings.appName.tr),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GetBuilder<MultiplayerOptionsPageController>(
          initState: (_) {},
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildNavigationCard(),
                _buildCreateRoomCard(),
                _buildJoinToExistedRoomCard(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCreateRoomCard() {
    return Expansible(
      headerBuilder: (context, animation) {
        return SecondaryButton(
          'انشء غرفة',
          onPressed: () {
            _1ExpansionController.isExpanded
                ? _1ExpansionController.collapse()
                : _1ExpansionController.expand();

            _2ExpansionController.collapse();
          },
        );
      },

      bodyBuilder: (context, animation) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  alignment: AlignmentGeometry.topCenter,
                  child: Text(
                    'اصنع غرفة و شارك الرمز مع صديقك',
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                SizedBox(height: 20),
                if (_controller.key.isEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Helper.buildSelectNumberWidget(
                        start: 6,
                        end: 30,
                        (selected) => _controller.maxAttemptsController.text =
                            selected.toString(),
                        label: ' عدد لمحاولات',
                      ),
                      Helper.buildSelectNumberWidget(
                        start: 3,
                        end: 7,
                        (selected) => _controller.wordLengthController.text =
                            selected.toString(),
                        label: 'عدد حروف الكلمة',
                      ),
                    ],
                  ),
                Visibility(
                  visible: _controller.key.isNotEmpty,
                  child: SelectableText(
                    'الرمز : ${_controller.key.value}',
                    style: Get.textTheme.displaySmall,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_controller.key.isNotEmpty) ...[
                      ElevatedButton(
                        onPressed: _controller.enableEditRoom,
                        child: const Text('تعديل'),
                      ),
                      SizedBox(width: 20),
                    ],
                    SecondaryButton(
                      'إنشاء غرفة',
                      onPressed: _controller.createRoom,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },

      expansibleBuilder: (context, header, body, animation) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            header,
            FadeTransition(
              opacity: animation,
              alwaysIncludeSemantics: true,

              // sizeFactor: animation,
              // axisAlignment: -1.0,
              child: body,
            ),
          ],
        );
      },

      controller: _1ExpansionController,
    );
  }

  Widget _buildJoinToExistedRoomCard() {
    return Expansible(
      headerBuilder: (context, animation) {
        return SecondaryButton(
          'أنضم',
          onPressed: () {
            _1ExpansionController.collapse();
            _2ExpansionController.isExpanded
                ? _2ExpansionController.collapse()
                : _2ExpansionController.expand();
          },
        );
      },
      bodyBuilder: (context, animation) {
        return Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                FittedBox(
                  child: Text(
                    'انضم الى صديقك عبر الرمز المرسل لك',
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  textAlign: TextAlign.center,
                  controller: _controller.keyController,
                  style: Get.textTheme.displaySmall!,
                  decoration: InputDecoration(
                    label: Text(
                      textAlign: TextAlign.center,
                      'رمز اللعبة',
                      style: Get.textTheme.labelMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SecondaryButton('انضم', onPressed: _controller.joinRoom),
              ],
            ),
          ),
        );
      },
      expansibleBuilder: (context, header, body, animation) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            header,
            FadeTransition(
              opacity: animation,
              alwaysIncludeSemantics: true,

              // sizeFactor: animation,
              // axisAlignment: -1.0,
              child: body,
            ),
          ],
        );
      },
      controller: _2ExpansionController,
    );
  }

  Widget _buildNavigationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SecondaryButton(
              'اكتشف اللاعبين',
              onPressed: () {
                Get.toNamed(XRoutes.discoverPlayers);
              },
            ),
          ],
        ),
      ),
    );
  }
}
