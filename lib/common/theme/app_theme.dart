
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'text_theme.dart';

class AppTheme {
  /// dark Theme
  static ThemeData lightTheme = ThemeData(
    colorScheme: ThemesColorScheme.lightColorScheme,
    // scaffoldBackgroundColor: const Color(0xffF5F5F5),
    textTheme: textTheme,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ThemesColorScheme.darkColorScheme,
    // scaffoldBackgroundColor: const Color(0xff151515),

    textTheme: textTheme,
  );
}

