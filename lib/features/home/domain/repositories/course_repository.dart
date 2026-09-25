import 'package:dartz/dartz.dart';
import 'package:rehla/core/error/failure.dart';
import 'package:rehla/features/home/domain/entities/course.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<CourseSummary>>> getCourses();

  Future<Either<Failure, ContinueWatching?>> getContinueWatching();

  Future<
    Either<Failure, ({Course course, Map<String, LessonProgress> progress})>
  >
  getCourseById(String courseId);
}
