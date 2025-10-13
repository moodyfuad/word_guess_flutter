import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SelectWordRequestDto {
String roomkey;
String id;
String word;
  SelectWordRequestDto({
    required this.roomkey,
    required this.id,
    required this.word,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomkey': roomkey,
      'id': id,
      'word': word,
    };
  }

  factory SelectWordRequestDto.fromMap(Map<String, dynamic> map) {
    return SelectWordRequestDto(
      roomkey: map['roomkey'] as String,
      id: map['id'] as String,
      word: map['word'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectWordRequestDto.fromJson(String source) => SelectWordRequestDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
