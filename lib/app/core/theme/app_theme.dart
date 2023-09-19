import 'package:flutter/material.dart';
import 'package:quick_flashcards/app/core/theme/text_theme.dart';

import '../utilities/constants/constants.dart';
import 'app_button_theme.dart';
import 'app_color_scheme.dart';
import 'input_theme.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    fontFamily: Constants.fontFamily,
    colorScheme: AppColorScheme.darkColorScheme,
    scaffoldBackgroundColor: AppColorScheme.darkColorScheme.background,
    filledButtonTheme: AppButtonTheme.filledButtonTheme,
    textTheme: AppTextTheme.textTheme,
    inputDecorationTheme: AppInputDecorationTheme.inputDecoration,
  );
}
