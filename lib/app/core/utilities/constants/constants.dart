import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/text_theme.dart';

class Constants {
  // String Constants
  static String socketError = "No Internet Connection";
  static String unknownError = "Something went wrong";
  static String timeoutError = "Timeout";
  static String fontFamily = 'Gilroy';
  static String passwordResetSuccess = 'Please check your inbox for a mail';

  static String emptyFlashcardsList = "No flashcards added yet!";

  // Double Constants
  static double inputRadius = 8;

  // Other Constants
  static AutovalidateMode validateMode = AutovalidateMode.onUserInteraction;
  static SizedBox prefixSpace = const SizedBox(width: 20);
  static EdgeInsets padding = const EdgeInsets.symmetric(
    horizontal: 18,
    vertical: 24,
  );
  static TextStyle? textFieldStyle = AppTextTheme.textTheme.bodyLarge?.copyWith(
    height: 1.34,
    color: AppColors.white,
  );
}
