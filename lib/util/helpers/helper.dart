import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/util/helpers/build_text_field_for_create_room.dart';
import 'package:word_guess/util/helpers/get_letter_color_by_state.dart';
import 'package:word_guess/util/helpers/get_random_word.dart';
import 'package:word_guess/util/helpers/show_dialog.dart';
import 'package:word_guess/util/helpers/show_game_rules.dart';
import 'package:word_guess/util/helpers/show_on_will_pop_dialog.dart';

class Helper {
  Helper._();

  static Color? getLetterColorByState(String state) =>
      getLetterColorByStateImp(state);

  static void showGameRoles() => showGameRulesImp();
  static String getRandomWord(int length) => getRandomWordImp(length);
  static Widget buildSelectNumberWidget(
    void Function(int selected) onNumberSelected, {
    required int start,
    required int end,
    String? label,
    int defaultNumber = 6,
  }) => buildSelectNumberWidgetImp(
    onNumberSelected,
    start: start,
    end: end,
    label: label,
    defaultNumber: defaultNumber,
  );

  static Future<bool> showOnWillPopDialog(
    String title,
    List<String> contentList, {
    Function(bool val)? onResult,
  }) async =>
      await showOnWillPopDialogImp(title, contentList, onResult: onResult);

  static showDialog(
    String title, {
    required List<Widget> children,
    required String confirmText,
    void Function()? onConfirm,
    String? cancelText,
    void Function()? onCancel,
  }) async => await showDialogImp(
    title,
    children: children,
    confirmText: confirmText,
    onConfirm: onConfirm,
    cancelText: cancelText,
    onCancel: onCancel,
  );

  static SnackbarController showSnackbar(
    String title,
    String message,
    SnackbarTypes type,
  ) {
    Color bg = switch (type) {
      SnackbarTypes.success => XAppColorsLight.success,
      SnackbarTypes.fail => XAppColorsLight.danger,
      SnackbarTypes.info => XAppColorsLight.bg,
    };
    return Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: bg.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

enum SnackbarTypes { success, fail, info }
