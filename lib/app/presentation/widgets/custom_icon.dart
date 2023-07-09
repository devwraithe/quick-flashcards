import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final void Function()? onTap;

  const CustomIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        height: 58,
        width: 58,
        child: Icon(
          icon,
          size: 28,
          color: color,
        ),
      ),
    );
  }
}
