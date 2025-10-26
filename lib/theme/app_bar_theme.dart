import 'package:flutter/material.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/theme/text_theme.dart';

class XAppBarTheme {
  static AppBarTheme get light => AppBarTheme(
    backgroundColor: XAppColorsLight.bg_element_container,
    iconTheme: IconThemeData(color: XAppColorsLight.primary_text),
    titleTextStyle: XTextTheme.light.headlineMedium?.copyWith(
      color: XAppColorsLight.primary_text,
      fontSize: 25,
      fontFamily: XTextTheme.fontFamily,
      fontWeight: FontWeight.bold,
      
    ),
    elevation: 3,
    centerTitle: true,
    actionsPadding: EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
    ),
  );
}
