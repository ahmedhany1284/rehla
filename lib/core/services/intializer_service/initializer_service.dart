import 'package:easy_localization/easy_localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../generated/assets.dart';
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
    await _loadTranslations();

    initialized = true;
  }

  Future<void> _loadTranslations() async {
    final saved = AppCacheHelper.getCacheString(key: 'locale');
    final locale = Locale(saved.startsWith('en') ? 'en' : 'ar');
    final data = await const RootBundleAssetLoader().load(
      AssetData.translations,
      locale,
    );
    Localization.load(
      locale,
      translations: Translations(Map<String, dynamic>.from(data ?? {})),
    );
  }
}
