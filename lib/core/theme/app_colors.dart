import 'package:flutter/material.dart';

import '../utils/app_consts.dart';

class AppColors {
  static Color get primaryDark => const Color(0xFF08322A);

  static Color get mainBlack900 => const Color(0xFF060606);

  static Color get mainWhite50 => const Color(0xFFFDFDFD);

  static Color get background => AppConst.isDark ? mainBlack900 : mainWhite50;

  static Color get primary => primaryDark;

  static Color get transparent => Colors.transparent;

  static Color get primaryColor2 =>
      AppConst.isDark ? const Color(0xFF2A2D36) : const Color(0xFF1E3A4C);

  static Color get white =>
      AppConst.isDark ? const Color(0xFF131921) : Colors.white;
}
