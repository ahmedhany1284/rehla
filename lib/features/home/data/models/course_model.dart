import 'package:rehla/features/home/domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.instructor,
    required super.thumbnail,
    required super.sections,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final sections = (json['sections'] as List<dynamic>? ?? [])
        .map((section) => SectionModel.fromJson(section as Map<String, dynamic>))
        .toList();
    return CourseModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      instructor: json['instructor'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      sections: sections,
    );
  }
}

class SectionModel extends Section {
  const SectionModel({
    required super.id,
    required super.title,
    required super.lessons,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    final lessons = (json['lessons'] as List<dynamic>? ?? [])
        .map((lesson) => LessonModel.fromJson(lesson as Map<String, dynamic>))
        .toList();
    return SectionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      lessons: lessons,
    );
  }
}

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.title,
    required super.durationSec,
    required super.video,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      durationSec: json['durationSec'] as int? ?? 0,
      video: json['video'] as String? ?? '',
    );
  }
}
