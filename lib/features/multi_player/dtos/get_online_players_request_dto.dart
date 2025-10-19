class GetOnlinePlayersRequestDto {
  final int pageNumber;
  final int pageSize;

  GetOnlinePlayersRequestDto({
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'pageNumber': pageNumber, 'pageSize': pageSize};
  }

  factory GetOnlinePlayersRequestDto.fromMap(Map<String, dynamic> map) {
    return GetOnlinePlayersRequestDto(
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
    );
  }
}
