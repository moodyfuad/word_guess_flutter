import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/dtos/join_room_response_dto.dart';
import 'package:word_guess/features/multi_player/models/player_model.dart';

class RoomController extends GetxController {
  RoomDto? room;
  PlayerModel? opponent;
  PlayerModel? me;

  PlayerModel get creator => me?.id == room?.creatorId ? me! : opponent!;
  PlayerModel get joiner => me?.id == room?.joinerId ? me! : opponent!;
}
