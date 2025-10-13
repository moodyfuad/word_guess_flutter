import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class XAppColorsDark {
  XAppColorsDark._();
  static Color get bg => HSLColor.fromAHSL(1, 0, 0, 0).toColor();
  static Color get bg_element_container =>
      HSLColor.fromAHSL(0, 0, 0, 0.05).toColor();
  static Color get bg_actions => HSLColor.fromAHSL(1, 0, 0, 0.1).toColor();
  static Color get border => HSLColor.fromAHSL(1, 0, 0, 0.3).toColor();
  static Color get highlight => HSLColor.fromAHSL(1, 0, 0, 0.6).toColor();

  static Color get primary_text => HSLColor.fromAHSL(1, 0, 0, 0.95).toColor();
  static Color get secondary_text => HSLColor.fromAHSL(1, 0, 0, 0.70).toColor();

  static Color get danger => HSLColor.fromAHSL(1, 9, 0.21, 0.41).toColor();
  static Color get warning => HSLColor.fromAHSL(1, 52, 0.23, 0.34).toColor();
  static Color get success => HSLColor.fromAHSL(1, 147, 0.19, 0.36).toColor();
  static Color get info => HSLColor.fromAHSL(1, 217, 0.22, 0.41).toColor();
}

class XAppColorsLight {
  XAppColorsLight._();
  static Color get bg => HSLColor.fromAHSL(1, 0, 0, 0.9).toColor();
  static Color get bg_element_container =>
      HSLColor.fromAHSL(1, 0, 0, 0.95).toColor();
  static Color get bg_actions => HSLColor.fromAHSL(1, 0, 0, 1).toColor();
  static Color get border => bg;
  static Color get highlight => HSLColor.fromAHSL(1, 0, 0, 1).toColor();
  static Color get primary_action =>
      HSLColor.fromAHSL(1, 45, 1, 0.50).toColor();

  static Color get primary_text => HSLColor.fromAHSL(1, 0, 0, 0.05).toColor();
  static Color get secondary_text => HSLColor.fromAHSL(1, 0, 0, 0.3).toColor();
  static Color get danger => HSLColor.fromAHSL(1, 9, 0.21, 0.41).toColor();

  static Color get warning => HSLColor.fromAHSL(1, 52, 0.23, 0.34).toColor();
  static Color get success => HSLColor.fromAHSL(1, 147, 0.19, 0.36).toColor();
  static Color get info => HSLColor.fromAHSL(1, 217, 0.22, 0.41).toColor();
}
