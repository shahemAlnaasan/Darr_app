import 'dart:ui';

import 'package:catcher_2/core/catcher_2.dart' show Catcher2;
import 'package:easy_localization/easy_localization.dart';
import 'package:exchange_darr/common/theme/app_theme.dart';
import 'package:exchange_darr/features/main/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: MaterialApp(
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
          },
        ),
        theme: AppTheme.lightTheme,
        navigatorKey: Catcher2.navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: HomeDecider(),
      ),
    );
  }
}
