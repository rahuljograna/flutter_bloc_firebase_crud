import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_firebase_crud/app/services/shared_pref.dart';
import 'package:flutter_bloc_firebase_crud/env.dart';

part 'app_localization_event.dart';
part 'app_localization_state.dart';

class AppLocalizationBloc
    extends Bloc<AppLocalizationEvent, AppLocalizationState> {
  final SharedPreferencesManager _sharedPreferencesManager =
      SharedPreferencesManager();
  AppLocalizationBloc()
      : super(const AppLocalizationState(
            appLanguage: Environments.defaultLanguage)) {
    on<AppLocalizationInitialEvent>(_onAppLocalizationInitialEvent);
    on<ChangeAppLocalizationEvent>(_onChangeAppLocalizationEvent);
  }

  Future<void> _onAppLocalizationInitialEvent(AppLocalizationInitialEvent event,
      Emitter<AppLocalizationState> emit) async {
    final defaultLanguage =
        await (_sharedPreferencesManager.getString('defaultLanguage'));
    emit(state.copyWith(appLanguage: defaultLanguage));
  }

  Future<void> _onChangeAppLocalizationEvent(ChangeAppLocalizationEvent event,
      Emitter<AppLocalizationState> emit) async {
    emit(state.copyWith(appLanguage: event.defaultLanguage));
    _sharedPreferencesManager.putString(
        'defaultLanguage', event.defaultLanguage);
  }
}
