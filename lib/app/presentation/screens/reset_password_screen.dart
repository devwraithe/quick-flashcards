import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/helpers/validators_helper.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';
import 'package:quick_flashcards/app/presentation/widgets/app_textfield_widget.dart';

import '../../core/constants/string_constants.dart';
import '../../core/helpers/snackbar_helper.dart';
import '../../core/helpers/ui_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';
import '../providers/auth_logic/reset_password_notifier.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  final _key = GlobalKey<FormState>(debugLabel: 'reset_password');

  _submit(context, ref) async {
    // Dismiss the keyboard on method call
    FocusManager.instance.primaryFocus?.unfocus();

    final formState = _key.currentState!;

    final state = ref.watch(resetPasswordProvider);
    final notifier = ref.read(resetPasswordProvider.notifier);

    try {
      if (formState.validate()) {
        formState.save();
        final result = await notifier.resetPassword(
          _emailController.text,
        );
        if (state != ResetPasswordState.success) {
          debugPrint('[UI AUTH ERROR] $result');
          return AppSnackbar.error(context, result);
        } else {
          Navigator.pushNamed(context, Routes.signIn);
        }
      }
    } catch (e) {
      debugPrint("${StringConstants.unknownError}: ${e.toString()}");
      AppSnackbar.error(
        context,
        "${StringConstants.unknownError}: ${e.toString()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 26,
          ),
          child: Column(
            children: [
              Form(
                key: _key,
                child: Column(
                  children: [
                    AppTextFieldWidget(
                      hintText: "Email",
                      controller: _emailController,
                      validator: (v) => ValidatorHelper.email(v),
                      onSaved: (v) => _emailController.text = v!,
                    ),
                    const SizedBox(height: 20),
                    Consumer(
                      builder: (context, ref, _) {
                        final state = ref.watch(resetPasswordProvider);
                        return FilledButton(
                          onPressed: () => _submit(context, ref),
                          child: state == ResetPasswordState.loading
                              ? UiHelpers.darkLoader()
                              : const Text("Reset Password"),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.signIn,
                    ),
                    child: Text(
                      " Sign In",
                      style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
