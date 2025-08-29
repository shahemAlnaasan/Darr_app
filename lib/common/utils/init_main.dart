import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../consts/app_keys.dart';
import '../../core/di/injection.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../state_managment/bloc_observer.dart';

class Initialization {
  static Future<void> initMain() async {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Color(0xff26436c),
          systemNavigationBarColor: Color(0xff26436c),
          statusBarColor: Color(0xff26436c),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
    });

    Bloc.observer = MyBlocObserver();
    await initHive();
    configureDependencies();
  }

  static initLocalization(Widget main) {
    return EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: Locale('ar'),
      saveLocale: true,
      child: main,
    );
  }

  static Future<void> initHive() async {
    await Hive.initFlutter();
    // Hive.registerAdapters();
    await Hive.openBox(AppKeys.userBox);
  }
}
