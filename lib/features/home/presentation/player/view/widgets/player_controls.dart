import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/presentation/view/widgets/app_custom_bottom_sheet.dart';
import 'package:rehla/core/presentation/view/widgets/main_button.dart';
import 'package:rehla/core/presentation/view/widgets/radio_option.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/app_text_style.dart';
import 'package:rehla/core/utils/app_strings.dart';
import 'package:rehla/features/home/presentation/player/view-model/player_cubit.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.onFullscreen,
    required this.onNext,
  });

  final VoidCallback onFullscreen;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
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
            Slider(
              value: fraction,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.shimmerBase,
              onChanged: (value) => cubit.seekToFraction(value),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(_clock(state.position), style: AppTextStyle.regular14),
                  const Spacer(),
                  Text(_clock(state.duration), style: AppTextStyle.regular14),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: cubit.togglePlay,
                  icon: Icon(
                    state.status == PlayerStatus.playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: AppColors.primary,
                    size: 56,
                  ),
                ),
                IconButton(
                  onPressed: () => _openSpeed(context, state.speed),
                  icon: Icon(Icons.speed, color: AppColors.label),
                ),
                IconButton(
                  onPressed: onFullscreen,
                  icon: Icon(Icons.fullscreen, color: AppColors.label),
                ),
              ],
            ),
            if (state.hasNext)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: AppDefaultButton(
                  buttonText: AppStrings.nextLesson,
                  ontap: state.nextUnlocked ? onNext : null,
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
                  label: speed == speed.roundToDouble()
                      ? '${speed.toInt()}x'
                      : '${speed}x',
                  selected: selected == speed,
                  onTap: () => setSheetState(() => selected = speed),
                ),
            ],
          );
        },
      ),
    );
  }

  String _clock(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
