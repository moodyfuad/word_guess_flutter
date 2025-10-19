import 'package:flutter/material.dart';
import 'package:word_guess/theme/app_colors.dart';
class XElevatedButtonTheme {
  XElevatedButtonTheme._();
  static ElevatedButtonThemeData get light => ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),

      backgroundColor: WidgetStatePropertyAll(XAppColorsLight.bg_actions),
      textStyle: WidgetStatePropertyAll(ThemeData.light().textTheme.titleSmall),
      iconColor: WidgetStatePropertyAll(XAppColorsLight.primary_action),
      alignment: Alignment.center,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
          side: BorderSide(width: 1, color: XAppColorsLight.border),
        ),
      ),
    ),
  );
}
