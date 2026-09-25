import 'package:flutter/material.dart';
import 'package:rehla/core/presentation/view/widgets/main_button.dart';
import 'package:rehla/core/theme/app_colors.dart';
import 'package:rehla/core/theme/app_text_style.dart';
import 'package:rehla/core/utils/app_strings.dart';

class ChoiceOption {
  const ChoiceOption(this.label, this.value);

  final String label;
  final bool value;
}

class ChoiceSheet extends StatefulWidget {
  const ChoiceSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onApply,
  });

  final String title;
  final List<ChoiceOption> options;
  final bool selected;
  final ValueChanged<bool> onApply;

  @override
  State<ChoiceSheet> createState() => _ChoiceSheetState();
}

class _ChoiceSheetState extends State<ChoiceSheet> {
  late bool _current = widget.selected;

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
          Text(widget.title, style: AppTextStyle.semiBold16),
          const SizedBox(height: 8),
          for (final option in widget.options)
            InkWell(
              onTap: () => setState(() => _current = option.value),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(option.label, style: AppTextStyle.medium16),
                    ),
                    Icon(
                      _current == option.value
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: _current == option.value
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
              Navigator.pop(context);
              widget.onApply(_current);
            },
          ),
        ],
      ),
    );
  }
}
