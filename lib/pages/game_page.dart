import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<GameController>();
    final joinController = TextEditingController();
    final wordController = TextEditingController();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('وردل عربي'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Only wrap widgets that read observable
                Obx(() {
                  if (c.gameKey.isEmpty) {
                    return Column(
                      children: [
                        const Text('ابدأ لعبة جديدة أو انضم إلى لعبة'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: c.createGame,
                          child: const Text('إنشاء لعبة'),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: joinController,
                          decoration: const InputDecoration(
                            labelText: 'رمز اللعبة',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => c.joinGame(joinController.text),
                          child: const Text('انضم'),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        SelectableText(
                          'رمز اللعبة: ${c.gameKey}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: wordController,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: 'اكتب الكلمة السرية أو التخمين',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  c.submitSecret(wordController.text),
                              child: const Text('إرسال الكلمة السرية'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () =>
                                  c.submitGuess(wordController.text),
                              child: const Text(
                                'إرسال تخمين',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 30),
                        const Text(
                          'الحالة الحالية:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Obx(() => Text(c.gameState.toString())),
                        const Divider(height: 30),
                        const Text(
                          'التخمينات السابقة:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Obx(
                          () => Column(
                            children: c.guesses
                                .map((g) => Text(g.toString()))
                                .toList(),
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
