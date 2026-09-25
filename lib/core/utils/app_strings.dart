import 'package:easy_localization/easy_localization.dart';

class AppStrings {
  static String get appName => 'app_name'.tr();

  static String get homeTitle => 'home_title'.tr();

  static String get continueWatching => 'continue_watching'.tr();

  static String get continueLabel => 'continue'.tr();

  static String get retry => 'retry'.tr();

  static String get coursesEmpty => 'courses_empty'.tr();

  static String get coursesLoadFailed => 'courses_load_failed'.tr();

  static String lessonCount(String count) =>
      'lesson_count'.tr(namedArgs: {'count': count});

  static String progressPercent(String percent) =>
      'progress_percent'.tr(namedArgs: {'percent': percent});
}
