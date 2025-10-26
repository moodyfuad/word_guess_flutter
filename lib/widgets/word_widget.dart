import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/single_player/models/letter_model.dart';
import 'package:word_guess/features/single_player/models/letter_states.dart';
import 'package:word_guess/features/single_player/models/word_model.dart';
import 'package:word_guess/theme/app_colors.dart';

class XWordWidget extends StatefulWidget {
  const XWordWidget({super.key, required this.word});
  final WordModel word;
  @override
  State<XWordWidget> createState() => _XWordWidgetState();
}

class _XWordWidgetState extends State<XWordWidget> {
  void updateLetter(int index, LetterModel letter) {
    setState(() {
      widget.word.letters[index] = letter;
    });
  }

  Color? _getCellColor(String state) {
    return switch (state) {
      XLetterStates.correct => Colors.green[500],
      XLetterStates.present => Colors.amber[400],
      XLetterStates.absent => Colors.grey[700],
      XLetterStates.none => Colors.blue[100],
      XLetterStates.empty => Colors.white,
      _ => Colors.black,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.word.letters
          .map(
            (letter) => Expanded(
              key: ValueKey(letter.letter),

              flex: 1,
              child:
                  Container(
                        margin: const EdgeInsets.all(4),
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: XAppColorsLight.border,
                            width: 3,
                            style: BorderStyle.solid,
                            strokeAlign: BlurEffect.neutralBlur,
                          ),
                          color: _getCellColor(letter.state),
                        ),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              letter.letter,
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: XAppColorsLight.on_primary_action,
                              ),
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
            ),
          )
          .toList()
          .animate(
            interval: Duration(milliseconds: 300),
            autoPlay: true,
            effects: [
              FlipEffect(begin: 0, end: 0, delay: Duration(milliseconds: 300)),
            ],
          ),
    );
  }
}
