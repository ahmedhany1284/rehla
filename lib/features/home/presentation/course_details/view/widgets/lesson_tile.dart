import 'package:flutter/material.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/app_text_style.dart';
import 'package:rehla/core/utils/app_strings.dart';
import 'package:rehla/features/home/domain/entities/course.dart';
import 'package:rehla/features/home/presentation/view/extensions/localized_string.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({super.key, required this.item, required this.onTap});

  final LessonDetails item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lesson = item.lesson;
    final minutes = lesson.durationSec ~/ 60;
    final seconds = (lesson.durationSec % 60).toString().padLeft(2, '0');
    return Opacity(
      opacity: item.unlocked ? 1 : 0.45,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                item.unlocked ? Icons.play_circle_outline : Icons.lock_outline,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title.localized(context),
                      style: AppTextStyle.medium16,
                    ),
                    const SizedBox(height: 4),
                    Text('$minutes:$seconds', style: AppTextStyle.regular14),
                  ],
                ),
              ),
              Text(_statusLabel(item.status), style: AppTextStyle.regular14),
              const SizedBox(width: 4),
              if (item.unlocked)
                Icon(Icons.chevron_right, color: AppColors.label),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(LessonStatus status) {
    switch (status) {
      case LessonStatus.notStarted:
        return AppStrings.notStarted;
      case LessonStatus.inProgress:
        return AppStrings.inProgress;
      case LessonStatus.completed:
        return AppStrings.completed;
    }
  }
}
