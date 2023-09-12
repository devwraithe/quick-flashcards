import 'package:flutter/material.dart';
import 'package:quick_flashcards/app/core/constants/constants.dart';

class AppTextFieldWidget extends StatelessWidget {
  final String? hintText, helperText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;

  const AppTextFieldWidget({
    Key? key,
    this.hintText,
    this.helperText,
    this.controller,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // style: AppTextTheme.textTheme.bodyLarge,
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      style: Constants.textFieldStyle,
      decoration: InputDecoration(
        prefix: const SizedBox(
          width: 20,
          height: 0,
        ),
        hintText: hintText,
        helperText: helperText,
      ),
    );
  }
}
