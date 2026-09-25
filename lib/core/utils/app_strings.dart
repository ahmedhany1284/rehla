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

  static String get settings => 'settings'.tr();

  static String get language => 'language'.tr();

  static String get theme => 'theme'.tr();

  static String get arabic => 'arabic'.tr();

  static String get english => 'english'.tr();

  static String get light => 'light'.tr();

  static String get dark => 'dark'.tr();

  static String get selectLanguage => 'select_language'.tr();

  static String get selectTheme => 'select_theme'.tr();

  static String get apply => 'apply'.tr();
}
