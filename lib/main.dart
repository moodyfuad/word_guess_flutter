import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:word_guess/features/multi_player/controllers/room_controller.dart';
import 'package:word_guess/services/api_service.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/localization/translation.dart';
import 'package:word_guess/routes/pages.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/services/hub_services.dart';
import 'package:word_guess/services/network_services.dart';
import 'package:word_guess/theme/app_theme.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() async => await NetworkService().init());
  await GetStorage.init();
  Get.put(StorageService(), permanent: true);
  final storage = Get.find<StorageService>();
  Get.put(HubServices(storage.playerId, storage.playerName));
  Get.put(ApiService(), permanent: true);
  Get.put(RoomController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // title: 'Word Guess',
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.light, // اجبر الثيم على وضع واحد مؤقتًا
      // //
      debugShowCheckedModeBanner: false,
      getPages: XPages.appPages,
      initialRoute: XRoutes.home,
      translations: XTranslation(),
      locale: Locale('ar', 'SA'),
      title: XHomePageStrings.appName,
      theme: XAppTheme.light,
      darkTheme: XAppTheme.dark,
      themeMode: ThemeMode.light,
      enableLog: true,
    );
  }
}
