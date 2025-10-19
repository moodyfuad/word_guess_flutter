import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/multiplayer_game_page_controller.dart';
import 'package:word_guess/features/single_player/models/letter_states.dart';
import 'package:word_guess/features/single_player/models/word_model.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/util/helpers/show_game_rules.dart';
import 'package:word_guess/util/helpers/helper.dart';
import 'package:word_guess/widgets/key_board_widget.dart';

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
    return Directionality(
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
                Text(
                  'اخر لعبة ل${_controller.opponentName}',
                  style: Get.textTheme.labelMedium,
                ),
                GetBuilder<MultiplayerGamePageController>(
                  builder: (_) {
                    return _buildWordRow(_controller.opponentGuessWord.value);
                  },
                ),
                Expanded(
                  flex: 2,
                  child: CarouselView.weighted(
                    // mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    controller: _controller.carouselController,
                    scrollDirection: Axis.vertical,

                    // itemExtent: 100,
                    onTap: _controller.carouselController.animateToItem,
                    padding: EdgeInsets.all(5),
                    flexWeights: [2, 3, 4, 4, 5, 4, 4, 3, 2],
                    shrinkExtent: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),

                    children: _controller.board.map((word) {
                      return _buildWordRow(word);
                    }).toList(),
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
    return GetBuilder<MultiplayerGamePageController>(
      initState: (_) {},
      builder: (_) {
        return Row(
          children: word.letters
              .map((letter) {
                return Expanded(
                  key: ValueKey(letter.letter),
                  child:
                      Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                              color: _getCellColor(letter.state),
                            ),
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  letter.letter,
                                  style: Get.textTheme.titleMedium,
                                ),
                              ),
                            ),
                          )
                          .animate(autoPlay: true)
                          .flip(
                            duration: Duration(milliseconds: 300),
                            begin: -1,
                            end: 0,
                            curve: Curves.easeOut,
                          ),
                );
              })
              .toList()
              .animate(
                interval: Duration(milliseconds: 300),
                autoPlay: true,
                effects: [FlipEffect()],
              )
              .flip(begin: 0.8, end: 0)
              .animate(),
        );
      },
    );
  }
}
