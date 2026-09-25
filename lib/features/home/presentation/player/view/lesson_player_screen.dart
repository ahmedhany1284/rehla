import 'dart:async';

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
import 'package:rehla/features/home/presentation/view/extensions/localized_string.dart';
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
  bool _controlsVisible = true;
  Timer? _hideTimer;

  Future<void> _toggleFullscreen() async {
    final next = !_fullscreen;
    setState(() {
      _fullscreen = next;
      _controlsVisible = true;
    });
    _scheduleHide();
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

  void _onVideoTap() {
    if (!_fullscreen) return;
    setState(() => _controlsVisible = !_controlsVisible);
    _scheduleHide();
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    if (!_fullscreen || !_controlsVisible) return;
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _controlsVisible = false);
    });
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
    _hideTimer?.cancel();
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
                  : AppCustomAppBar(
                      title: state.title.localized(context).isEmpty
                          ? AppStrings.lesson
                          : state.title.localized(context),
                    ),
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
                    if (_fullscreen)
                      Expanded(
                        child: ColoredBox(
                          color: AppColors.mainBlack900,
                          child: _FittedVideo(
                            controller: video,
                            audioOnly: state.audioOnly,
                            onTap: _onVideoTap,
                            controls: _controlsVisible
                                ? PlayerControls(
                                    fullscreen: true,
                                    onFullscreen: _toggleFullscreen,
                                    onInteraction: _scheduleHide,
                                  )
                                : null,
                          ),
                        ),
                      )
                    else
                      ColoredBox(
                        color: AppColors.mainBlack900,
                        child: _FittedVideo(
                          controller: video,
                          audioOnly: state.audioOnly,
                          onTap: _onVideoTap,
                          controls: PlayerControls(
                            fullscreen: false,
                            onFullscreen: _toggleFullscreen,
                          ),
                        ),
                      ),
                    if (!_fullscreen)
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                          children: [
                            Text(
                              state.title.localized(context),
                              style: AppTextStyle.semiBold16,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.instructor.localized(context),
                              style: AppTextStyle.regular14,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.description.localized(context),
                              style: AppTextStyle.regular14,
                            ),
                            if (state.hasNext) ...[
                              const SizedBox(height: 24),
                              AppDefaultButton(
                                buttonText: AppStrings.nextLesson,
                                ontap: state.nextUnlocked
                                    ? () => _openNext(context, state)
                                    : null,
                              ),
                            ],
                          ],
                        ),
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

class _FittedVideo extends StatelessWidget {
  const _FittedVideo({
    required this.controller,
    required this.audioOnly,
    required this.onTap,
    required this.controls,
  });

  final VideoPlayerController? controller;
  final bool audioOnly;
  final VoidCallback onTap;
  final Widget? controls;

  @override
  Widget build(BuildContext context) {
    final video = controller;
    final ready = video != null && video.value.isInitialized;
    final aspect = ready && video.value.aspectRatio > 0
        ? video.value.aspectRatio
        : 16 / 9;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final bounded = constraints.maxHeight.isFinite;
        final maxHeight = bounded ? constraints.maxHeight : maxWidth / aspect;
        var width = maxWidth;
        var height = width / aspect;
        if (height > maxHeight) {
          height = maxHeight;
          width = height * aspect;
        }
        return GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: maxWidth,
            height: maxHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: width,
                  height: height,
                  child: ready ? VideoPlayer(video) : const SizedBox.shrink(),
                ),
                if (audioOnly)
                  Icon(
                    Icons.graphic_eq,
                    color: AppColors.whiteConstant,
                    size: 64,
                  ),
                if (controls != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: controls!,
                  ),
              ],
            ),
          ),
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
