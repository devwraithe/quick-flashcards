import 'package:flutter/material.dart';
import 'package:quick_flashcards/app/core/theme/text_theme.dart';

import '../helpers/ui_helper.dart';
import 'app_colors.dart';

class AppInputDecorationTheme {
  static final inputDecoration = InputDecorationTheme(
    hintStyle: AppTextTheme.textTheme.bodyLarge?.copyWith(
      height: 1.34,
      color: AppColors.grey,
    ),
    helperStyle: AppTextTheme.textTheme.bodyLarge?.copyWith(
      height: 1.34,
      color: AppColors.grey,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    contentPadding: const EdgeInsets.symmetric(vertical: 18),
    isDense: true,
    enabledBorder: UiHelpers.inputBorder(AppColors.grey),
    focusedBorder: UiHelpers.inputBorder(AppColors.grey),
    errorBorder: UiHelpers.inputBorder(AppColors.red),
    focusedErrorBorder: UiHelpers.inputBorder(AppColors.red),
    errorStyle: AppTextTheme.textTheme.bodyLarge?.copyWith(
      color: AppColors.red,
    ),
  );
}
