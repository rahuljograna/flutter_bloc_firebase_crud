import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_firebase_crud/app/presentation/styles/app_localization/app_localization_bloc.dart';
import 'package:flutter_bloc_firebase_crud/env.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/core/observer.dart';
import 'app/presentation/styles/theme.dart';
import 'app/presentation/styles/theme_bloc/theme_bloc.dart';
import 'app/router/app_route_config.dart';
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = const AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()..add(ThemeInitialEvent())),
          BlocProvider(
              create: (_) =>
                  AppLocalizationBloc()..add(AppLocalizationInitialEvent()))
        ],
        child: Builder(builder: (context) {
          final isDarkTheme = context.watch<ThemeBloc>().state.isDarkTheme;
          final currentLanguage =
              context.watch<AppLocalizationBloc>().state.appLanguage;
          return MaterialApp(
            title: Environments.appName,
            initialRoute: AppRouter.initialRoute,
            onGenerateRoute: AppRouter.onGenerateRouted,
            localizationsDelegates: const [
              AppLocalizations.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Environments.supportedLanguages,
            locale: Locale(currentLanguage),
            debugShowCheckedModeBanner: false,
            theme: isDarkTheme
                ? appThemeData[AppTheme.dark]
                : appThemeData[AppTheme.light],
          );
        }));
  }
}
