import 'package:equatable/equatable.dart';

class LocalizedString extends Equatable {
  const LocalizedString({required this.ar, required this.en});

  final String ar;
  final String en;

  @override
  List<Object> get props => [ar, en];
}

class Lesson extends Equatable {
  const Lesson({
    required this.id,
    required this.title,
    required this.durationSec,
    required this.video,
  });

  final String id;
  final LocalizedString title;
  final int durationSec;
  final String video;

  @override
  List<Object> get props => [id, title, durationSec, video];
}

class Section extends Equatable {
  const Section({required this.id, required this.title, required this.lessons});

  final String id;
  final LocalizedString title;
  final List<Lesson> lessons;

  @override
  List<Object> get props => [id, title, lessons];
}

class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.thumbnail,
    required this.sections,
  });

  final String id;
  final LocalizedString title;
  final LocalizedString instructor;
  final String thumbnail;
  final List<Section> sections;

  int get lessonCount =>
      sections.fold(0, (count, section) => count + section.lessons.length);

  List<Lesson> get lessons =>
      sections.expand((section) => section.lessons).toList();

  @override
  List<Object> get props => [id, title, instructor, thumbnail, sections];
}

class CourseSummary extends Equatable {
  const CourseSummary({required this.course, required this.progressPercent});

  final Course course;
  final double progressPercent;

  @override
  List<Object> get props => [course, progressPercent];
}

class ContinueWatching extends Equatable {
  const ContinueWatching({
    required this.course,
    required this.lesson,
    required this.progressPercent,
  });

  final Course course;
  final Lesson lesson;
  final double progressPercent;

  @override
  List<Object> get props => [course, lesson, progressPercent];
}

class LessonProgress extends Equatable {
  const LessonProgress({required this.positionSec, required this.completed});

  final int positionSec;
  final bool completed;

  @override
  List<Object> get props => [positionSec, completed];
}

enum LessonStatus { notStarted, inProgress, completed }

class LessonDetails extends Equatable {
  const LessonDetails({
    required this.lesson,
    required this.status,
    required this.unlocked,
  });

  final Lesson lesson;
  final LessonStatus status;
  final bool unlocked;

  @override
  List<Object> get props => [lesson, status, unlocked];
}

class SectionDetails extends Equatable {
  const SectionDetails({required this.section, required this.lessons});

  final Section section;
  final List<LessonDetails> lessons;

  @override
  List<Object> get props => [section, lessons];
}

class CourseDetails extends Equatable {
  const CourseDetails({required this.course, required this.sections});

  final Course course;
  final List<SectionDetails> sections;

  @override
  List<Object> get props => [course, sections];
}

class HomeData extends Equatable {
  const HomeData({required this.courses, this.continueWatching});

  final List<CourseSummary> courses;
  final ContinueWatching? continueWatching;

  @override
  List<Object?> get props => [courses, continueWatching];
}
