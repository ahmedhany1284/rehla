import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/data/local_data/caching_helper.dart';
import 'package:rehla/core/theme/font_family.dart';
import 'package:rehla/core/utils/app_consts.dart';

import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(InitState());

  static AppCubit get(BuildContext context, {bool listen = false}) =>
      BlocProvider.of<AppCubit>(context, listen: listen);

  String _currentFontFamily = FontFamily.neulisSans;

  String get currentFontFamily => _currentFontFamily;

  void changeFontFamily({required String fontFamily}) {
    _currentFontFamily = fontFamily;
    emit(ChangeFontState());
  }

  void changeTheme({required bool value}) {
    AppConst.isDark = value;
    AppCacheHelper.cacheBool(key: AppCacheHelper.isDark, value: value);
    emit(ChangeThemeState());
  }

  void changeLang({
    required BuildContext context,
    required Locale locale,
  }) {
    context.setLocale(locale);
    emit(ChangeLanguageState());
  }
}
