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

  static Color get whiteConstant => Colors.white;

  static Color get label => AppConst.isDark ? mainWhite50 : primaryDark;

  static Color get shimmerBase =>
      AppConst.isDark ? const Color(0xFF2A2D36) : const Color(0xFFE0E0E0);

  static Color get shimmerHighlight =>
      AppConst.isDark ? const Color(0xFF3A3F4B) : const Color(0xFFF5F5F5);
}
