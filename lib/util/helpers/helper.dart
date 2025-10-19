import 'package:flutter/material.dart';
import 'package:word_guess/util/helpers/get_letter_color_by_state.dart';
import 'package:word_guess/util/helpers/show_game_rules.dart';

class Helper {
  Helper._();

  static Color? getLetterColorByState(String state) =>
      getLetterColorByStateImp(state);

  static void showGameRoles() => showGameRulesImp();
}
