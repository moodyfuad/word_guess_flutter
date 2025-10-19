class LetterModel {
  final String letter;
  final int index;
  String state;
  LetterModel({required this.letter, required this.index, required this.state});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'letter': letter, 'index': index, 'state': state};
  }

  factory LetterModel.fromMap(Map<String, dynamic> map) {
    return LetterModel(
      letter: map['letter'] as String,
      index: map['index'] as int,
      state: map['state'] as String,
    );
  }
}
