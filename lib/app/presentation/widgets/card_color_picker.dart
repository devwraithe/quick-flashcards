import 'package:flutter/material.dart';

class CardColorPicker extends StatefulWidget {
  final Color cardColor, borderColor;
  final void Function()? onTap;

  const CardColorPicker({
    super.key,
    required this.cardColor,
    required this.borderColor,
    this.onTap,
  });
  @override
  State<CardColorPicker> createState() => _CardColorPickerState();
}

class _CardColorPickerState extends State<CardColorPicker> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(100);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 42,
        width: 42,
        margin: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.borderColor,
            width: 2.8,
          ),
          borderRadius: borderRadius,
        ),
        child: Container(
          width: 38,
          height: 38,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: widget.cardColor,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}
