import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'letters': letters.map((x) => x.toMap()).toList(),
    };
  }

  factory XWordModel.fromMap(Map<String, dynamic> map) {
    return XWordModel(
      letters: List<XLetterModel>.from((map['letters'] as List<int>).map<XLetterModel>((x) => XLetterModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory XWordModel.fromJson(String source) => XWordModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class XLetterModel {
  final String letter;
  final int index;
  String state;
  XLetterModel({
    required this.letter,
    required this.index,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'letter': letter,
      'index': index,
      'state': state,
    };
  }

  factory XLetterModel.fromMap(Map<String, dynamic> map) {
    return XLetterModel(
      letter: map['letter'] as String,
      index: map['index'] as int,
      state:map['state'] as String
    );
  }

  String toJson() => json.encode(toMap());

  factory XLetterModel.fromJson(String source) =>
      XLetterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class XLetterStates {
  static const String correct = 'Correct';

  static const String present = 'present';
  static const String absent = 'absent';
  static const String none = 'none';
  static const String empty = 'empty';
}
