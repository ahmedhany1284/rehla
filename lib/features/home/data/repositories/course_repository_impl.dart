import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rehla/core/data/local_data/caching_helper.dart';
import 'package:rehla/core/error/failure.dart';
import 'package:rehla/features/home/data/datasources/course_local_datasource.dart';
import 'package:rehla/features/home/data/models/course_model.dart';
import 'package:rehla/features/home/domain/entities/course.dart';
import 'package:rehla/features/home/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  CourseRepositoryImpl(this.localDataSource);

  final CourseLocalDataSource localDataSource;

  List<CourseModel>? _cachedCourses;

  @override
  Future<Either<Failure, List<CourseSummary>>> getCourses() async {
    try {
      final courses = await _loadCourses();
      final progress = _readLessonProgress();
      return Right(
        courses
            .map(
              (course) => CourseSummary(
                course: course,
                progressPercent: _courseProgress(course, progress),
              ),
            )
            .toList(),
      );
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ContinueWatching?>> getContinueWatching() async {
    try {
      final courses = await _loadCourses();
      final progress = _readLessonProgress();
      for (final course in courses) {
        for (final lesson in course.lessons) {
          final record = progress[lesson.id];
          if (record == null || record.completed || record.positionSec <= 0) {
            continue;
          }
          return Right(
            ContinueWatching(
              course: course,
              lesson: lesson,
              progressPercent: _courseProgress(course, progress),
            ),
          );
        }
      }
      return const Right(null);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  Future<List<CourseModel>> _loadCourses() async {
    final cached = _cachedCourses;
    if (cached != null) return cached;

    await Future<void>.delayed(const Duration(milliseconds: 400));
    final courses = await localDataSource.readCourses();
    _cachedCourses = courses;
    return courses;
  }

  Map<String, _LessonProgress> _readLessonProgress() {
    try {
      final raw = AppCacheHelper.getCacheString(
        key: AppCacheHelper.lessonProgress,
      );
      if (raw.isEmpty) return {};
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return {};
      return decoded.map((id, value) {
        final map = value as Map<String, dynamic>;
        return MapEntry(
          id,
          _LessonProgress(
            positionSec: (map['positionSec'] as num?)?.toInt() ?? 0,
            completed: map['completed'] as bool? ?? false,
          ),
        );
      });
    } catch (_) {
      return {};
    }
  }

  double _courseProgress(Course course, Map<String, _LessonProgress> progress) {
    final total = course.lessonCount;
    if (total == 0) return 0;
    final completed = course.lessons
        .where((lesson) => progress[lesson.id]?.completed ?? false)
        .length;
    return (completed / total) * 100;
  }
}

class _LessonProgress {
  const _LessonProgress({
    required this.positionSec,
    required this.completed,
  });

  final int positionSec;
  final bool completed;
}
