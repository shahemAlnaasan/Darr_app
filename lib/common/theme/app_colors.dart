// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ThemesColorScheme {
  static const _mainOrange = Colors.white;

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _mainOrange,
    onPrimary: Color(0xff1C1C1E),
    secondary: Color.fromARGB(201, 1, 1, 1),
    onSecondary: Colors.black,
    tertiary: Color(0xFFB0BEC5),
    onTertiary: Color(0xff63ad5e),
    error: Color(0xffff5d5a),
    surfaceContainer: Color(0xff26436c),
    onError: Colors.white,

    // app background as light grey
    background: _mainOrange,
    onBackground: Color(0xff1C1C1E),

    // surface elements white
    surface: Colors.white,
    onSurface: Color(0xff1C1C1E),

    primaryContainer: Color(0xffff6117),
    onPrimaryContainer: Color(0xffEDEDED),
    secondaryContainer: Color(0xffFFF0E6),
    onSecondaryContainer: Color(0xff2C2C2E),
    tertiaryContainer: Color(0xFFECEFF1), // subtle grey container
    onTertiaryContainer: Color(0xff1C1C1E),
  );
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Containers background (e.g., cards, surfaces)
    primary: Color(0xFF3c3c3c), // dark grey container background
    onPrimary: Color(0xFFEDEDED), // text/icons on primary containers
    // Text/icons
    secondary: Color(0xFFF5F5F5), // light text/icons color
    onSecondary: Color(0xFF1E1E1E), // not commonly used
    // App background
    background: Color(0xFF212121), // pure dark background
    onBackground: Color(0xFFF0F0F0), // text/icons on app background
    // Error
    error: Color(0xFFFF5D5A),
    onError: Colors.white,

    // Surfaces (e.g., dialogs, sheets)
    surface: Color(0xFF1C1C1E),
    onSurface: Color(0xFFE0E0E0),

    // Custom containers
    primaryContainer: Color.fromARGB(237, 252, 197, 47),
    onPrimaryContainer: Color(0xFFDADADA),

    secondaryContainer: Color(0xFF3A3A3A),
    onSecondaryContainer: Color(0xFFF0F0F0),

    tertiary: Color(0xFF2C2C2F),
    onTertiary: Color(0xff63ad5e),

    // Additional (if needed)
    outline: Color(0xFF5A5A5A),
    shadow: Colors.black,
    surfaceVariant: Color(0xFF2A2A2D),
    onSurfaceVariant: Color(0xFFB0B0B0),
  );
}
