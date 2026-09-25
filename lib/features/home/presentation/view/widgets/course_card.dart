import 'package:flutter/material.dart';
import 'package:rehla/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/app_text_style.dart';
import 'package:rehla/core/utils/app_strings.dart';
import 'package:rehla/features/home/domain/entities/course.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.summary});

  final CourseSummary summary;

  @override
  Widget build(BuildContext context) {
    final course = summary.course;
    final percent = summary.progressPercent.round();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          AppCustomImageView(
            imagePath: course.thumbnail,
            height: 72,
            width: 72,
            radius: BorderRadius.circular(12),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course.title, style: AppTextStyle.semiBold16),
                const SizedBox(height: 4),
                Text(course.instructor, style: AppTextStyle.regular14),
                const SizedBox(height: 4),
                Text(
                  AppStrings.lessonCount('${course.lessonCount}'),
                  style: AppTextStyle.regular14,
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.progressPercent('$percent'),
                  style: AppTextStyle.medium16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
