import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../theme/app_colors.dart';
import '../../theme/text_theme.dart';
import '../constants/constants.dart';

class UiHelpers {
  static loader() {
    return const SpinKitFadingFour(
      color: AppColors.white,
      size: 22,
    );
  }

  // dark loader
  static darkLoader() {
    return const SpinKitFadingFour(
      color: AppColors.black,
      size: 22,
    );
  }

  static List cardColors = [
    AppColors.cardGreen,
    AppColors.cardRed,
    AppColors.cardBlue,
    AppColors.cardYellow,
  ];

  static errorFlush(
    String message,
    BuildContext context,
  ) async {
    return Flushbar(
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextTheme.textTheme.bodyLarge?.copyWith(
          color: AppColors.white,
        ),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.red,
      flushbarPosition: FlushbarPosition.BOTTOM,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
    )..show(context);
  }

  static successFlush(
    String message,
    BuildContext context,
  ) async {
    return Flushbar(
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextTheme.textTheme.bodyLarge?.copyWith(
          color: AppColors.white,
        ),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.green,
      flushbarPosition: FlushbarPosition.BOTTOM,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
    )..show(context);
  }

  static switchPassword(void Function()? onTap, bool obscurePassword) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        obscurePassword == true ? TablerIcons.eye_off : TablerIcons.eye,
      ),
    );
  }

  static inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Constants.inputRadius),
      borderSide: BorderSide(
        color: color,
        width: 1.8,
      ),
    );
  }
}
