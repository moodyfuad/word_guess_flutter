import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/theme/app_colors.dart';

class XInputDecorationTheme {
  XInputDecorationTheme._();

  static InputDecorationThemeData get light => InputDecorationThemeData(
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: XAppColorsLight.danger,
        strokeAlign: BorderSide.strokeAlignCenter,
        width: 1,
      ),
    ),
    errorStyle: ThemeData.light().textTheme.labelMedium!.copyWith(
      color: XAppColorsLight.danger,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    labelStyle: Get.textTheme.labelSmall,
    helperStyle: Get.textTheme.labelSmall,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    filled: true,
    visualDensity: VisualDensity.comfortable,
    fillColor: XAppColorsLight.bg_actions,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: XAppColorsLight.bg_primary_action,
        strokeAlign: BorderSide.strokeAlignOutside,
        width: 2,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: XAppColorsLight.border,
        strokeAlign: BorderSide.strokeAlignCenter,
        width: 1,
      ),
    ),
    activeIndicatorBorder: BorderSide(
      color: XAppColorsLight.secondary_text,

      strokeAlign: BorderSide.strokeAlignCenter,
      width: 40,
      style: BorderStyle.solid,
    ),
    alignLabelWithHint: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: XAppColorsLight.border,
        strokeAlign: BorderSide.strokeAlignCenter,
        width: 1,
      ),
    ),

    disabledBorder: null,
  );
}
