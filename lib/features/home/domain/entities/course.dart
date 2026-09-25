import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  const Lesson({
    required this.id,
    required this.title,
    required this.durationSec,
    required this.video,
  });

  final String id;
  final String title;
  final int durationSec;
  final String video;

  @override
  List<Object> get props => [id, title, durationSec, video];
}

class Section extends Equatable {
  const Section({
    required this.id,
    required this.title,
    required this.lessons,
  });

  final String id;
  final String title;
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
  final String title;
  final String instructor;
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
  const CourseSummary({
    required this.course,
    required this.progressPercent,
  });

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

class HomeData extends Equatable {
  const HomeData({
    required this.courses,
    this.continueWatching,
  });

  final List<CourseSummary> courses;
  final ContinueWatching? continueWatching;

  @override
  List<Object?> get props => [courses, continueWatching];
}
