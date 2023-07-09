import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CustomSubIcon extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;

  const CustomSubIcon({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(50),
        ),
        height: 50,
        width: 50,
        child: Icon(
          icon,
          size: 22,
          color: AppColors.white,
        ),
      ),
    );
  }
}
