import 'package:flutter/material.dart';
import 'package:rehla/core/presentation/view/widgets/main_button.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/app_text_style.dart';

class AppCustomBottomSheet extends StatelessWidget {
  const AppCustomBottomSheet({
    super.key,
    required this.title,
    required this.child,
    required this.actionText,
    required this.onAction,
  });

  final String title;
  final Widget child;
  final String actionText;
  final VoidCallback onAction;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget child,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (_) => AppCustomBottomSheet(
        title: title,
        actionText: actionText,
        onAction: onAction,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
          child,
          const SizedBox(height: 16),
          AppDefaultButton(buttonText: actionText, ontap: onAction),
        ],
      ),
    );
  }
}
