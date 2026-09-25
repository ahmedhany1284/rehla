import 'package:flutter/material.dart';
import 'package:rehla/core/theme/app_colors.dart';

class AppCustomImageView extends StatelessWidget {
  const AppCustomImageView({
    super.key,
    this.imagePath,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
  });

  final String? imagePath;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(onTap: onTap, child: _image()),
    );
    if (alignment == null) return child;
    return Align(alignment: alignment!, child: child);
  }

  Widget _image() {
    Widget image = _buildImage();
    if (border != null) {
      image = Container(
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: image,
      );
    }
    if (radius != null) {
      image = ClipRRect(borderRadius: radius!, child: image);
    }
    return image;
  }

  Widget _buildImage() {
    if (icon != null) {
      return Icon(icon, size: iconSize ?? height, color: iconColor ?? color);
    }
    if (imagePath == null || imagePath!.isEmpty) {
      return _fallback();
    }
    return Image.asset(
      imagePath!,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      color: color,
      errorBuilder: (_, _, _) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      height: height,
      width: width,
      color: AppColors.shimmerBase,
      alignment: Alignment.center,
      child: Icon(Icons.image_outlined, color: AppColors.label),
    );
  }
}
