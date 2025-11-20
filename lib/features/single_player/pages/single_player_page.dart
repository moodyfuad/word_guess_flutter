import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/single_player/controllers/single_player_page_controller.dart';
import 'package:word_guess/features/single_player/models/word_model.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/util/helpers/helper.dart';
import 'package:word_guess/widgets/key_board_widget.dart';
import 'package:word_guess/widgets/word_widget.dart';

class XSinglePlayerPage extends StatelessWidget {
  final _controller = Get.find<XSinglePlayerPageController>();

  XSinglePlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL for Arabic layout
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: GestureDetector(
            onTap: _controller.addAttempt,
            child: Text(
              XHomePageStrings.appName.tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: Helper.showGameRoles,
              icon: Icon(Icons.info_outline),
            ),
          ],
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.size.height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: ListView(
                    controller: _controller.scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5),

                    children: [
                      Obx(() {
                        return Column(
                          children: _controller.board
                              .map((word) => _buildWordRow(word))
                              .toList(),
                        );
                      }),
                      // ..._controller.board.map((word) {
                      //   return _buildWordRow(word);
                      // }).toList(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: XKeyBoardWidget(
                    onKeyTap: _controller.onKeyTap,
                    onSummitTap: _controller.onSubmitPressed,
                    onBackspaceTap: _controller.onBackspacePressed,
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordRow(WordModel word) {
    return GetBuilder<XSinglePlayerPageController>(
      init: XSinglePlayerPageController(),
      initState: (_) {},
      builder: (_) {
        return XWordWidget(word: word);
      },
    );
  }
}
