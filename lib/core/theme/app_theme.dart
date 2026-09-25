import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData appLightTheme(String fontFamily) => ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        scaffoldBackgroundColor: AppColors.background,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: AppColors.transparent,
            systemNavigationBarColor: AppColors.white,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        dividerTheme: const DividerThemeData(thickness: 0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor2,
          brightness: Brightness.light,
        ),
      );

  static ThemeData appDarkTheme(String fontFamily) => ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: AppColors.background,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.background,
          ),
        ),
        scaffoldBackgroundColor: AppColors.background,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        dividerTheme: const DividerThemeData(thickness: 0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
      );
}
