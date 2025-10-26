import 'package:flutter/material.dart';
import 'package:word_guess/theme/app_colors.dart';

class XSwitchTheme {
  XSwitchTheme._();

  static SwitchThemeData get light => SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(XAppColorsLight.bg_primary_action),
    trackColor: WidgetStatePropertyAll(XAppColorsLight.bg_actions),
    trackOutlineColor: WidgetStatePropertyAll(XAppColorsLight.border),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
  );
}
