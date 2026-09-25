import 'package:flutter/material.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/font_family.dart';

class AppTextStyle {
  static TextStyle semiBold16 = TextStyle(
    color: AppColors.label,
    fontFamily: FontFamily.neulisSans,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle medium16 = TextStyle(
    color: AppColors.label,
    fontFamily: FontFamily.neulisSans,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle regular14 = TextStyle(
    color: AppColors.label,
    fontFamily: FontFamily.neulisSans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle buttonLarge = TextStyle(
    color: AppColors.whiteConstant,
    fontFamily: FontFamily.neulisSans,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}
