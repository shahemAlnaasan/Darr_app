
// ignore_for_file: deprecated_member_use

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

import '../theme/text_theme.dart';

class AppText extends StatelessWidget {
  AppText(
    this.text, {
    super.key,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    TextStyle? style,
    this.color,
    this.velocity,
    this.height,
    this.figmaLineHeight,
    this.scrollText = false,
  }) : style = (style ?? const TextStyle()).copyWith(color: color);

  final String text;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final ui.TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final Color? selectionColor;
  final TextStyle? style;
  final Color? color;
  final double? velocity;
  final bool scrollText;
  final double? height;
  final double? figmaLineHeight;

  @override
  Widget build(BuildContext context) {
    return scrollText
        ? TextScroll(
            text,
            mode: TextScrollMode.endless,
            velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
            delayBefore: const Duration(milliseconds: 1000),
            pauseBetween: const Duration(milliseconds: 2000),
            style: style?.copyWith(color: color),
            selectable: true,
            intervalSpaces: 5,
            textAlign: textAlign,
            // textDirection: textDirection,
          )
        : Text(
            text,
            style: style?.copyWith(
              color: color,
              textBaseline: TextBaseline.alphabetic,
              height: height,
            ),
            key: key,
            locale: locale,
            maxLines: maxLines,
            overflow: overflow,
            semanticsLabel: semanticsLabel,
            softWrap: softWrap,
            strutStyle: strutStyle,
            textAlign: textAlign ?? TextAlign.center,
            textDirection: textDirection,
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: true,
              leadingDistribution: TextLeadingDistribution.even,
            ),
            textScaleFactor: textScaleFactor,
          );
  }

  ///                              <<<<<  ----    factory constructor   ----  >>>>>
  const AppText.marquee(
    this.text, {
    this.figmaLineHeight,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.style,
    this.color,
    this.velocity,
    this.scrollText = true,
    super.key,
    this.height,
  });

  ///                              <<<<<  ----    Default Style   ----  >>>>>
  AppText.displayLarge(
    this.text, {
    this.figmaLineHeight,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    this.scrollText = false,
    TextStyle? style,
    FontWeight? fontWeight,
    super.key,
    this.height,
  }) : style = textTheme.displayLarge?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.displayMedium(
    this.text, {
    this.scrollText = false,
    this.strutStyle,
    this.figmaLineHeight,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.displayMedium?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.displaySmall(
    this.text, {
    this.scrollText = false,
    this.strutStyle,
    this.textAlign,
    this.figmaLineHeight,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.displaySmall?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.headlineLarge(
    this.text, {
    this.scrollText = false,
    this.strutStyle,
    this.textAlign,
    this.figmaLineHeight,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.headlineLarge?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.headlineMedium(
    this.text, {
    this.scrollText = false,
    this.strutStyle,
    this.textAlign,
    this.figmaLineHeight,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.headlineMedium?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.headlineSmall(
    this.text, {
    this.scrollText = false,
    this.strutStyle,
    this.figmaLineHeight,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.headlineSmall?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.titleLarge(
    this.text, {
    this.scrollText = false,
    this.figmaLineHeight,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.titleLarge?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.titleMedium(
    this.text, {
    this.scrollText = false,
    this.figmaLineHeight,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.titleMedium?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.titleSmall(
    this.text, {
    this.scrollText = false,
    this.strutStyle,
    this.figmaLineHeight,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.titleSmall?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.labelLarge(
    this.text, {
    this.scrollText = false,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.figmaLineHeight,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.labelLarge?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.labelMedium(
    this.text, {
    this.scrollText = false,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.figmaLineHeight,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.labelMedium?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.labelSmall(
    this.text, {
    this.scrollText = false,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.figmaLineHeight,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.labelSmall?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.bodyLarge(
    this.text, {
    this.scrollText = false,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.figmaLineHeight,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.bodyLarge?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.bodyMedium(
    this.text, {
    this.scrollText = false,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.figmaLineHeight,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    super.key,
    TextStyle? style,
    FontWeight? fontWeight,
    this.height,
  }) : style = textTheme.bodyMedium?.merge(style).copyWith(fontWeight: fontWeight);

  AppText.bodySmall(
    this.text, {
    this.scrollText = false,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.color,
    this.velocity,
    this.figmaLineHeight,
    TextStyle? style,
    FontWeight? fontWeight,
    super.key,
    this.height,
  }) : style = textTheme.bodySmall?.merge(style).copyWith(fontWeight: fontWeight);
}

