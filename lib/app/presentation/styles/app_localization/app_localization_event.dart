part of 'app_localization_bloc.dart';

sealed class AppLocalizationEvent {}

class AppLocalizationInitialEvent extends AppLocalizationEvent {}

class ChangeAppLocalizationEvent extends AppLocalizationEvent {
  final String defaultLanguage;
  ChangeAppLocalizationEvent({required this.defaultLanguage});
}
