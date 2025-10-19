// ignore_for_file: public_member_api_docs, sort_constructors_first
class SendInvitationRequestDto {
  final String toPlayerId;
  final String fromPlayerId;
  final int wordLength;

  SendInvitationRequestDto({
    required this.toPlayerId,
    required this.fromPlayerId,
    this.wordLength = 5 ,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'toPlayerId': toPlayerId,
      'fromPlayerId': fromPlayerId,
      'wordLength': wordLength,
    };
  }

  factory SendInvitationRequestDto.fromMap(Map<String, dynamic> map) {
    return SendInvitationRequestDto(
      toPlayerId: map['toPlayerId'] as String,
      fromPlayerId: map['fromPlayerId'] as String,
      wordLength: map['wordLength'] as int,
    );
  }

}
