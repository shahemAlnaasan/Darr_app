import 'package:flutter/services.dart';

/// Utility class for providing consistent haptic feedback throughout the app
class HapticFeedbackUtil {
  /// Provides light haptic feedback suitable for button presses
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Provides medium haptic feedback suitable for more significant interactions
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Provides heavy haptic feedback suitable for major state changes
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Provides vibration feedback
  static Future<void> vibrate() async {
    await HapticFeedback.vibrate();
  }

  /// Provides selection click feedback
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }
}