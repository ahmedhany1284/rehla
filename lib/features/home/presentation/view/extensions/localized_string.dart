import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:rehla/features/home/domain/entities/course.dart';

extension LocalizedStringX on LocalizedString {
  String localized(BuildContext context) {
    return context.locale.languageCode == 'en' ? en : ar;
  }
}
