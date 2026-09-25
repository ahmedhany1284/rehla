part of 'player_cubit.dart';

enum PlayerStatus { loading, ready, playing, paused, error }

const _undefined = Object();

class PlayerState extends Equatable {
  const PlayerState({
    this.status = PlayerStatus.loading,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.speed = 1,
    this.completed = false,
    this.hasNext = false,
    this.nextUnlocked = false,
    this.nextLessonId = '',
  });

  final PlayerStatus status;
  final Duration position;
  final Duration duration;
  final double speed;
  final bool completed;
  final bool hasNext;
  final bool nextUnlocked;
  final String nextLessonId;

  PlayerState copyWith({
    PlayerStatus? status,
    Duration? position,
    Duration? duration,
    double? speed,
    bool? completed,
    bool? hasNext,
    bool? nextUnlocked,
    Object? nextLessonId = _undefined,
  }) {
    return PlayerState(
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
      completed: completed ?? this.completed,
      hasNext: hasNext ?? this.hasNext,
      nextUnlocked: nextUnlocked ?? this.nextUnlocked,
      nextLessonId: identical(nextLessonId, _undefined)
          ? this.nextLessonId
          : nextLessonId as String,
    );
  }

  @override
  List<Object?> get props => [
    status,
    position,
    duration,
    speed,
    completed,
    hasNext,
    nextUnlocked,
    nextLessonId,
  ];
}
