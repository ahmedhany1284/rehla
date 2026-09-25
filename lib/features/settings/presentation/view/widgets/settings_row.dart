import 'package:flutter/material.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/app_text_style.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
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
