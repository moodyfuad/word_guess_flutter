import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/multiplayer_options_page_controller.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/util/helpers/helper.dart';

class XMultiplayerOptionsPage extends StatelessWidget {
  XMultiplayerOptionsPage({super.key});
  final _controller = Get.find<MultiplayerOptionsPageController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(XHomePageStrings.appName.tr),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 50),
        child: Padding(
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
                  const SizedBox(height: 20),

                  Text('أو', style: Get.textTheme.displayMedium),
                  const SizedBox(height: 20),

                  _buildJoinToExistedRoomCard(),
                  SizedBox(height: 500),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCreateRoomCard() {
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
            if (_controller.key.isEmpty) ...[
              const SizedBox(height: 20),
              Helper.buildTextFieldForCreateRoom(
                _controller.maxAttemptsController,
                'اقصى عدد لمحاولات التخمين',
                'اقصى عدد مسموح 20',
              ),
              Helper.buildTextFieldForCreateRoom(
                _controller.wordLengthController,
                'عدد حروف الكلمة',
                'اقصى عدد مسموح 7',
              ),
            ],
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
                ElevatedButton(
                  onPressed: _controller.createRoom,
                  child: const Text('إنشاء غرفة'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  

  Widget _buildJoinToExistedRoomCard() {
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
            ElevatedButton(
              onPressed: _controller.joinRoom,
              child: const Text('انضم'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed(XRoutes.discoverPlayers);
              },
              child: Text('اكتشف اللاعبين'),
            ),
          ],
        ),
      ),
    );
  }
}
