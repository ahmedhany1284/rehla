import 'package:flutter/material.dart';
import 'package:rehla/core/presentation/view/widgets/main_button.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/app_text_style.dart';
import 'package:rehla/core/utils/app_strings.dart';
import 'package:rehla/features/home/domain/entities/course.dart';

class ContinueWatchingCard extends StatelessWidget {
  const ContinueWatchingCard({super.key, required this.item});

  final ContinueWatching item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.continueWatching,
            style: AppTextStyle.regular14.copyWith(
              color: AppColors.whiteConstant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.lesson.title,
            style: AppTextStyle.semiBold16.copyWith(
              color: AppColors.whiteConstant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.course.title,
            style: AppTextStyle.regular14.copyWith(
              color: AppColors.whiteConstant,
            ),
          ),
          const SizedBox(height: 12),
          AppDefaultButton(
            buttonText: AppStrings.continueLabel,
            backgroundColor: AppColors.whiteConstant,
            textColor: AppColors.primaryDark,
            ontap: () {},
          ),
        ],
      ),
    );
  }
}
