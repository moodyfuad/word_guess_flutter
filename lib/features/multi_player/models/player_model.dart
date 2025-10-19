// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlayerModel {
  final String id;
  final String name;
  final int playCount;
  final int winCount;

  PlayerModel({
    required this.id,
    required this.name,
    required this.playCount,
    required this.winCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'playCount': playCount,
      'wingCount': winCount,
    };
  }

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      id: map['id'] as String,
      name: map['name'] as String,
      playCount: map['playCount'] as int,
      winCount: map['winCount'] as int,
    );
  }
}
