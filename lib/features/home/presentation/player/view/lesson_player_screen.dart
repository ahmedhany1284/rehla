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

class _LessonPlayerScreenState extends State<LessonPlayerScreen>
    with SingleTickerProviderStateMixin {
  bool _fullscreen = false;
  bool _controlsVisible = true;
  Timer? _hideTimer;
  double _pull = 0;
  late final AnimationController _pullAnim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  );
  Animation<double>? _pullTween;

  @override
  void initState() {
    super.initState();
    _pullAnim.addListener(() {
      final tween = _pullTween;
      if (tween == null || !mounted) return;
      setState(() => _pull = tween.value);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleHide());
  }

  void _onPull(double value) {
    _pullAnim.stop();
    _pullTween = null;
    setState(() => _pull = value.clamp(0, 1));
  }

  void _onPullEnd(bool commit) {
    if (_fullscreen) return;
    if (commit) {
      _pullAnim.stop();
      _pullTween = null;
      setState(() => _pull = 0);
      _enterFullscreen();
      return;
    }
    _pullTween = Tween<double>(begin: _pull, end: 0).animate(
      CurvedAnimation(parent: _pullAnim, curve: Curves.easeOut),
    );
    _pullAnim.forward(from: 0);
  }

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
    if (!_controlsVisible) {
      setState(() => _controlsVisible = true);
    }
    _scheduleHide();
  }

  void _onSideTap() {
    setState(() => _controlsVisible = !_controlsVisible);
    _scheduleHide();
  }

  void _onBack() {
    if (_fullscreen) {
      _toggleFullscreen();
      return;
    }
    context.pop();
  }

  void _exitFullscreen() {
    if (!_fullscreen) return;
    _toggleFullscreen();
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    if (!_controlsVisible) return;
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
    _pullAnim.dispose();
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
            final playing =
                state.status != PlayerStatus.loading &&
                state.status != PlayerStatus.error;
            final title = state.title.localized(context).isEmpty
                ? AppStrings.lesson
                : state.title.localized(context);
            final topBar = _controlsVisible
                ? _PlayerNavBar(title: title, onBack: _onBack)
                : null;
            final bottomBar = _controlsVisible
                ? PlayerControls(
                    fullscreen: _fullscreen,
                    onFullscreen: _toggleFullscreen,
                    onInteraction: _scheduleHide,
                  )
                : null;
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: _fullscreen || playing
                  ? null
                  : PreferredSize(
                      preferredSize: Size.fromHeight(
                        kToolbarHeight * (1 - _pull),
                      ),
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          heightFactor: (1 - _pull).clamp(0, 1),
                          child: AppCustomAppBar(title: title),
                        ),
                      ),
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
                    final resting = natural > constraints.maxHeight * 0.7
                        ? constraints.maxHeight * 0.7
                        : natural;
                    final videoHeight =
                        resting + (constraints.maxHeight - resting) * _pull;
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
                            onExitFullscreen: _exitFullscreen,
                            topBar: topBar,
                            controls: bottomBar,
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
                            onPull: _onPull,
                            onPullEnd: _onPullEnd,
                            topBar: topBar,
                            controls: bottomBar,
                        ),
                      ),
                      ),
                    if (!_fullscreen)
                      Expanded(
                        child: Opacity(
                          opacity: (1 - _pull).clamp(0, 1),
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
    this.onExitFullscreen,
    this.onPull,
    this.onPullEnd,
    this.topBar,
    required this.controls,
  });

  final VideoPlayerController? controller;
  final bool audioOnly;
  final bool fullscreen;
  final VoidCallback onCenterTap;
  final VoidCallback onSideTap;
  final VoidCallback onEnterFullscreen;
  final VoidCallback? onExitFullscreen;
  final ValueChanged<double>? onPull;
  final ValueChanged<bool>? onPullEnd;
  final Widget? topBar;
  final Widget? controls;

  @override
  State<_FittedVideo> createState() => _FittedVideoState();
}

class _FittedVideoState extends State<_FittedVideo> {
  double _downX = 0;
  double _dragX = 0;
  double _dragY = 0;
  double _originY = 0;
  double _lastY = 0;
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
    if (widget.fullscreen) {
      final downward = _dragY > 64 && _dragY.abs() > _dragX.abs();
      if (downward) widget.onExitFullscreen?.call();
      return;
    }
    final mostlyVertical = _dragY.abs() > _dragX.abs() && _dragY < -24;
    final reachedTop = _lastY < 48;
    widget.onPullEnd?.call(mostlyVertical && reachedTop);
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
                onVerticalDragStart: (details) {
                  _dragX = 0;
                  _dragY = 0;
                  _originY = details.globalPosition.dy;
                  _lastY = _originY;
                },
                onVerticalDragUpdate: (details) {
                  _dragX += details.delta.dx;
                  _dragY += details.delta.dy;
                  _lastY = details.globalPosition.dy;
                  if (widget.fullscreen) return;
                  if (_dragY < -8 && _dragY.abs() > _dragX.abs()) {
                    final needed = _originY < 1 ? 1.0 : _originY;
                    widget.onPull?.call((-_dragY / needed).clamp(0.0, 1.0));
                  }
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
              if (widget.topBar != null)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: widget.topBar!,
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

class _PlayerNavBar extends StatelessWidget {
  const _PlayerNavBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.mainBlack900.withValues(alpha: 0.82),
            AppColors.transparent,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: top),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              iconSize: 26,
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: Icon(Icons.arrow_back, color: AppColors.whiteConstant),
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.semiBold16.copyWith(
                  color: AppColors.whiteConstant,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
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
