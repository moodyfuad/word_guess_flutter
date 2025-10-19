import 'package:flutter/material.dart';
import 'package:word_guess/util/helpers/build_text_field_for_create_room.dart';
import 'package:word_guess/util/helpers/get_letter_color_by_state.dart';
import 'package:word_guess/util/helpers/get_random_word.dart';
import 'package:word_guess/util/helpers/show_game_rules.dart';
import 'package:word_guess/util/helpers/show_on_will_pop_dialog.dart';

class Helper {
  Helper._();

  static Color? getLetterColorByState(String state) =>
      getLetterColorByStateImp(state);

  static void showGameRoles() => showGameRulesImp();
  static String getRandomWord(int length) => getRandomWordImp(length);
  static Widget buildTextFieldForCreateRoom(
    TextEditingController controller,
    String lable,
    String helper, [
    int max = 6,
  ]) => buildTextFieldForCreateRoomImp(controller, lable, helper, max);

  static Future<bool> showOnWillPopDialog(
    String title,
    List<String> contentList, {
    Function(bool val)? onResult,
  }) async =>
      await showOnWillPopDialogImp(title, contentList, onResult: onResult);
}
