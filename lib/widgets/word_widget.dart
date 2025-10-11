import 'package:flutter/material.dart';
import 'package:word_guess/models/word_model.dart';

class XWordWidget extends StatefulWidget {
  const XWordWidget({super.key, required this.word});
  final XWordModel word;
  @override
  State<XWordWidget> createState() => _XWordWidgetState();
}

class _XWordWidgetState extends State<XWordWidget> {

  void updateLetter(int index, XLetterModel letter) {
    setState(() {
      widget.word.letters[index] = letter;
    });
  }

  Color? _getCellColor(XLetterStates state) {
    return switch (state) {
      XLetterStates.correctPosAndExist => Colors.green,
      XLetterStates.exist => Colors.amberAccent,
      XLetterStates.allWrong => Colors.blueGrey,
      XLetterStates.none => Colors.blue[100],
      XLetterStates.empty => Colors.white,
      _ => Colors.white,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.word.letters
          .map(
            (letter) => Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(4),
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
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
          )
          .toList(),
    );
  }
}
