import 'package:flutter/material.dart';

class Environments {
  static const String appName = 'Flutter Bloc Boilerplate Firebase';
  static const String defaultLanguage = 'en';

  static const supportedLanguages = [
    Locale('en'),
    Locale('ar'),
    Locale('hi'),
  ];

  static const languageList = ['en', 'ar', 'hi'];
}

class LanguageEntity {
  final String code;
  final String value;

  const LanguageEntity({
    required this.code,
    required this.value,
  });
}

class Languages {
  const Languages._();

  static const languages = [
    LanguageEntity(code: 'en', value: 'English'),
    LanguageEntity(code: 'ar', value: 'عربي'),
    LanguageEntity(code: 'hi', value: 'हिंदी'),
  ];
}
