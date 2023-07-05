import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class AppColorScheme {
  static const lightColorScheme = ColorScheme.light(
    primary: AppColors.black,
    secondary: AppColors.black,
    tertiary: AppColors.grey,
    background: AppColors.white,
  );
  static const darkColorScheme = ColorScheme.dark(
    primary: AppColors.white,
    secondary: AppColors.black,
    tertiary: AppColors.grey,
    background: AppColors.black,
  );
}
