import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class JoinGameRequestDto {
  String GameKey;
  String JoinerId;
  String? JoinerName;
  JoinGameRequestDto({
    required this.GameKey,
    required this.JoinerId,
    this.JoinerName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'GameKey': GameKey,
      'JoinerId': JoinerId,
      'JoinerName': JoinerName,
    };
  }

  factory JoinGameRequestDto.fromMap(Map<String, dynamic> map) {
    return JoinGameRequestDto(
      GameKey: map['GameKey'] as String,
      JoinerId: map['JoinerId'] as String,
      JoinerName: map['JoinerName'] != null ? map['JoinerName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory JoinGameRequestDto.fromJson(String source) => JoinGameRequestDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
