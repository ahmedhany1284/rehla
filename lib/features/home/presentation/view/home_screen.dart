import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rehla/core/presentation/view/widgets/main_button.dart';
import 'package:rehla/core/presentation/view/widgets/qallery_outfit_shimmar.dart';
import 'package:rehla/core/presentation/view/widgets/simple_appbar.dart';
import 'package:rehla/core/presentation/view_model/cubit/app_cubit.dart';
import 'package:rehla/core/presentation/view_model/cubit/app_state.dart';
import 'package:rehla/core/routing/app_router.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/utils/app_strings.dart';
import 'package:rehla/features/home/presentation/view-model/home_cubit.dart';
import 'package:rehla/features/home/presentation/view/widgets/continue_watching_card.dart';
import 'package:rehla/features/home/presentation/view/widgets/course_card.dart';
import 'package:rehla/features/home/presentation/view/widgets/home_message.dart';

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
                return HomeMessage(
                  message: AppStrings.coursesLoadFailed,
                  action: AppDefaultButton(
                    buttonText: AppStrings.retry,
                    ontap: () => context.read<HomeCubit>().getCourses(),
                  ),
                );
              }
              if (state.status == HomeStatus.empty) {
                return HomeMessage(message: AppStrings.coursesEmpty);
              }
              final data = state.data;
              if (data == null) {
                return HomeMessage(message: AppStrings.coursesEmpty);
              }
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  if (data.continueWatching != null)
                    ContinueWatchingCard(item: data.continueWatching!),
                  ...data.courses.map(
                    (summary) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CourseCard(
                        summary: summary,
                        onTap: () async {
                          await context.push(
                            AppRouter.courseDetails(summary.course.id),
                          );
                          if (context.mounted) {
                            context.read<HomeCubit>().getCourses();
                          }
                        },
                      ),
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
