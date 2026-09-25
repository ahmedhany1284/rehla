import 'package:flutter/material.dart';
import 'package:rehla/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/utils/app_consts.dart';
import 'package:rehla/core/theme/app_text_style.dart';

class AppDefaultButton extends StatelessWidget {
  const AppDefaultButton({
    super.key,
    required this.buttonText,
    required this.ontap,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.isTransparent = false,
    this.buttonTextStyle,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.spacing,
    this.isIconLeading = true,
    this.imagePath,
  });

  final String buttonText;
  final VoidCallback? ontap;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final bool isTransparent;
  final TextStyle? buttonTextStyle;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final double? spacing;
  final bool isIconLeading;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final disabled = ontap == null && !isLoading && !isTransparent;
    final actualBackgroundColor = isLoading
        ? AppColors.shimmerBase
        : isTransparent
            ? AppColors.transparent
            : disabled && AppConst.isDark
            ? AppColors.shimmerBase
            : backgroundColor ?? AppColors.primaryDark;
    final actualTextColor = textColor ??
        (disabled && AppConst.isDark
            ? AppColors.secondary
            : AppColors.whiteConstant);
    final actualIconColor = iconColor ?? actualTextColor;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: isLoading ? null : ontap,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          width: width,
          height: height ?? 48,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: actualBackgroundColor,
            borderRadius: BorderRadius.circular(32),
            border: borderColor != null
                ? Border.all(color: borderColor!)
                : null,
          ),
          child: isLoading
              ? SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.whiteConstant,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null && isIconLeading) ...[
                      Icon(icon, color: actualIconColor, size: iconSize ?? 20),
                      SizedBox(width: spacing ?? 8),
                    ] else if (imagePath != null && isIconLeading) ...[
                      AppCustomImageView(
                        imagePath: imagePath,
                        height: 18,
                        width: 18,
                        color: actualTextColor,
                      ),
                      SizedBox(width: spacing ?? 8),
                    ],
                    Text(
                      buttonText,
                      style: buttonTextStyle ??
                          AppTextStyle.buttonLarge.copyWith(
                            color: actualTextColor,
                          ),
                    ),
                    if (icon != null && !isIconLeading) ...[
                      SizedBox(width: spacing ?? 8),
                      Icon(icon, color: actualIconColor, size: iconSize ?? 20),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
