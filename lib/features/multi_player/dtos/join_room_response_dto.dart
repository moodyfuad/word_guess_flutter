
// ignore_for_file: public_member_api_docs, sort_constructors_first
class RoomDto {
  String key;
  String creatorId;
  String? joinerId;
  int maxAttempts;
  int wordLength;
  String? creatorWord;
  String? joinerWord;
  // Player creator;
  // Player? joiner;
  String state;
  DateTime? createdAt;
  RoomDto({
    required this.key,
    required this.maxAttempts,
    required this.wordLength,
    required this.creatorId,
    this.joinerId,
    this.creatorWord,
    this.joinerWord,
    // required this.creator,
    // this.joiner,
    required this.state,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'creatorId': creatorId,
      'joinerId': joinerId,
      'maxAttempts': maxAttempts,
      'wordLength': wordLength,
      'creatorWord': creatorWord,
      'joinerWord': joinerWord,
      'state': state,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  // factory RoomResponseDto.fromMap(Map<String, dynamic> map) {
  //   return RoomResponseDto(
  //     key: map['key'] as String,
  //     maxAttempts: map['maxAttempts'] as int,
  //     wordLength: map['wordLength'] as int,
  //     creatorWord: map['creatorWord'] != null
  //         ? map['creatorWord'] as String
  //         : null,
  //     joinerWord: map['jonerWord'] != null ? map['jonerWord'] as String : null,
  //     // creator: Player.fromMap(map['creator'] as Map<String, dynamic>),
  //     // joiner: map['joiner'] != null
  //         // ? Player.fromMap(map['joiner'] as Map<String, dynamic>)
  //         // : null,
  //     state: map['state'] as String,
  //     createdAt: map['createdAt'] != null
  //         ? DateTime.tryParse(map['createdAt'] as String)
  //         : null,
  //   );
  // }

  factory RoomDto.fromMap(Map<String, dynamic> map) {
    return RoomDto(
      key: map['key'] as String,
      creatorId: map['creatorId'] as String,
      joinerId: map['joinerId'] != null ? map['joinerId'] as String : null,
      maxAttempts: map['maxAttempts'] as int,
      wordLength: map['wordLength'] as int,
      creatorWord: map['creatorWord'] != null
          ? map['creatorWord'] as String
          : null,
      joinerWord: map['joinerWord'] != null
          ? map['joinerWord'] as String
          : null,
      state: map['state'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse('createdAt')
          : null,
    );
  }

  // class Player {
  //   bool invitable;
  //   String? name;
  //   // RoomResponseDto? room;
  //   String clientId;
  //   Player({
  //     required this.invitable,
  //     required this.name,
  //     // this.room,
  //     required this.clientId,
  //   });

  //   Map<String, dynamic> toMap() {
  //     return <String, dynamic>{
  //       'invitable': invitable,
  //       'name': name,
  //       // 'room': room?.toMap(),
  //       'clientId': clientId,
  //     };
  //   }

  //   factory Player.fromMap(Map<String, dynamic> map) {
  //     return Player(
  //       invitable: map['invitable'] as bool,
  //       name: map['name'] != null ? map['name'] as String : null,
  //       // room: map['room'] != null
  //       //     ? RoomResponseDto.fromMap(map['room'] as Map<String, dynamic>)
  //       //     : null,
  //       clientId: map['clientId'] as String,
  //     );
  //   }
}
