import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SelectWordRequestDto {
  String roomKey;
  String id;
  String word;
  SelectWordRequestDto({
    required this.roomKey,
    required this.id,
    required this.word,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'roomKey': roomKey, 'id': id, 'word': word};
  }

  factory SelectWordRequestDto.fromMap(Map<String, dynamic> map) {
    return SelectWordRequestDto(
      roomKey: map['roomKey'] as String,
      id: map['id'] as String,
      word: map['word'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectWordRequestDto.fromJson(String source) =>
      SelectWordRequestDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
