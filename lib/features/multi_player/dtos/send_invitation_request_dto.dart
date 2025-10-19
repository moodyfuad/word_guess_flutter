class SendInvitationRequestDto {
  final String toPlayerId;
  final String fromPlayerId;

  SendInvitationRequestDto({required this.toPlayerId, required this.fromPlayerId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'toPlayerId': toPlayerId,
      'fromPlayerId': fromPlayerId,
    };
  }

  factory SendInvitationRequestDto.fromMap(Map<String, dynamic> map) {
    return SendInvitationRequestDto(
      toPlayerId: map['toPlayerId'] as String,
      fromPlayerId: map['fromPlayerId'] as String,
    );
  }

}
