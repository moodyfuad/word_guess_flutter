import 'package:flutter/material.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/theme/card_theme.dart';
import 'package:word_guess/theme/drop_down_menu_theme.dart';
import 'package:word_guess/theme/elevated_button_theme.dart';
import 'package:word_guess/theme/input_decoration_theme.dart';
import 'package:word_guess/theme/switch_theme.dart';
import 'package:word_guess/theme/text_theme.dart';

class XAppTheme {
  XAppTheme._();
  static ThemeData get light => ThemeData(
    scaffoldBackgroundColor: XAppColorsLight.bg,
    textTheme: XTextTheme.light,
    elevatedButtonTheme: XElevatedButtonTheme.light,
    iconTheme: IconThemeData(
      color: XAppColorsLight.success,
      applyTextScaling: true,
    ),

    cardTheme: XCardTheme.light,
    inputDecorationTheme: XInputDecorationTheme.light,
    cardColor: XAppColorsLight.bg_element_container,
    dropdownMenuTheme: XDropDownMenuTheme.light,
    switchTheme: XSwitchTheme.light
  );
  static ThemeData get dark => ThemeData(textTheme: XTextTheme.dark);
}
