import 'package:flutter/material.dart';

import '../constants/string_constants.dart';
import '../theme/app_colors.dart';
import '../theme/text_theme.dart';

class AppSnackbar {
  // error snackbar
  static void error(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextTheme.textTheme.bodyLarge?.copyWith(
            fontFamily: StringConstants.fontFamily,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.red,
        padding: const EdgeInsets.all(18),
      ),
    );
  }

  // success snackbar
  static void success(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextTheme.textTheme.bodyLarge?.copyWith(
            fontFamily: StringConstants.fontFamily,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.green,
        padding: const EdgeInsets.all(18),
      ),
    );
  }
}
