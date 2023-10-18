import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_firebase_crud/app/services/shared_pref.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferencesManager _sharedPreferencesManager =
      SharedPreferencesManager();
  ThemeBloc() : super(const ThemeState(isDarkTheme: false)) {
    on<ThemeInitialEvent>(_onThemeInitialEvent);
    on<ChangeThemeEvent>(changeThemeEventHandler);
  }

  FutureOr<void> changeThemeEventHandler(
      ChangeThemeEvent event, Emitter<ThemeState> emit) {
    debugPrint('update the ui');
    if (state.isDarkTheme) {
      emit(state.copyWith(isDarkTheme: false));
      _sharedPreferencesManager.putBool('isDark', false);
    } else {
      emit(state.copyWith(isDarkTheme: true));
      _sharedPreferencesManager.putBool('isDark', true);
    }
  }

  Future<void> _onThemeInitialEvent(
      ThemeInitialEvent event, Emitter<ThemeState> emit) async {
    final isDarkTheme = await (_sharedPreferencesManager.getBool('isDark'));
    emit(state.copyWith(isDarkTheme: isDarkTheme));
  }
}
