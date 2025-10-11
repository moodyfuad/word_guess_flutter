// ignore_for_file: public_member_api_docs, sort_constructors_first
class XWordModel {
  String get value => letters.fold(
    '',
    (previousValue, element) => previousValue + element.letter,
  );
  int get length => letters.length;
  final List<XLetterModel> letters;

  XWordModel({required this.letters});

  factory XWordModel.generate(int length) {
    return XWordModel(
      letters: List.generate(
        length,
        (index) =>
            XLetterModel(letter: '', index: index, state: XLetterStates.empty),
      ),
    );
  }
  factory XWordModel.fromString(String word) {
    return XWordModel(
      letters: List.generate(
        word.length,
        (index) => XLetterModel(
          letter: word[index],
          index: index,
          state: XLetterStates.none,
        ),
      ),
    );
  }
}

class XLetterModel {
  final String letter;
  final int index;
  XLetterStates state;
  XLetterModel({
    required this.letter,
    required this.index,
    required this.state,
  });
}

enum XLetterStates { correctPosAndExist, exist, allWrong, none, empty }
