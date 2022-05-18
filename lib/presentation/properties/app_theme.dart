import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final light = FlexThemeData.light(
    background: Colors.white,
    colors: FlexSchemeColor.from(
      primary: const Color(0xFF00296B),
      secondary: const Color(0xFFFF7B00),
      brightness: Brightness.light,
    ),
  );
  static final dark = FlexThemeData.dark(
    background: Colors.grey.shade900,
    colors: FlexSchemeColor.from(
      primary: const Color(0xFF6B8BC3),
      secondary: const Color(0xffff7155),
      brightness: Brightness.dark,
    ),
  );
}
