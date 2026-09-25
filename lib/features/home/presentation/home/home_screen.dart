import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rehla/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:rehla/core/presentation/view/widgets/main_button.dart';
import 'package:rehla/core/presentation/view/widgets/qallery_outfit_shimmar.dart';
import 'package:rehla/core/presentation/view/widgets/simple_appbar.dart';
import 'package:rehla/core/presentation/view_model/cubit/app_cubit.dart';
import 'package:rehla/core/presentation/view_model/cubit/app_state.dart';
import 'package:rehla/core/routing/app_router.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/utils/app_strings.dart';
import 'package:rehla/core/theme/app_text_style.dart';
import 'package:rehla/features/home/domain/entities/course.dart';
import 'package:rehla/features/home/presentation/home/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppSimpleAppBar(
        title: AppStrings.homeTitle,
        isLeading: false,
        actions: [
          IconButton(
            onPressed: () => context.push(AppRouter.kSettings),
            icon: Icon(Icons.settings_outlined, color: AppColors.label),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading ||
              state.status == HomeStatus.initial) {
            return const QalleryOutfitShimmar();
          }
          if (state.status == HomeStatus.error) {
            return _MessageState(
              message: AppStrings.coursesLoadFailed,
              action: AppDefaultButton(
                buttonText: AppStrings.retry,
                ontap: () => context.read<HomeCubit>().getCourses(),
              ),
            );
          }
          if (state.status == HomeStatus.empty) {
            return _MessageState(message: AppStrings.coursesEmpty);
          }
          final data = state.data;
          if (data == null) {
            return _MessageState(message: AppStrings.coursesEmpty);
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (data.continueWatching != null)
                _ContinueWatchingCard(item: data.continueWatching!),
              ...data.courses.map(
                (summary) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CourseCard(summary: summary),
                ),
              ),
            ],
          );
        },
      ),
        );
      },
    );
  }
}

class _ContinueWatchingCard extends StatelessWidget {
  const _ContinueWatchingCard({required this.item});

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
            style: AppTextStyle.regular14.copyWith(color: AppColors.whiteConstant),
          ),
          const SizedBox(height: 8),
          Text(
            item.lesson.title,
            style: AppTextStyle.semiBold16.copyWith(color: AppColors.whiteConstant),
          ),
          const SizedBox(height: 4),
          Text(
            item.course.title,
            style: AppTextStyle.regular14.copyWith(color: AppColors.whiteConstant),
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

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.summary});

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

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message, this.action});

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
            if (action != null) ...[
              const SizedBox(height: 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
