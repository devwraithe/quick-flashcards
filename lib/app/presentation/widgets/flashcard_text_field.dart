import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';

class FlashcardTextField extends StatelessWidget {
  final String label;
  final String? hint;final TextEditingController? controller;

  const FlashcardTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
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
              color: AppColors.lightGray,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              style: AppTextTheme.textTheme.headlineMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              cursorColor: AppColors.grey,
              decoration: InputDecoration(
                hintMaxLines: 3,
                hintText: hint,
                hintStyle: AppTextTheme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
