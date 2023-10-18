part of 'theme_bloc.dart';

sealed class ThemeEvent {
  const ThemeEvent();
}

class ThemeInitialEvent extends ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {}
