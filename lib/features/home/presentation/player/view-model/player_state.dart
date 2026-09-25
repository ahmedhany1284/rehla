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
    this.title = const LocalizedString(ar: '', en: ''),
    this.description = const LocalizedString(ar: '', en: ''),
    this.instructor = const LocalizedString(ar: '', en: ''),
    this.muted = false,
    this.audioOnly = false,
  });

  final PlayerStatus status;
  final Duration position;
  final Duration duration;
  final double speed;
  final bool completed;
  final bool hasNext;
  final bool nextUnlocked;
  final String nextLessonId;
  final LocalizedString title;
  final LocalizedString description;
  final LocalizedString instructor;
  final bool muted;
  final bool audioOnly;

  PlayerState copyWith({
    PlayerStatus? status,
    Duration? position,
    Duration? duration,
    double? speed,
    bool? completed,
    bool? hasNext,
    bool? nextUnlocked,
    Object? nextLessonId = _undefined,
    LocalizedString? title,
    LocalizedString? description,
    LocalizedString? instructor,
    bool? muted,
    bool? audioOnly,
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
      title: title ?? this.title,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      muted: muted ?? this.muted,
      audioOnly: audioOnly ?? this.audioOnly,
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
    title,
    description,
    instructor,
    muted,
    audioOnly,
  ];
}
