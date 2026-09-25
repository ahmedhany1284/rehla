import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData appLightTheme(String fontFamily) => ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      );
}
