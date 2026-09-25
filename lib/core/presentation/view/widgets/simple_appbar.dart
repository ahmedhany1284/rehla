import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/app_text_style.dart';

class AppSimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppSimpleAppBar({
    super.key,
    this.title,
    this.centerTitle = true,
    this.appBarHeight,
    this.backgroundColor,
    this.titleStyle,
    this.onTap,
    this.systemOverlayStyle,
    this.buildTitle,
    this.isLeading = true,
    this.actions,
  });

  final String? title;
  final bool centerTitle;
  final double? appBarHeight;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final VoidCallback? onTap;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Widget? buildTitle;
  final bool isLeading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      systemOverlayStyle: systemOverlayStyle ??
          SystemUiOverlayStyle(
            statusBarColor: AppColors.transparent,
            statusBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          ),
      forceMaterialTransparency: true,
      elevation: 0,
      backgroundColor: backgroundColor ?? AppColors.transparent,
      titleSpacing: 0,
      title: (title != null && title!.isNotEmpty)
          ? Text(title!, style: titleStyle ?? AppTextStyle.semiBold16)
          : buildTitle,
      centerTitle: centerTitle,
      leading: isLeading
          ? IconButton(
              onPressed: onTap ?? () => Navigator.of(context).maybePop(),
              icon: Icon(
                isRtl ? Icons.arrow_forward : Icons.arrow_back,
                color: AppColors.primaryDark,
              ),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? 64);
}
