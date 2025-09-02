// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/best_price.png
  AssetGenImage get bestPrice =>
      const AssetGenImage('assets/images/best_price.png');

  /// File path: assets/images/dollar.png
  AssetGenImage get dollar => const AssetGenImage('assets/images/dollar.png');

  /// File path: assets/images/facebook.png
  AssetGenImage get facebook =>
      const AssetGenImage('assets/images/facebook.png');

  /// File path: assets/images/info.png
  AssetGenImage get info => const AssetGenImage('assets/images/info.png');

  /// File path: assets/images/location.png
  AssetGenImage get location =>
      const AssetGenImage('assets/images/location.png');

  /// Directory path: assets/images/logo
  $AssetsImagesLogoGen get logo => const $AssetsImagesLogoGen();

  /// File path: assets/images/logout.png
  AssetGenImage get logout => const AssetGenImage('assets/images/logout.png');

  /// Directory path: assets/images/navbar
  $AssetsImagesNavbarGen get navbar => const $AssetsImagesNavbarGen();

  /// File path: assets/images/news.png
  AssetGenImage get news => const AssetGenImage('assets/images/news.png');

  /// File path: assets/images/share.png
  AssetGenImage get share => const AssetGenImage('assets/images/share.png');

  /// File path: assets/images/telegram.png
  AssetGenImage get telegram =>
      const AssetGenImage('assets/images/telegram.png');

  /// File path: assets/images/user.png
  AssetGenImage get user => const AssetGenImage('assets/images/user.png');

  /// File path: assets/images/whatsapp.png
  AssetGenImage get whatsapp =>
      const AssetGenImage('assets/images/whatsapp.png');

  /// File path: assets/images/world.png
  AssetGenImage get world => const AssetGenImage('assets/images/world.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    bestPrice,
    dollar,
    facebook,
    info,
    location,
    logout,
    news,
    share,
    telegram,
    user,
    whatsapp,
    world,
  ];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/ar.json
  String get ar => 'assets/translations/ar.json';

  /// List of all assets
  List<String> get values => [ar];
}

class $AssetsImagesLogoGen {
  const $AssetsImagesLogoGen();

  /// File path: assets/images/logo/android_12_splash.png
  AssetGenImage get android12Splash =>
      const AssetGenImage('assets/images/logo/android_12_splash.png');

  /// File path: assets/images/logo/company_logo.png
  AssetGenImage get companyLogo =>
      const AssetGenImage('assets/images/logo/company_logo.png');

  /// File path: assets/images/logo/splash_logo.png
  AssetGenImage get splashLogo =>
      const AssetGenImage('assets/images/logo/splash_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [android12Splash, companyLogo, splashLogo];
}

class $AssetsImagesNavbarGen {
  const $AssetsImagesNavbarGen();

  /// File path: assets/images/navbar/home.png
  AssetGenImage get home =>
      const AssetGenImage('assets/images/navbar/home.png');

  /// File path: assets/images/navbar/light_mode.png
  AssetGenImage get lightMode =>
      const AssetGenImage('assets/images/navbar/light_mode.png');

  /// File path: assets/images/navbar/logout.png
  AssetGenImage get logout =>
      const AssetGenImage('assets/images/navbar/logout.png');

  /// File path: assets/images/navbar/night_mode.png
  AssetGenImage get nightMode =>
      const AssetGenImage('assets/images/navbar/night_mode.png');

  /// List of all assets
  List<AssetGenImage> get values => [home, lightMode, logout, nightMode];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
