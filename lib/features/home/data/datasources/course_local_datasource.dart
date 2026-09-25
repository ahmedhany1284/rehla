import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rehla/features/home/data/models/course_model.dart';
import 'package:rehla/generated/assets.dart';

class CourseLocalDataSource {
  Future<List<CourseModel>> readCourses() async {
    final raw = await rootBundle.loadString(AssetData.coursesJson);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final courses = decoded['courses'] as List<dynamic>? ?? [];
    return courses
        .map((course) => CourseModel.fromJson(course as Map<String, dynamic>))
        .toList();
  }
}
