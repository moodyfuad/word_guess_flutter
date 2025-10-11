import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/util/show_game_rules.dart';

class XHomePage extends StatelessWidget {
  const XHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'خمن الكلمة',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _HomeButtonWidget(
              'لعب فردي',
              icon: Icons.person,
              onPress: () => Get.toNamed(XRoutes.levels),
            ),
            _HomeButtonWidget('لعب جماعي', icon: Icons.people, onPress: () {}),
            _HomeButtonWidget(
              'قواعد اللعبة',
              icon: Icons.info_outline,
              onPress: showGameRules,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeButtonWidget extends StatelessWidget {
  const _HomeButtonWidget(this.content, {this.icon, required this.onPress});
  final String content;
  final IconData? icon;
  final void Function() onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPress,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(content, style: TextStyle(fontSize: 30)),
            SizedBox(width: 5),
            Icon(icon, size: 30),
          ],
        ),
      ),
    );
  }
}
