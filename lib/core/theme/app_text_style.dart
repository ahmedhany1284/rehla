import 'package:flutter/material.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/font_family.dart';

class AppTextStyle {
  static TextStyle get semiBold16 => TextStyle(
    color: AppColors.label,
    fontFamily: FontFamily.neulisSans,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get medium16 => TextStyle(
    color: AppColors.label,
    fontFamily: FontFamily.neulisSans,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get regular14 => TextStyle(
    color: AppColors.label,
    fontFamily: FontFamily.neulisSans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get buttonLarge => TextStyle(
    color: AppColors.whiteConstant,
    fontFamily: FontFamily.neulisSans,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}
