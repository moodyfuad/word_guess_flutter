import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/controllers/single_player_page_controller.dart';
import 'package:word_guess/models/word_model.dart';
import 'package:word_guess/util/show_game_rules.dart';
import 'package:word_guess/widgets/key_board_widget.dart';

class XSinglePlayerPage extends StatelessWidget {
  final _controller = Get.find<XSinglePlayerPageController>();

  XSinglePlayerPage({super.key});

  Color? _getCellColor(XLetterStates state) {
    return switch (state) {
      XLetterStates.correctPosAndExist => Colors.green,
      XLetterStates.exist => Colors.amberAccent,
      XLetterStates.allWrong => Colors.blueGrey,
      XLetterStates.none => Colors.blue[100],
      XLetterStates.empty => Colors.white,
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
            onTap: _controller.addAttempt,
            child: const Text(
              'وِردل عربي',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: _controller.replay,
            icon: Icon(Icons.replay),
          ),
          actions: [
            IconButton(
              onPressed: showGameRules,
              icon: Icon(Icons.info_outline),
            ),
          ],
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.size.height),
            child: GetBuilder<XSinglePlayerPageController>(
              builder: (ctrl) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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

                        children: ctrl.board.map((word) {
                          return Row(
                            children: word.letters
                                .map(
                                  (letter) => Expanded(
                                    flex: 1,
                                    child: SlideTransition(
                                      position: AlwaysStoppedAnimation(
                                        Offset.zero,
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(4),
                                        padding: EdgeInsets.all(4),

                                        // height:
                                        //     Get.size.height *
                                        //     0.45 /
                                        //     _controller.attempts,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          color: _getCellColor(letter.state),
                                        ),
                                        child: Center(
                                          child: Text(
                                            letter.letter,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// A hidden TextField that triggers the native keyboard and passes input to controller
class HiddenKeyboardInput extends StatefulWidget {
  final void Function(String letter) onInput;
  const HiddenKeyboardInput({super.key, required this.onInput});

  @override
  State<HiddenKeyboardInput> createState() => _HiddenKeyboardInputState();
}

class _HiddenKeyboardInputState extends State<HiddenKeyboardInput> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text;

      if (text.isNotEmpty) {
        // Handle Arabic letter input
        final char = text.characters.last;
        if (RegExp(r'^[\u0621-\u064A]+$').hasMatch(char)) {
          widget.onInput(char);
        } else if (char == '\b') {
          widget.onInput('backspace');
        }
        // _controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0,
      width: 0,
      child: TextField(
        controller: _controller,
        focusNode: _focus,
        autofocus: true,
        showCursor: false,
        enableSuggestions: false,
        autocorrect: false,
        textDirection: TextDirection.rtl,
        decoration: const InputDecoration.collapsed(hintText: ''),
        keyboardType: TextInputType.text,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }
}
