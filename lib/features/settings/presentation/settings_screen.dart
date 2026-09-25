import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/presentation/view/widgets/app_custom_appbar.dart';
import 'package:rehla/core/presentation/view/widgets/main_button.dart';
import 'package:rehla/core/presentation/view_model/cubit/app_cubit.dart';
import 'package:rehla/core/presentation/view_model/cubit/app_state.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/app_text_style.dart';
import 'package:rehla/core/utils/app_consts.dart';
import 'package:rehla/core/utils/app_strings.dart';

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
              _SettingsRow(
                title: AppStrings.language,
                value: isArabic ? AppStrings.arabic : AppStrings.english,
                onTap: () => _openLanguageSheet(context, isArabic),
              ),
              Divider(height: 1, color: AppColors.shimmerBase),
              _SettingsRow(
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
        _Choice(AppStrings.arabic, true),
        _Choice(AppStrings.english, false),
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
        _Choice(AppStrings.light, false),
        _Choice(AppStrings.dark, true),
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
    required List<_Choice> options,
    required bool selected,
    required ValueChanged<bool> onApply,
  }) {
    var current = selected;
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.shimmerBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(title, style: AppTextStyle.semiBold16),
                  const SizedBox(height: 8),
                  for (final option in options)
                    InkWell(
                      onTap: () => setState(() => current = option.value),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option.label,
                                style: AppTextStyle.medium16,
                              ),
                            ),
                            Icon(
                              current == option.value
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: current == option.value
                                  ? AppColors.primary
                                  : AppColors.shimmerBase,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  AppDefaultButton(
                    buttonText: AppStrings.apply,
                    ontap: () {
                      Navigator.pop(sheetContext);
                      onApply(current);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Choice {
  const _Choice(this.label, this.value);

  final String label;
  final bool value;
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.title,
    required this.value,
    required this.onTap,
  });

  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppTextStyle.medium16)),
            Text(value, style: AppTextStyle.regular14),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: AppColors.label),
          ],
        ),
      ),
    );
  }
}
