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

  void _enterFullscreen() {
    if (_fullscreen) return;
    _toggleFullscreen();
  }

  void _onCenterTap() {
    context.read<PlayerCubit>().togglePlay();
    if (!_fullscreen || _controlsVisible) return;
    setState(() => _controlsVisible = true);
    _scheduleHide();
  }

  void _onSideTap() {
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
                _ => LayoutBuilder(
                  builder: (context, constraints) {
                    final aspect =
                        video != null &&
                            video.value.isInitialized &&
                            video.value.aspectRatio > 0
                        ? video.value.aspectRatio
                        : 16 / 9;
                    final natural = constraints.maxWidth / aspect;
                    final videoHeight = natural > constraints.maxHeight * 0.7
                        ? constraints.maxHeight * 0.7
                        : natural;
                    return Column(
                  children: [
                    if (_fullscreen)
                      Expanded(
                        child: ColoredBox(
                          color: AppColors.mainBlack900,
                          child: _FittedVideo(
                            controller: video,
                            audioOnly: state.audioOnly,
                            fullscreen: true,
                            onCenterTap: _onCenterTap,
                            onSideTap: _onSideTap,
                            onEnterFullscreen: _enterFullscreen,
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
                      SizedBox(
                        height: videoHeight,
                        child: ColoredBox(
                        color: AppColors.mainBlack900,
                        child: _FittedVideo(
                          controller: video,
                          audioOnly: state.audioOnly,
                          fullscreen: false,
                          onCenterTap: _onCenterTap,
                          onSideTap: _onSideTap,
                          onEnterFullscreen: _enterFullscreen,
                          controls: PlayerControls(
                            fullscreen: false,
                            onFullscreen: _toggleFullscreen,
                          ),
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
                    );
                  },
                ),
              },
            );
          },
        );
      },
    );
  }
}

class _FittedVideo extends StatefulWidget {
  const _FittedVideo({
    required this.controller,
    required this.audioOnly,
    required this.fullscreen,
    required this.onCenterTap,
    required this.onSideTap,
    required this.onEnterFullscreen,
    required this.controls,
  });

  final VideoPlayerController? controller;
  final bool audioOnly;
  final bool fullscreen;
  final VoidCallback onCenterTap;
  final VoidCallback onSideTap;
  final VoidCallback onEnterFullscreen;
  final Widget? controls;

  @override
  State<_FittedVideo> createState() => _FittedVideoState();
}

class _FittedVideoState extends State<_FittedVideo> {
  double _downX = 0;
  double _dragX = 0;
  double _dragY = 0;
  int? _flashSide;
  bool _flashBackward = true;
  int _flashToken = 0;

  void _onDoubleTap(double width) {
    const edge = 0.35;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final onStart = rtl
        ? _downX > width * (1 - edge)
        : _downX < width * edge;
    final onEnd = rtl ? _downX < width * edge : _downX > width * (1 - edge);
    if (!onStart && !onEnd) {
      widget.onCenterTap();
      return;
    }
    context.read<PlayerCubit>().seekBy(
      Duration(seconds: onStart ? -5 : 5),
    );
    setState(() {
      _flashSide = _downX < width / 2 ? -1 : 1;
      _flashBackward = onStart;
      _flashToken++;
    });
  }

  void _onTap(double width) {
    const edge = 0.35;
    final center = _downX >= width * edge && _downX <= width * (1 - edge);
    if (center) {
      widget.onCenterTap();
      return;
    }
    widget.onSideTap();
  }

  void _onSwipeEnd(DragEndDetails _) {
    const distance = 48.0;
    final upward = _dragY < -distance;
    final mostlyVertical = _dragY.abs() > _dragX.abs();
    if (upward && mostlyVertical) {
      widget.onEnterFullscreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.controller;
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
        return SizedBox(
          width: maxWidth,
          height: maxHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) => _downX = details.localPosition.dx,
                onDoubleTapDown: (details) =>
                    _downX = details.localPosition.dx,
                onDoubleTap: () => _onDoubleTap(width),
                onTap: () => _onTap(width),
                onVerticalDragStart: (_) {
                  _dragX = 0;
                  _dragY = 0;
                },
                onVerticalDragUpdate: (details) {
                  _dragX += details.delta.dx;
                  _dragY += details.delta.dy;
                },
                onVerticalDragEnd: _onSwipeEnd,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: ready ? VideoPlayer(video) : const SizedBox.shrink(),
                ),
              ),
              if (widget.audioOnly)
                IgnorePointer(
                  child: Icon(
                    Icons.graphic_eq,
                    color: AppColors.whiteConstant,
                    size: 64,
                  ),
                ),
              if (_flashSide != null)
                IgnorePointer(
                  child: Align(
                    alignment: _flashSide! < 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      child: _SeekFlash(
                        key: ValueKey(_flashToken),
                        backward: _flashBackward,
                        onDone: () {
                          if (mounted) setState(() => _flashSide = null);
                        },
                      ),
                    ),
                  ),
                ),
              if (widget.controls != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: widget.controls!,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SeekFlash extends StatefulWidget {
  const _SeekFlash({super.key, required this.backward, required this.onDone});

  final bool backward;
  final VoidCallback onDone;

  @override
  State<_SeekFlash> createState() => _SeekFlashState();
}

class _SeekFlashState extends State<_SeekFlash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward().whenComplete(() {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 1, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: ReverseAnimation(fade),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.mainBlack900.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.backward) ...[
                  Icon(Icons.replay, color: AppColors.whiteConstant, size: 18),
                  const SizedBox(width: 6),
                ],
                Text(
                  AppStrings.seekSeconds,
                  style: AppTextStyle.regular14.copyWith(
                    color: AppColors.whiteConstant,
                  ),
                ),
                if (!widget.backward) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.forward,
                    color: AppColors.whiteConstant,
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
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
