import 'package:flutter/material.dart';
import 'package:rehla/core/presentation/view/widgets/app_custom_appbar.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/utils/app_strings.dart';

class LessonPlayerScreen extends StatelessWidget {
  const LessonPlayerScreen({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  final String courseId;
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppCustomAppBar(title: AppStrings.lesson),
    );
  }
}
