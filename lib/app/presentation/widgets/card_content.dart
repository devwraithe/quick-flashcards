import 'package:flutter/material.dart';
import 'package:quick_flashcards/app/core/theme/text_theme.dart';

import '../../core/theme/app_colors.dart';

class CardContent extends StatelessWidget {
  final String title, counter, value;

  const CardContent({
    Key? key,
    required this.title,
    required this.counter,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textTheme = AppTextTheme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              counter,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          value,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.4,
            fontSize: 26,
          ),
        ),
        const Spacer(),
        Text(
          "Tap to flip",
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
