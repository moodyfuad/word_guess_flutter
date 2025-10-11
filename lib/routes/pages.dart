import 'package:get/get.dart';
import 'package:word_guess/bindings/single_player_page_binding.dart';
import 'package:word_guess/pages/home_page.dart';
import 'package:word_guess/pages/levels_page.dart';
import 'package:word_guess/pages/single_player_page.dart';
import 'package:word_guess/routes/routes.dart';

class XPages {
  XPages._();

  static List<GetPage> appPages = [
    GetPage(name: XRoutes.home, page: () => XHomePage()),
    GetPage(
      name: XRoutes.singlePlayer,
      page: () => XSinglePlayerPage(),
      binding: XSinglePlayerPageBinding(),
    ),GetPage(
      name: XRoutes.levels,
      page: () => XLevelsPage(),
      binding: XLevelsPageBinding(),
    ),
  ];
}
