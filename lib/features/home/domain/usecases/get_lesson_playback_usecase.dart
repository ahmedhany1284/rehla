import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rehla/core/error/failure.dart';
import 'package:rehla/core/usecase/base_usecase.dart';
import 'package:rehla/features/home/domain/entities/course.dart';
import 'package:rehla/features/home/domain/repositories/course_repository.dart';

class LessonRequest extends Equatable {
  const LessonRequest({required this.courseId, required this.lessonId});

  final String courseId;
  final String lessonId;

  @override
  List<Object> get props => [courseId, lessonId];
}

class LessonPlayback extends Equatable {
  const LessonPlayback({
    required this.lesson,
    required this.lessons,
    required this.instructor,
    this.progress,
  });

  final Lesson lesson;
  final List<Lesson> lessons;
  final LocalizedString instructor;
  final LessonProgress? progress;

  @override
  List<Object?> get props => [lesson, lessons, instructor, progress];
}

class GetLessonPlaybackUseCase extends BaseUseCase<LessonPlayback, LessonRequest> {
  GetLessonPlaybackUseCase(this.repository);

  final CourseRepository repository;

  @override
  Future<Either<Failure, LessonPlayback>> call(LessonRequest params) async {
    final result = await repository.getCourseById(params.courseId);
    return result.fold(Left.new, (lookup) {
      for (final lesson in lookup.course.lessons) {
        if (lesson.id == params.lessonId) {
          return Right(
            LessonPlayback(
              lesson: lesson,
              lessons: lookup.course.lessons,
              instructor: lookup.course.instructor,
              progress: lookup.progress[lesson.id],
            ),
          );
        }
      }
      return const Left(CacheFailure());
    });
  }
}
