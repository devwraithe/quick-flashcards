import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';

class FlashcardTextField extends StatelessWidget {
  final String label;
  const FlashcardTextField({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextTheme.textTheme.bodyLarge?.copyWith(
              color: AppColors.grey,
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            style: AppTextTheme.textTheme.displaySmall?.copyWith(
              color: AppColors.white,
            ),
            // decoration: Input,
          ),
        ],
      ),
    );
  }
}
