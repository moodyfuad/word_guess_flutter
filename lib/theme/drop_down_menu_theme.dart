import 'package:flutter/material.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/theme/input_decoration_theme.dart';

class XDropDownMenuTheme {
  XDropDownMenuTheme._();
  static DropdownMenuThemeData get light => DropdownMenuThemeData(
    disabledColor: XAppColorsLight.bg_element_container,
    textStyle: ThemeData.light().textTheme.bodyMedium,


    inputDecorationTheme: XInputDecorationTheme.light,

    menuStyle: MenuStyle(
      
      backgroundColor: WidgetStatePropertyAll(XAppColorsLight.bg_actions),
      alignment: Alignment.bottomRight,
    ),
  );
}
