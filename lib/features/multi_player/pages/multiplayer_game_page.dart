import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/multiplayer_game_page_controller.dart';
import 'package:word_guess/features/single_player/models/letter_states.dart';
import 'package:word_guess/features/single_player/models/word_model.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/util/helpers/helper.dart';
import 'package:word_guess/widgets/key_board_widget.dart';
import 'package:word_guess/widgets/word_widget.dart';

class MultiplayerGamePage extends StatelessWidget {
  MultiplayerGamePage({super.key});
  final _controller = Get.find<MultiplayerGamePageController>();
  Color? _getCellColor(String state) {
    return switch (state) {
      XLetterStates.correct => Colors.green,
      XLetterStates.present => Colors.amberAccent,
      XLetterStates.absent => Colors.blueGrey,
      XLetterStates.none => Colors.blue[100],
      XLetterStates.empty => Colors.white,
      _ => Colors.black,
    };
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _controller.handelPop();
      },
      child: Directionality(
        textDirection: TextDirection.rtl, // RTL for Arabic layout
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: GestureDetector(
              // onTap: _controller.addAttempt,
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
                  GetBuilder<MultiplayerGamePageController>(
                    builder: (_) {
                      return Card(
                        child: Column(
                          children: [
                            Text(
                              'اخر محاولة ل${_controller.opponentName}',
                              style: Get.textTheme.titleLarge,
                            ),
                            _buildWordRow(_controller.opponentGuessWord.value),
                          ],
                        ),
                      );
                    },
                  ),
                  Expanded(
                    flex: 3,
                    child: ListView(
                      controller: _controller.scrollController,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(5),

                      children: [
                        ..._controller.board.map((word) {
                          return _buildWordRow(word);
                        }).toList(),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),

                  XKeyBoardWidget(
                    onKeyTap: _controller.onKeyTap,
                    onSummitTap: _controller.onSubmitPressed,
                    onBackspaceTap: _controller.onBackspacePressed,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordRow(WordModel word) {
    return GetBuilder<MultiplayerGamePageController>(
      initState: (_) {},
      builder: (_) {
        return XWordWidget(word: word);
      },
    );
  }
}
