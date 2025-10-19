class SendInvitationResponseDto {
  final String toPlayerId;
  final String fromPlayerId;
  final String state;
  SendInvitationResponseDto({
    required this.toPlayerId,
    required this.fromPlayerId,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'toPlayerId': toPlayerId,
      'fromPlayerId': fromPlayerId,
      'state': state,
    };
  }

  factory SendInvitationResponseDto.fromMap(Map<String, dynamic> map) {
    return SendInvitationResponseDto(
      toPlayerId: map['toPlayerId'] as String,
      fromPlayerId: map['fromPlayerId'] as String,
      state: map['state'] as String,
    );
  }

}
