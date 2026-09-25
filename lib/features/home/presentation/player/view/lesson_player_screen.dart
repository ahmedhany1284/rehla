import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:rehla/features/home/presentation/player/view-model/player_cubit.dart';
import 'package:rehla/features/home/presentation/player/view/widgets/player_controls.dart';
import 'package:video_player/video_player.dart';

class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  final String courseId;
  final String lessonId;

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  bool _fullscreen = false;

  Future<void> _toggleFullscreen() async {
    final next = !_fullscreen;
    setState(() => _fullscreen = next);
    if (next) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      return;
    }
    await _restoreOrientation();
  }

  void _openNext(BuildContext context, PlayerState state) {
    final next = state.nextLessonId;
    if (next.isEmpty) return;
    context.push(AppRouter.lessonPlayer(widget.courseId, next));
  }

  Future<void> _restoreOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    _restoreOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, _) {
        return BlocBuilder<PlayerCubit, PlayerState>(
          builder: (context, state) {
            final video = context.read<PlayerCubit>().controller;
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: _fullscreen
                  ? null
                  : AppCustomAppBar(title: AppStrings.lesson),
              body: switch (state.status) {
                PlayerStatus.loading => const Center(
                  child: QalleryOutfitShimmar(),
                ),
                PlayerStatus.error => _Error(
                  onRetry: () => context.read<PlayerCubit>().load(
                    courseId: widget.courseId,
                    lessonId: widget.lessonId,
                  ),
                  onBack: () => context.pop(),
                ),
                _ => Column(
                  children: [
                    if (video != null && video.value.isInitialized)
                      AspectRatio(
                        aspectRatio: video.value.aspectRatio,
                        child: VideoPlayer(video),
                      ),
                    if (!_fullscreen)
                      Expanded(
                        child: SingleChildScrollView(
                          child: PlayerControls(
                            onFullscreen: _toggleFullscreen,
                            onNext: () => _openNext(context, state),
                          ),
                        ),
                      )
                    else
                      PlayerControls(
                        onFullscreen: _toggleFullscreen,
                        onNext: () => _openNext(context, state),
                      ),
                  ],
                ),
              },
            );
          },
        );
      },
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.onRetry, required this.onBack});

  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.primary, size: 48),
          const SizedBox(height: 16),
          Text(
            AppStrings.playerLoadFailed,
            style: AppTextStyle.medium16,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppDefaultButton(buttonText: AppStrings.retry, ontap: onRetry),
          const SizedBox(height: 12),
          AppDefaultButton(buttonText: AppStrings.back, ontap: onBack),
        ],
      ),
    );
  }
}
