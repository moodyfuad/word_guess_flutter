import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RoomResponseDto {
  String key;
  int maxAttempts;
  int wordLength;
  String? creatorWord;
  String? jonerWord;
  Player creator;
  Player? joiner;
  String state;
  DateTime? createdAt;
  RoomResponseDto({
    required this.key,
    required this.maxAttempts,
    required this.wordLength,
    this.creatorWord,
    this.jonerWord,
    required this.creator,
    this.joiner,
    required this.state,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'maxAttempts': maxAttempts,
      'wordLength': wordLength,
      'creatorWord': creatorWord,
      'jonerWord': jonerWord,
      'creator': creator.toMap(),
      'joiner': joiner?.toMap(),
      'state': state,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory RoomResponseDto.fromMap(Map<String, dynamic> map) {
    return RoomResponseDto(
      key: map['key'] as String,
      maxAttempts: map['maxAttempts'] as int,
      wordLength: map['wordLength'] as int,
      creatorWord: map['creatorWord'] != null
          ? map['creatorWord'] as String
          : null,
      jonerWord: map['jonerWord'] != null ? map['jonerWord'] as String : null,
      creator: Player.fromMap(map['creator'] as Map<String, dynamic>),
      joiner: map['joiner'] != null
          ? Player.fromMap(map['joiner'] as Map<String, dynamic>)
          : null,
      state: map['state'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomResponseDto.fromJson(String source) =>
      RoomResponseDto.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Player {
  bool invitable;
  String? name;
  RoomResponseDto? room;
  String clientId;
  Player({
    required this.invitable,
    required this.name,
    this.room,
    required this.clientId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'invitable': invitable,
      'name': name,
      'room': room?.toMap(),
      'clientId': clientId,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      invitable: map['invitable'] as bool,
      name: map['name'] != null ? map['name'] as String : null,
      room: map['room'] != null
          ? RoomResponseDto.fromMap(map['room'] as Map<String, dynamic>)
          : null,
      clientId: map['clientId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) =>
      Player.fromMap(json.decode(source) as Map<String, dynamic>);
}
