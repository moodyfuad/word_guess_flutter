import 'package:flutter/material.dart';
import 'package:word_guess/theme/app_colors.dart';

class XCardTheme {
  XCardTheme._();
  static CardThemeData get light => CardThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(8),
      side: BorderSide(
        color: XAppColorsLight.border,
        width: 1,
        strokeAlign: BorderSide.strokeAlignCenter,
        style: BorderStyle.solid,
      ),
    ),
    color: XAppColorsLight.bg_element_container,
    elevation: 4,
    surfaceTintColor: XAppColorsLight.highlight,
  );
}
