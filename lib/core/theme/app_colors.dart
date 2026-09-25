import 'package:flutter/material.dart';

import '../utils/app_consts.dart';

class AppColors {
  static Color get primaryDark =>
      AppConst.isDark ? const Color(0xFF1F7A72) : const Color(0xFF0E6B63);

  static Color get mainBlack900 => const Color(0xFF101214);

  static Color get mainWhite50 => const Color(0xFFF3F7F6);

  static Color get background =>
      AppConst.isDark ? mainBlack900 : mainWhite50;

  static Color get primary =>
      AppConst.isDark ? const Color(0xFF6FCFC6) : const Color(0xFF12897C);

  static Color get transparent => Colors.transparent;

  static Color get primaryColor2 =>
      AppConst.isDark ? const Color(0xFF1D2024) : const Color(0xFF0F4F49);

  static Color get white =>
      AppConst.isDark ? const Color(0xFF17191C) : const Color(0xFFFFFFFF);

  static Color get whiteConstant => Colors.white;

  static Color get label =>
      AppConst.isDark ? const Color(0xFFF1F3F5) : const Color(0xFF14332F);

  static Color get secondary =>
      AppConst.isDark ? const Color(0xFFA8ADB5) : const Color(0xFF14332F);

  static Color get shimmerBase =>
      AppConst.isDark ? const Color(0xFF1D2024) : const Color(0xFFE3EEEC);

  static Color get shimmerHighlight =>
      AppConst.isDark ? const Color(0xFF2A2E33) : const Color(0xFFF7FBFA);
}
