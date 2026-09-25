import 'package:flutter/material.dart';
import 'package:rehla/core/theme/app_text_style.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title, style: AppTextStyle.semiBold16),
    );
  }
}
