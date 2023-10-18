import 'package:flutter/material.dart';

const typeTheme = Typography.whiteMountainView;

enum AppTheme { light, dark }

class ThemeProvider {
  static const Color primaryColor = Color.fromARGB(255, 20, 76, 230);
  static const Color secondaryColor =
      Color.fromARGB(255, 98, 60, 251); //work as secondary color
  static const Color backgroundColor = Colors.white;
  static const Color pageBackgroundColor = Color.fromARGB(255, 255, 255, 255);
  static const Color canvasColor = Color.fromARGB(255, 0, 0, 0);

  static const Color darkPrimaryColor = Color.fromARGB(255, 255, 255, 255);
  static const Color darkSecondaryColor =
      Colors.white; //work as secondary color
  static const Color darkBackgroundColor = Color(0xff393939);
  static const Color darkPageBackgroundColor = Color(0xFF3D3D3D);
  static const Color darkCanvasColor = Color.fromARGB(255, 255, 255, 255);

  static const Color greyColor = Color.fromARGB(255, 40, 37, 37);

  static const double scaffoldPadding = 16.0;
}

final appThemeData = {
  AppTheme.light: ThemeData(
    shadowColor: ThemeProvider.greyColor.withOpacity(0.25),
    brightness: Brightness.light,
    primaryColor: ThemeProvider.primaryColor,
    scaffoldBackgroundColor: ThemeProvider.pageBackgroundColor,
    canvasColor: ThemeProvider.canvasColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      color: ThemeProvider.primaryColor,
      titleTextStyle: TextStyle(
          fontFamily: 'regular',
          fontSize: 14,
          color: ThemeProvider.pageBackgroundColor),
    ),
    colorScheme: ThemeData().colorScheme.copyWith(
          secondary: ThemeProvider.secondaryColor,
          background: ThemeProvider.backgroundColor,
        ),
    iconTheme: const IconThemeData(color: ThemeProvider.pageBackgroundColor),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ThemeProvider.primaryColor,
      foregroundColor: ThemeProvider.darkCanvasColor,
    ),
  ),
  AppTheme.dark: ThemeData(
    shadowColor: ThemeProvider.greyColor.withOpacity(0.25),
    brightness: Brightness.dark,
    primaryColor: ThemeProvider.darkPrimaryColor,
    scaffoldBackgroundColor: ThemeProvider.darkPageBackgroundColor,
    canvasColor: ThemeProvider.darkCanvasColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      color: ThemeProvider.darkPageBackgroundColor,
      titleTextStyle: TextStyle(
          fontFamily: 'regular',
          fontSize: 14,
          color: ThemeProvider.darkPrimaryColor),
    ),
    colorScheme: ThemeData().colorScheme.copyWith(
        brightness: Brightness.dark,
        secondary: ThemeProvider.darkSecondaryColor,
        background: ThemeProvider.darkBackgroundColor),
    iconTheme: const IconThemeData(color: ThemeProvider.pageBackgroundColor),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ThemeProvider.darkPrimaryColor,
      foregroundColor: ThemeProvider.darkBackgroundColor,
    ),
  ),
};
