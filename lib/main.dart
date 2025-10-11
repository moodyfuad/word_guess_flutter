import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/pages/home_page.dart';
import 'package:word_guess/routes/pages.dart';
import 'package:word_guess/routes/routes.dart';
import 'controllers/game_controller.dart';

void main() {
  runApp(const WordleArabicApp());
}

class WordleArabicApp extends StatelessWidget {
  const WordleArabicApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GameController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      getPages: XPages.appPages,
      initialRoute: XRoutes.home,
      locale: Locale('ar', 'SA'),
      title: 'وردل عربي',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
        fontFamily: 'Cairo',
      ),
      home: const XHomePage(),
    );
  }
}
