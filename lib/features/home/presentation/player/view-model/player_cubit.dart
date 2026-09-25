import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:rehla/features/home/domain/entities/course.dart';
import 'package:rehla/features/home/domain/rules/progress_rules.dart';
import 'package:rehla/features/home/domain/usecases/get_lesson_playback_usecase.dart';
import 'package:rehla/features/home/domain/usecases/save_lesson_progress_usecase.dart';

part 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit(this._getLessonPlayback, this._saveLessonProgress)
    : super(const PlayerState());

  final GetLessonPlaybackUseCase _getLessonPlayback;
  final SaveLessonProgressUseCase _saveLessonProgress;

  VideoPlayerController? controller;
  DateTime? _lastSave;
  bool _completed = false;
  String _lessonId = '';
  List<Lesson> _lessons = const [];

  Future<void> load({
    required String courseId,
    required String lessonId,
  }) async {
    await _disposeController();
    _lessonId = lessonId;
    _completed = false;
    _lastSave = null;
    emit(const PlayerState(status: PlayerStatus.loading));
    final result = await _getLessonPlayback(
      LessonRequest(courseId: courseId, lessonId: lessonId),
    );
    await result.fold(
      (failure) async {
        emit(state.copyWith(status: PlayerStatus.error));
      },
      (playback) async {
        if (playback.lesson.video.isEmpty) {
          emit(state.copyWith(status: PlayerStatus.error));
          return;
        }
        _lessons = playback.lessons;
        _completed = playback.progress?.completed ?? false;
        emit(
          state.copyWith(
            title: playback.lesson.title,
            description: playback.lesson.description,
            instructor: playback.instructor,
          ),
        );
        final video = VideoPlayerController.asset(playback.lesson.video);
        controller = video;
        try {
          await video.initialize();
          if (video.value.hasError) {
            await _disposeController();
            emit(state.copyWith(status: PlayerStatus.error));
            return;
          }
          await video.setVolume(1);
          video.addListener(_onTick);
          final saved = playback.progress?.positionSec ?? 0;
          if (!_completed && saved > 0) {
            await video.seekTo(Duration(seconds: saved));
          }
          _emitFromController(PlayerStatus.ready);
        } catch (_) {
          await _disposeController();
          emit(state.copyWith(status: PlayerStatus.error));
        }
      },
    );
  }

  Future<void> togglePlay() async {
    final video = controller;
    if (video == null || !video.value.isInitialized) return;
    if (video.value.isPlaying) {
      await video.pause();
      await _save(force: true);
      _emitFromController(PlayerStatus.paused);
      return;
    }
    await video.setVolume(state.muted ? 0 : 1);
    await video.play();
    _emitFromController(PlayerStatus.playing);
  }

  Future<void> seekToFraction(double fraction) async {
    final video = controller;
    if (video == null || !video.value.isInitialized) return;
    final target = video.value.duration * fraction.clamp(0, 1);
    await video.seekTo(target);
    _emitFromController(
      video.value.isPlaying ? PlayerStatus.playing : PlayerStatus.paused,
    );
  }

  Future<void> toggleMute() async {
    final video = controller;
    if (video == null) return;
    final muted = !state.muted;
    await video.setVolume(muted ? 0 : 1);
    emit(state.copyWith(muted: muted));
  }

  Future<void> setSpeed(double speed) async {
    await controller?.setPlaybackSpeed(speed);
    emit(state.copyWith(speed: speed));
  }

  String? nextLessonId() {
    final index = _lessons.indexWhere((lesson) => lesson.id == _lessonId);
    if (index < 0 || index + 1 >= _lessons.length) return null;
    final ids = _lessons.map((lesson) => lesson.id).toList();
    final unlocked = isUnlocked(
      index: index + 1,
      lessonIds: ids,
      completedIds: _completed ? {_lessonId} : {},
    );
    if (!unlocked) return '';
    return _lessons[index + 1].id;
  }

  void _onTick() {
    final video = controller;
    if (video == null || !video.value.isInitialized || isClosed) return;
    if (video.value.hasError) {
      emit(state.copyWith(status: PlayerStatus.error));
      return;
    }
    final positionMs = video.value.position.inMilliseconds;
    final durationMs = video.value.duration.inMilliseconds;
    if (!_completed &&
        isCompleted(positionMs: positionMs, durationMs: durationMs)) {
      _completed = true;
      _save(force: true);
    } else if (video.value.isPlaying) {
      _save();
    }
    _emitFromController(
      video.value.isPlaying ? PlayerStatus.playing : state.status,
    );
  }

  void _emitFromController(PlayerStatus status) {
    final video = controller;
    if (video == null || isClosed) return;
    final next = nextLessonId();
    emit(
      state.copyWith(
        status: status == PlayerStatus.playing && !video.value.isPlaying
            ? PlayerStatus.paused
            : status,
        position: video.value.position,
        duration: video.value.duration,
        completed: _completed,
        hasNext: next != null,
        nextUnlocked: next != null && next.isNotEmpty,
        nextLessonId: next ?? '',
        audioOnly: video.value.size == Size.zero,
      ),
    );
  }

  Future<void> _save({bool force = false}) async {
    final video = controller;
    if (video == null || !video.value.isInitialized || _lessonId.isEmpty) {
      return;
    }
    final now = DateTime.now();
    if (!force &&
        _lastSave != null &&
        now.difference(_lastSave!) < const Duration(seconds: 5)) {
      return;
    }
    _lastSave = now;
    await _saveLessonProgress(
      SaveProgressParams(
        lessonId: _lessonId,
        positionSec: video.value.position.inSeconds,
        completed: _completed,
      ),
    );
  }

  Future<void> _disposeController() async {
    final video = controller;
    controller = null;
    if (video == null) return;
    video.removeListener(_onTick);
    await video.dispose();
  }

  @override
  Future<void> close() async {
    await _save(force: true);
    await _disposeController();
    return super.close();
  }
}
