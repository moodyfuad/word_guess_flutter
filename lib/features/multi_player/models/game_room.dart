//todo Delete
// import 'dart:convert';

// import 'package:word_guess/features/multi_player/models/game_room_stats.dart';
// import 'package:word_guess/features/single_player/models/word_model.dart';

// class GameRoom {
//   String? Id;
//   String? Key;

//   int WordLength;
//   int MaxAttempts;

//   WordModel? creatorWord;
//   WordModel? JonerWord;
//   String CreatorId;
//   String? JoinerId;
//   String CreatorName;
//   String? JoinerName;
//   String State;
//   DateTime CreatedAt = DateTime.now();
//   GameRoom({
//     required this.CreatorId,
//     required this.CreatorName,
//     this.MaxAttempts = 8,
//     this.WordLength = 5,
//     this.State =  GameRoomStats.WaitingForPlayers,
//     this.Id,
//     this.Key,
//     this.creatorWord,
//     this.JonerWord,
//     this.JoinerId,
//     this.JoinerName,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'Id': Id,
//       'Key': Key,
//       'WordLength': WordLength,
//       'MaxAttempts': MaxAttempts,
//       'creatorWord': creatorWord?.toMap(),
//       'JonerWord': JonerWord?.toMap(),
//       'CreatorId': CreatorId,
//       'JoinerId': JoinerId,
//       'CreatorName': CreatorName,
//       'JoinerName': JoinerName,
//       'State': State,
//       'CreatedAt': CreatedAt.millisecondsSinceEpoch,
//     };
//   }

//   factory GameRoom.fromMap(Map<String, dynamic> map) {
//     return GameRoom(
//       Id: map['Id'] as String,
//       Key: map['Key'] as String,
//       WordLength: map['WordLength'] as int,
//       MaxAttempts: map['MaxAttempts'] as int,
//       creatorWord: map['creatorWord'] != null ? WordModel.fromMap(map['creatorWord'] as Map<String,dynamic>) : null,
//       JonerWord: map['JonerWord'] != null ? WordModel.fromMap(map['JonerWord'] as Map<String,dynamic>) : null,
//       CreatorId: map['CreatorId'] as String,
//       JoinerId: map['JoinerId'] != null ? map['JoinerId'] as String : null,
//       CreatorName: map['CreatorName'] as String,
//       JoinerName: map['JoinerName'] != null ? map['JoinerName'] as String : null,
//       State: map['State'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory GameRoom.fromJson(String source) => GameRoom.fromMap(json.decode(source) as Map<String, dynamic>);
// }
