import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import '../../data/local_data/caching_helper.dart';
import '../../utils/app_consts.dart';

class AppInitializer {
  AppInitializer();

  static bool initialized = false;

  Future<void> init() async {
    if (initialized) return;

    await AppCacheHelper.init();
    AppConst.isDark = AppCacheHelper.getCachedBool(key: AppCacheHelper.isDark);

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await EasyLocalization.ensureInitialized();

    initialized = true;
  }
}
