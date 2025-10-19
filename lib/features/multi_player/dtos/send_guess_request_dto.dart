class SendGuessRequestDto {
    final String roomKey;
    final String senderId;
    final String word;
  SendGuessRequestDto({
    required this.roomKey,
    required this.senderId,
    required this.word,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomKey': roomKey,
      'senderId': senderId,
      'word': word,
    };
  }

  factory SendGuessRequestDto.fromMap(Map<String, dynamic> map) {
    return SendGuessRequestDto(
      roomKey: map['roomKey'] as String,
      senderId: map['senderId'] as String,
      word: map['word'] as String,
    );
  }

  
  }