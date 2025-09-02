import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../common/consts/app_keys.dart';
import '../../../../common/theme/app_theme.dart';
import '../../../../core/datasources/hive_helper.dart';
import 'package:injectable/injectable.dart';

part 'main_event.dart';
part 'main_state.dart';

@singleton
class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState()) {
    on<GetThemeEvent>(_onGetThemeEvent);
    on<SetThemeEvent>(_onSetThemeEvent);
  }
  Future<void> _onGetThemeEvent(GetThemeEvent event, Emitter<MainState> emit) async {
    debugPrint("🔥 GetThemeEvent triggered");

    emit(state.copyWith(status: MainStatus.loading));
    String? themeKey = await getTheme();
    ThemeData theme;

    if (themeKey == "dark") {
      theme = AppTheme.darkTheme;
    } else {
      theme = AppTheme.lightTheme;
    }

    emit(state.copyWith(theme: theme, status: MainStatus.success));
  }

  Future<void> _onSetThemeEvent(SetThemeEvent event, Emitter<MainState> emit) async {
    emit(state.copyWith(status: MainStatus.loading));
    final isCurrentlyDark = state.theme == AppTheme.darkTheme;
    final newThemeType = isCurrentlyDark ? ThemeType.light : ThemeType.dark;
    final newTheme = isCurrentlyDark ? AppTheme.lightTheme : AppTheme.darkTheme;
    setTheme(themeType: newThemeType);
    emit(state.copyWith(status: MainStatus.success, theme: newTheme));
  }
}

enum ThemeType { dark, light }

Future<String?> getTheme() async {
  String? theme = await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.themeKey);
  return theme;
}

void setTheme({required ThemeType themeType}) {
  String theme = themeType == ThemeType.dark ? "dark" : "light";
  HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.themeKey, value: theme);
}
