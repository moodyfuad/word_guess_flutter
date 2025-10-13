import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:word_guess/features/single_player/controllers/single_player_page_controller.dart';
import 'package:word_guess/features/single_player/models/levels.dart';
import 'package:word_guess/routes/routes.dart';

class XLevelsPage extends StatelessWidget {
  XLevelsPage({super.key});
  final textController = TextEditingController();
  final attemptsController = TextEditingController();
  final controller = Get.find<XSinglePlayerPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تحديد المستوى'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('حدد المستوى', style: TextStyle(fontSize: 30)),
                Spacer(),
                DropdownMenu<XLevels>(
                  enabled: true,
                  onSelected: (value) {
                    if (value != null) {
                      controller.startGame(level: value, attempts: 6);
                      Get.toNamed(XRoutes.singlePlayer);
                    }
                  },
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: XLevels.easy, label: 'سهل'),
                    DropdownMenuEntry(value: XLevels.medium, label: 'متوسط'),
                    DropdownMenuEntry(value: XLevels.hard, label: 'صعب'),
                    DropdownMenuEntry(value: XLevels.extreme, label: 'صعب جدا'),
                    DropdownMenuEntry(
                      value: XLevels.legendary,
                      label: 'اسطوري',
                      enabled: false,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('أو', style: TextStyle(fontSize: 30)),
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        enabled: true,
                        textAlign: TextAlign.center,
                        controller: textController,
                        decoration: InputDecoration(hint: Text('اكتب الكلمة')),
                        onFieldSubmitted: (value) {
                          final attempts = int.tryParse(
                            attemptsController.text,
                          );
                          if (value.length > 2) {
                            controller.startGame(
                              word: value,
                              attempts: attempts ?? 6,
                            );
                            Get.toNamed(XRoutes.singlePlayer);
                          }
                          controller.startGame(word: value, attempts: 6);
                          Get.toNamed(XRoutes.singlePlayer);
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(),
                        textAlign: TextAlign.center,
                        controller: attemptsController,
                        decoration: InputDecoration(
                          hint: Text('عدد المحاولات'),
                        ),
                        onFieldSubmitted: (value) {
                          final attempts = int.tryParse(value);
                          if (textController.text.length > 2 &&
                              attempts != null) {
                            controller.startGame(
                              word: textController.text,
                              attempts: attempts,
                            );
                            Get.toNamed(XRoutes.singlePlayer);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final attempts = int.tryParse(attemptsController.text);

                    String word = textController.text;

                    if (word.length > 2) {
                      controller.startGame(
                        word: textController.text,
                        attempts: attempts ?? 6,
                      );
                      Get.toNamed(XRoutes.singlePlayer);
                    }
                  },
                  child: Text('تاكيد', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
