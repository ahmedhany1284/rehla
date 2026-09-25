import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/presentation/view/widgets/app_custom_bottom_sheet.dart';
import 'package:rehla/core/presentation/view/widgets/radio_option.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/app_text_style.dart';
import 'package:rehla/core/utils/app_strings.dart';
import 'package:rehla/features/home/presentation/player/view-model/player_cubit.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.onFullscreen,
    required this.fullscreen,
    this.onInteraction,
  });

  final VoidCallback onFullscreen;
  final bool fullscreen;
  final VoidCallback? onInteraction;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return BlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) {
        final cubit = context.read<PlayerCubit>();
        final total = state.duration.inMilliseconds;
        final fraction = total == 0
            ? 0.0
            : (state.position.inMilliseconds / total).clamp(0.0, 1.0);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IgnorePointer(
              child: SizedBox(
                height: 36,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.transparent,
                        AppColors.mainBlack900.withValues(alpha: 0.82),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ColoredBox(
              color: AppColors.mainBlack900.withValues(alpha: 0.82),
              child: Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8 + bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 7,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 16,
                    ),
                    activeTrackColor: AppColors.whiteConstant,
                    inactiveTrackColor: AppColors.whiteConstant.withValues(
                      alpha: 0.35,
                    ),
                    thumbColor: AppColors.whiteConstant,
                    overlayColor: AppColors.whiteConstant.withValues(
                      alpha: 0.2,
                    ),
                  ),
                  child: Slider(
                    value: fraction,
                    onChanged: (value) {
                      onInteraction?.call();
                      cubit.seekToFraction(value);
                    },
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${_clock(state.position)} / ${_clock(state.duration)}',
                      textDirection: TextDirection.ltr,
                      style: AppTextStyle.regular14.copyWith(
                        color: AppColors.whiteConstant,
                      ),
                    ),
                    const Spacer(),
                    _Action(
                      onPressed: () {
                        onInteraction?.call();
                        cubit.togglePlay();
                      },
                      icon: state.status == PlayerStatus.playing
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    _Action(
                      onPressed: () {
                        onInteraction?.call();
                        cubit.toggleMute();
                      },
                      icon: state.muted ? Icons.volume_off : Icons.volume_up,
                    ),
                    _SpeedButton(
                      label: _speedLabel(state.speed),
                      onPressed: () {
                        onInteraction?.call();
                        _openSpeed(context, state.speed);
                      },
                    ),
                    _Action(
                      onPressed: () {
                        onInteraction?.call();
                        onFullscreen();
                      },
                      icon: fullscreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                    ),
                  ],
                ),
              ],
            ),
          ),
            ),
          ],
        );
      },
    );
  }

  void _openSpeed(BuildContext context, double current) {
    final cubit = context.read<PlayerCubit>();
    var selected = current;
    AppCustomBottomSheet.show(
      context: context,
      title: AppStrings.playbackSpeed,
      actionText: AppStrings.apply,
      onAction: () {
        cubit.setSpeed(selected);
        Navigator.of(context).pop();
      },
      child: StatefulBuilder(
        builder: (context, setSheetState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final speed in const [1.0, 1.25, 1.5, 2.0])
                RadioOption(
                  label: _speedLabel(speed),
                  selected: selected == speed,
                  onTap: () => setSheetState(() => selected = speed),
                ),
            ],
          );
        },
      ),
    );
  }

  String _speedLabel(double speed) {
    return speed == speed.roundToDouble() ? '${speed.toInt()}x' : '${speed}x';
  }

  String _clock(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.onPressed, required this.icon});

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 26,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      icon: Icon(icon, color: AppColors.whiteConstant),
    );
  }
}

class _SpeedButton extends StatelessWidget {
  const _SpeedButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.whiteConstant,
        minimumSize: const Size(48, 48),
      ),
      child: Text(label, style: AppTextStyle.regular14.copyWith(
        color: AppColors.whiteConstant,
      )),
    );
  }
}
