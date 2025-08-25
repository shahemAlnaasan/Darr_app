import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;

  Color get primaryColor => colorScheme.primary;
  Color get onPrimaryColor => colorScheme.onPrimary;

  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get surfaceContainer => colorScheme.surfaceContainer;

  Color get tertiary => colorScheme.tertiary;
  Color get onTertiary => colorScheme.onTertiary;

  // ignore: deprecated_member_use
  Color get background => colorScheme.background;
  // ignore: deprecated_member_use
  Color get onBackground => colorScheme.onBackground;

  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;

  Color get error => colorScheme.error;
  Color get onError => colorScheme.onError;

  Color get shadow => colorScheme.shadow;
  Color get outline => colorScheme.outline;

  Color get inverse => colorScheme.inversePrimary;

  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;

  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;

  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;

  // ignore: deprecated_member_use
  Color get surfaceVariant => colorScheme.surfaceVariant;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;

  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);
}
