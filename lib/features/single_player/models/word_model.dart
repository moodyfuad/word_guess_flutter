import 'package:word_guess/features/single_player/models/letter_model.dart';
import 'package:word_guess/features/single_player/models/letter_states.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class WordModel {
  WordModel({required this.letters});

  String get value => letters.fold(
    '',
    (previousValue, element) => previousValue + element.letter,
  );
  int get length => letters.length;
  final List<LetterModel> letters;

  factory WordModel.generate(int length) {
    return WordModel(
      letters: List.generate(
        length,
        (index) =>
            LetterModel(letter: '', index: index, state: XLetterStates.empty),
      ),
    );
  }
  factory WordModel.fromString(String word) {
    return WordModel(
      letters: List.generate(
        word.length,
        (index) => LetterModel(
          letter: word[index],
          index: index,
          state: XLetterStates.none,
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'letters': letters.map((x) => x.toMap()).toList()};
  }

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      letters: List<LetterModel>.from(
        (map['letters'] as List<int>).map<LetterModel>(
          (x) => LetterModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
