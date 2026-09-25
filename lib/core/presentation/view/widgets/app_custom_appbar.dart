import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/app_text_style.dart';

class AppCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppCustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.appBarHeight,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.onBackPressed,
    this.titleStyle,
    this.leading,
    this.bottom,
    this.forceMaterialTransparency = true,
    this.arrowBackColor,
    this.systemOverlayStyle,
  });

  final String title;
  final bool centerTitle;
  final double? appBarHeight;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;
  final TextStyle? titleStyle;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool forceMaterialTransparency;
  final Color? arrowBackColor;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      systemOverlayStyle: systemOverlayStyle ??
          SystemUiOverlayStyle(
            statusBarColor: AppColors.transparent,
            statusBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          ),
      forceMaterialTransparency: forceMaterialTransparency,
      elevation: 0,
      backgroundColor: backgroundColor ?? AppColors.transparent,
      centerTitle: centerTitle,
      title: Text(title, style: titleStyle ?? AppTextStyle.semiBold16),
      leading: showBackButton
          ? leading ??
              IconButton(
                onPressed: onBackPressed ??
                    () {
                      if (context.canPop()) context.pop();
                    },
                icon: Icon(
                  Icons.arrow_back,
                  color: arrowBackColor ?? AppColors.label,
                ),
              )
          : null,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        (appBarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0),
      );
}
