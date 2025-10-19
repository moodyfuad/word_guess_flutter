// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:word_guess/features/multi_player/models/player_model.dart';

class GetOnlinePlayersResponseDto {
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final bool? hasNext;
  final bool? hasPrevious;
  final List<PlayerModel> players;

  GetOnlinePlayersResponseDto({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    this.hasNext,
    this.hasPrevious,
    required this.players,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'totalCount': totalCount,
      'hasNext': hasNext,
      'hasPrevious': hasPrevious,
      'players': players.map((x) => x.toMap()).toList(),
    };
  }

  factory GetOnlinePlayersResponseDto.fromMap(Map<String, dynamic> map) {
    return GetOnlinePlayersResponseDto(
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalCount: map['totalCount'] as int,
      hasNext: map['hasNext'] != null ? map['hasNext'] as bool : null,
      hasPrevious: map['hasPrevious'] != null
          ? map['hasPrevious'] as bool
          : null,
      players: List<PlayerModel>.from(
        (map['players'] as List).map<PlayerModel>(
          (x) => PlayerModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
