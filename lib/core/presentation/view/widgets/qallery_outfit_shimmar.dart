import 'package:flutter/material.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class QalleryOutfitShimmar extends StatelessWidget {
  const QalleryOutfitShimmar({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, _) => Container(
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.whiteConstant,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
