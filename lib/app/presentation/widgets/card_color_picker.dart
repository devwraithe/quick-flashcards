import 'package:flutter/material.dart';

class CardColorPicker extends StatefulWidget {
  final Color cardColor;
  final void Function()? onTap;

  const CardColorPicker({
    super.key,
    required this.cardColor,
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
    final borderRadius = BorderRadius.circular(0);
    const double height = 52;

    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: height,
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
