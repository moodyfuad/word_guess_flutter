import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/bindings/discover_players_binding.dart';
import 'package:word_guess/features/multi_player/bindings/multiplayer_game_page_binding.dart';
import 'package:word_guess/features/multi_player/bindings/multiplayer_options_page_bindings.dart';
import 'package:word_guess/features/multi_player/bindings/select_word_page_bindings.dart';
import 'package:word_guess/features/multi_player/pages/discover_players_page.dart';
import 'package:word_guess/features/multi_player/pages/multiplayer_game_page.dart';
import 'package:word_guess/features/multi_player/pages/multiplayer_options_page.dart';
import 'package:word_guess/features/multi_player/pages/select_word_page.dart';
import 'package:word_guess/features/single_player/bindings/levels_page_bindings.dart';
import 'package:word_guess/features/single_player/bindings/single_player_page_binding.dart';
import 'package:word_guess/features/home/pages/home_page.dart';
import 'package:word_guess/features/single_player/pages/levels_page.dart';
import 'package:word_guess/features/single_player/pages/single_player_page.dart';
import 'package:word_guess/features/home/bindings/home_page_bindings.dart';
import 'package:word_guess/routes/routes.dart';

class XPages {
  XPages._();

  static List<GetPage> appPages = [
    GetPage(
      name: XRoutes.home,
      page: () => HomePage(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: XRoutes.singlePlayer,
      page: () => XSinglePlayerPage(),
      binding: XSinglePlayerPageBinding(),
    ),
    GetPage(
      name: XRoutes.levels,
      page: () => XLevelsPage(),
      binding: XLevelsPageBinding(),
    ),
    GetPage(
      name: XRoutes.multiplayerOptions,
      page: () => XMultiplayerOptionsPage(),
      binding: XMultiplayerOptionsPageBindings(),
    ),
    GetPage(
      name: XRoutes.selectWord,
      page: () => XSelectWordPage(),
      binding: XSelectWordPageBindings(),
    ),
    GetPage(
      name: XRoutes.multiplayerGame,
      page: () => MultiplayerGamePage(),
      binding: MultiplayerGamePageBinding(),
    ),
    GetPage(
      name: XRoutes.discoverPlayers,
      page: () => DiscoverPlayersPage(),
      binding: DiscoverPlayersBinding(),
    ),
  ];
}
