// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/discover_players_controller.dart';

class DiscoverPlayersPage extends StatelessWidget {
  DiscoverPlayersPage({super.key});
  final _controller = Get.find<DiscoverPlayersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('اكتشف اللاعبين')),
      body: Obx(() {
        final players = _controller.players;
        return ListView.builder(
          itemCount: _controller.players.length,
          shrinkWrap: true,

          itemBuilder: (context, index) {
            return _UserCard(
              name: players[index].name,
              description: 'لعب اكثر من ${players[index].playCount} مرة',
              onButtonPress: () {
                _controller.sendInvitation(players[index].id);
              },
            );
          },
        );
      }),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    Key? key,
    this.avatar,
    required this.name,
    required this.description,
    this.onButtonPress,
  }) : super(key: key);
  final Widget? avatar;
  final String name;
  final String description;
  final void Function()? onButtonPress;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.amber,
              child: avatar ?? Icon(Icons.person, size: 35),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Get.textTheme.titleSmall),
                Text(description, style: Get.textTheme.labelSmall),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: onButtonPress,
              child: Text('ارسال\nدعوة'),
            ),
          ],
        ),
      ),
    );
  }
}
