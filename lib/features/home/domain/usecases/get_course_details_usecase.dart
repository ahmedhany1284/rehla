import 'package:dartz/dartz.dart';
import 'package:rehla/core/error/failure.dart';
import 'package:rehla/core/usecase/base_usecase.dart';
import 'package:rehla/features/home/domain/entities/course.dart';
import 'package:rehla/features/home/domain/repositories/course_repository.dart';
import 'package:rehla/features/home/domain/rules/progress_rules.dart';

class GetCourseDetailsUseCase extends BaseUseCase<CourseDetails, String> {
  GetCourseDetailsUseCase(this.repository);

  final CourseRepository repository;

  @override
  Future<Either<Failure, CourseDetails>> call(String courseId) async {
    final result = await repository.getCourseById(courseId);
    return result.map((lookup) {
      final course = lookup.course;
      final progress = lookup.progress;
      final lessonIds = course.lessons.map((lesson) => lesson.id).toList();
      final completedIds = progress.entries
          .where((entry) => entry.value.completed)
          .map((entry) => entry.key)
          .toSet();
      var index = 0;
      final sections = course.sections.map((section) {
        final lessons = section.lessons.map((lesson) {
          final record = progress[lesson.id];
          final status = _status(record);
          final unlocked = isUnlocked(
            index: index,
            lessonIds: lessonIds,
            completedIds: completedIds,
          );
          index++;
          return LessonDetails(
            lesson: lesson,
            status: status,
            unlocked: unlocked,
          );
        }).toList();
        return SectionDetails(section: section, lessons: lessons);
      }).toList();
      return CourseDetails(course: course, sections: sections);
    });
  }

  LessonStatus _status(LessonProgress? record) {
    if (record == null) return LessonStatus.notStarted;
    if (record.completed) return LessonStatus.completed;
    if (record.positionSec > 0) return LessonStatus.inProgress;
    return LessonStatus.notStarted;
  }
}
