import 'package:flutter/material.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/theme/text_theme.dart';

class XDropDownMenuTheme {
  XDropDownMenuTheme._();
  static DropdownMenuThemeData get light => DropdownMenuThemeData(
    disabledColor: XAppColorsLight.bg_element_container,
    textStyle: TextStyle(
      color: XAppColorsLight.secondary_text,
      backgroundColor: XAppColorsLight.bg_actions,
      fontFamily: XTextTheme.fontFamily,
    ),

    // inputDecorationTheme: XInputDecorationTheme.light,
    menuStyle: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(XAppColorsLight.bg_actions),
      alignment: Alignment.bottomRight,
    ),
  );
}
