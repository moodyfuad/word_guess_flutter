import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:word_guess/theme/app_colors.dart';

class XTextTheme {
  static String get fontFamily => 'Cairo';
  static Color get primaryLightTextColor => XAppColorsLight.primary_text;
  static Color get secondaryLightTextColor => XAppColorsLight.secondary_text;
  static Color get primaryDarkTextColor => XAppColorsDark.primary_text;
  static Color get secondaryDarkTextColor => XAppColorsDark.secondary_text;
  XTextTheme._();
  static TextTheme get light => ThemeData.light().textTheme.copyWith(
    displayLarge: TextStyle(
      inherit: true,
      fontSize: 40,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    displayMedium: TextStyle(
      inherit: true,
      fontSize: 35,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    displaySmall: TextStyle(
      inherit: true,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    titleLarge: TextStyle(
      inherit: true,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    titleMedium: TextStyle(
      inherit: true,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    titleSmall: TextStyle(
      inherit: true,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    bodyLarge: TextStyle(
      inherit: true,
      fontSize: 20,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    bodyMedium: TextStyle(
      inherit: true,
      fontSize: 18,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    bodySmall: TextStyle(
      inherit: true,
      fontSize: 15,
      fontFamily: fontFamily,
      color: primaryLightTextColor,
    ),
    labelLarge: TextStyle(
      inherit: true,
      fontSize: 20,
      fontFamily: fontFamily,
      color: secondaryLightTextColor,
    ),
    labelMedium: TextStyle(
      inherit: true,
      fontSize: 18,
      fontFamily: fontFamily,
      color: secondaryLightTextColor,
    ),
    labelSmall: TextStyle(
      inherit: true,
      fontSize: 18,
      fontFamily: fontFamily,
      color: secondaryLightTextColor,
    ),
  );
  static TextTheme get dark => ThemeData.dark().textTheme.copyWith(
    displayLarge: TextStyle(
      inherit: true,
      fontSize: 40,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    displayMedium: TextStyle(
      inherit: true,
      fontSize: 35,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    displaySmall: TextStyle(
      inherit: true,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    titleLarge: TextStyle(
      inherit: true,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    titleMedium: TextStyle(
      inherit: true,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    titleSmall: TextStyle(
      inherit: true,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    bodyLarge: TextStyle(
      inherit: true,
      fontSize: 20,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    bodyMedium: TextStyle(
      inherit: true,
      fontSize: 18,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    bodySmall: TextStyle(
      inherit: true,
      fontSize: 15,
      fontFamily: fontFamily,
      color: primaryDarkTextColor,
    ),
    labelLarge: TextStyle(
      inherit: true,
      fontSize: 20,
      fontFamily: fontFamily,
      color: secondaryDarkTextColor,
    ),
    labelMedium: TextStyle(
      inherit: true,
      fontSize: 18,
      fontFamily: fontFamily,
      color: secondaryDarkTextColor,
    ),
    labelSmall: TextStyle(
      inherit: true,
      fontSize: 18,
      fontFamily: fontFamily,
      color: secondaryLightTextColor,
    ),
  );
}
