// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreateGameRoomRequestDto {
  int wordLength;
  int maxAttempts;
  String creatorId;
  String creatorName;
  String? roomKey;
  CreateGameRoomRequestDto({
    required this.wordLength,
    required this.maxAttempts,
    required this.creatorId,
    required this.creatorName,
    this.roomKey,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'WordLength': wordLength,
      'MaxAttempts': maxAttempts,
      'CreatorId': creatorId,
      'CreatorName': creatorName,
      'RoomKey': '',
    };
  }

  factory CreateGameRoomRequestDto.fromMap(Map<String, dynamic> map) {
    return CreateGameRoomRequestDto(
      wordLength: map['wordLength'] as int,
      maxAttempts: map['maxAttempts'] as int,
      creatorId: map['creatorId'] as String,
      creatorName: map['creatorName'] as String,
      roomKey: map['roomKey'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateGameRoomRequestDto.fromJson(String source) =>
      CreateGameRoomRequestDto.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
