import 'package:flutter/material.dart';
import 'package:quick_flashcards/app/core/constants/string_constants.dart';
import 'package:quick_flashcards/app/core/theme/text_theme.dart';

import 'app_colors.dart';

@immutable
class AppButtonTheme {
  static final buttonTheme = ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    buttonColor: AppColors.black,
  );
  static final filledButtonTheme = FilledButtonThemeData(
    style: AppButtonTheme.filledButtonStyle,
  );
  static final filledButtonStyle = FilledButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    textStyle: AppTextTheme.textTheme.bodyLarge?.copyWith(
      fontFamily: StringConstants.fontFamily,
      fontWeight: FontWeight.w500,
    ),
    backgroundColor: AppColors.black,
    minimumSize: const Size(double.infinity, 60),
  );
}
