part of 'app_localization_bloc.dart';

final class AppLocalizationState {
  final String appLanguage;
  const AppLocalizationState({required this.appLanguage});

  AppLocalizationState copyWith({String? appLanguage}) {
    return AppLocalizationState(appLanguage: appLanguage ?? this.appLanguage);
  }
}
