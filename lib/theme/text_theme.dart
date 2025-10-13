import 'package:flutter/material.dart';
import 'package:word_guess/theme/app_colors.dart';

class XTextTheme {
  static String get fontFamily => 'Cairo';
  static Color get primaryLightTextColor => XAppColorsLight.primary_text;
  static Color get secondaryLightTextColor => XAppColorsLight.secondary_text;
  static Color get primaryDarkTextColor => XAppColorsDark.primary_text;
  static Color get secondaryDarkTextColor => XAppColorsDark.secondary_text;
  XTextTheme._();
  static TextTheme get light => TextTheme(
    displayLarge: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    displayMedium: TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    displaySmall: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    titleLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    titleSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 20,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 18,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    bodySmall: TextStyle(
      fontSize: 15,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    labelLarge: TextStyle(
      fontSize: 20,
      fontFamily: fontFamily,
      color: secondaryLightTextColor,
    ),
    labelMedium: TextStyle(
      fontSize: 18,
      fontFamily: fontFamily,
      color: secondaryLightTextColor,
    ),
    labelSmall: TextStyle(
      fontSize: 18,
      fontFamily: fontFamily,
      color: secondaryLightTextColor,
    ),
  );
  static TextTheme get dark => TextTheme(
    displayLarge: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    displayMedium: TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    displaySmall: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    titleLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    titleSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 20,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 18,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    bodySmall: TextStyle(
      fontSize: 15,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    labelLarge: TextStyle(
      fontSize: 20,
      fontFamily: fontFamily,
      color: secondaryDarkTextColor,
    ),
    labelMedium: TextStyle(
      fontSize: 18,
      fontFamily: fontFamily,
      color: secondaryDarkTextColor,
    ),
    labelSmall: TextStyle(
      fontSize: 18,
      fontFamily: fontFamily,
      color: secondaryLightTextColor,
    ),
  );
}
