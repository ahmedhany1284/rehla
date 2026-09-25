import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/presentation/view/widgets/app_custom_appbar.dart';
import 'package:rehla/core/presentation/view_model/cubit/app_cubit.dart';
import 'package:rehla/core/presentation/view_model/cubit/app_state.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/utils/app_consts.dart';
import 'package:rehla/core/utils/app_strings.dart';
import 'package:rehla/features/settings/presentation/view/widgets/choice_sheet.dart';
import 'package:rehla/features/settings/presentation/view/widgets/settings_row.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final isArabic = context.locale.languageCode == 'ar';
        final isDark = AppConst.isDark;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppCustomAppBar(title: AppStrings.settings),
          body: Column(
            children: [
              SettingsRow(
                title: AppStrings.language,
                value: isArabic ? AppStrings.arabic : AppStrings.english,
                onTap: () => _openLanguageSheet(context, isArabic),
              ),
              Divider(height: 1, color: AppColors.shimmerBase),
              SettingsRow(
                title: AppStrings.theme,
                value: isDark ? AppStrings.dark : AppStrings.light,
                onTap: () => _openThemeSheet(context, isDark),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openLanguageSheet(BuildContext context, bool isArabic) {
    return _openChoiceSheet(
      context: context,
      title: AppStrings.selectLanguage,
      options: [
        ChoiceOption(AppStrings.arabic, true),
        ChoiceOption(AppStrings.english, false),
      ],
      selected: isArabic,
      onApply: (useArabic) {
        if (useArabic == isArabic) return;
        AppCubit.get(context).changeLang(
          context: context,
          locale: Locale(useArabic ? 'ar' : 'en'),
        );
      },
    );
  }

  Future<void> _openThemeSheet(BuildContext context, bool isDark) {
    return _openChoiceSheet(
      context: context,
      title: AppStrings.selectTheme,
      options: [
        ChoiceOption(AppStrings.light, false),
        ChoiceOption(AppStrings.dark, true),
      ],
      selected: isDark,
      onApply: (useDark) {
        if (useDark == isDark) return;
        AppCubit.get(context).changeTheme(value: useDark);
      },
    );
  }

  Future<void> _openChoiceSheet({
    required BuildContext context,
    required String title,
    required List<ChoiceOption> options,
    required bool selected,
    required ValueChanged<bool> onApply,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return ChoiceSheet(
          title: title,
          options: options,
          selected: selected,
          onApply: onApply,
        );
      },
    );
  }
}
