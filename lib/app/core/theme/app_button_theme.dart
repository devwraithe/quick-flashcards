import 'package:flutter/material.dart';
import 'package:quick_flashcards/app/core/theme/text_theme.dart';

import '../utilities/constants/constants.dart';
import 'app_colors.dart';

@immutable
class AppButtonTheme {
  static final filledButtonTheme = FilledButtonThemeData(
    style: AppButtonTheme.darkThemeFilledButton,
  );

  /// BUTTON FOR THE DARK THEME
  static final darkThemeFilledButton = FilledButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.inputRadius),
    ),
    textStyle: AppTextTheme.textTheme.titleLarge?.copyWith(
      fontFamily: Constants.fontFamily,
      color: AppColors.black,
      fontWeight: FontWeight.w500,
    ),
    backgroundColor: AppColors.white,
    minimumSize: const Size(double.infinity, 55),
  );
}
