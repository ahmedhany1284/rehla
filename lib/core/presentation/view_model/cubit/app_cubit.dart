import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/theme/font_family.dart';

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
}
