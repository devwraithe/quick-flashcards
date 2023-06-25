import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

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
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.white,
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
            color: AppColors.white,
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
