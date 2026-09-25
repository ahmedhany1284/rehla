import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rehla/core/presentation/view/widgets/app_custom_appbar.dart';
import 'package:rehla/core/presentation/view/widgets/main_button.dart';
import 'package:rehla/core/presentation/view/widgets/qallery_outfit_shimmar.dart';
import 'package:rehla/core/presentation/view_model/cubit/app_cubit.dart';
import 'package:rehla/core/presentation/view_model/cubit/app_state.dart';
import 'package:rehla/core/routing/app_router.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/app_text_style.dart';
import 'package:rehla/core/utils/app_strings.dart';
import 'package:rehla/features/home/presentation/course_details/view-model/course_details_cubit.dart';
import 'package:rehla/features/home/presentation/course_details/view/widgets/lesson_tile.dart';
import 'package:rehla/features/home/presentation/course_details/view/widgets/section_header.dart';
import 'package:rehla/features/home/presentation/view/extensions/localized_string.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        return BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
          builder: (context, state) {
            final title =
                state.details?.course.title.localized(context) ??
                AppStrings.courseDetails;
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppCustomAppBar(title: title),
              body: _body(context, state),
            );
          },
        );
      },
    );
  }

  Widget _body(BuildContext context, CourseDetailsState state) {
    if (state.status == CourseDetailsStatus.loading ||
        state.status == CourseDetailsStatus.initial) {
      return const QalleryOutfitShimmar();
    }
    if (state.status == CourseDetailsStatus.error) {
      return _Message(
        message: AppStrings.coursesLoadFailed,
        action: AppDefaultButton(
          buttonText: AppStrings.retry,
          ontap: () => context.read<CourseDetailsCubit>().load(courseId),
        ),
      );
    }
    if (state.status == CourseDetailsStatus.empty) {
      return _Message(message: AppStrings.lessonsEmpty);
    }
    final details = state.details;
    if (details == null) {
      return _Message(message: AppStrings.lessonsEmpty);
    }
    return ListView(
      children: [
        for (final section in details.sections) ...[
          SectionHeader(title: section.section.title.localized(context)),
          for (final lesson in section.lessons)
            LessonTile(
              item: lesson,
              onTap: () {
                if (!lesson.unlocked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppStrings.lessonLocked,
                        style: AppTextStyle.regular14.copyWith(
                          color: AppColors.whiteConstant,
                        ),
                      ),
                      backgroundColor: AppColors.primaryColor2,
                    ),
                  );
                  return;
                }
                context.push(
                  AppRouter.lessonPlayer(details.course.id, lesson.lesson.id),
                );
              },
            ),
        ],
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.message, this.action});

  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: AppTextStyle.medium16,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
