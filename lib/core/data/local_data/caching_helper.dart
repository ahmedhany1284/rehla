import 'package:shared_preferences/shared_preferences.dart';

class AppCacheHelper {
  static const String isDark = 'isDark';
  static const String lessonProgress = 'lesson_progress';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static bool getCachedBool({required String key}) {
    return _prefs?.getBool(key) ?? false;
  }

  static Future<void> cacheBool({
    required String key,
    required bool value,
  }) async {
    await _prefs?.setBool(key, value);
  }

  static String getCacheString({required String key}) {
    return _prefs?.getString(key) ?? '';
  }
}
