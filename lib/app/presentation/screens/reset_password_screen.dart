import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';
import '../../core/utilities/constants/constants.dart';
import '../../core/utilities/helpers/ui_helper.dart';
import '../../core/utilities/helpers/validators_helper.dart';
import '../notifiers/auth_notifiers/reset_password_notifier.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  final _key = GlobalKey<FormState>(debugLabel: 'reset-password');

  _submit(context, ResetPasswordNotifier notifier) async {
    // Dismiss the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    final formState = _key.currentState!;

    if (formState.validate()) {
      formState.save();
      final result = await notifier.resetPassword(_emailController.text);
      if (result == ResetPasswordState.success) {
        UiHelpers.successFlush(
          "Check your email for reset link",
          context,
        );
        return Future.delayed(
          const Duration(seconds: 3),
          () {
            Navigator.pushNamed(context, Routes.signIn);
          },
        );
      }
      if (result == ResetPasswordState.failed) {
        return UiHelpers.errorFlush(notifier.error!, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const textTheme = AppTextTheme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 26,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Forgot Password",
                style: AppTextTheme.textTheme.displaySmall,
              ),
              const SizedBox(height: 6),
              Text(
                "You'll get a link to reset",
                style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefix: Constants.prefixSpace,
                      ),
                      autovalidateMode: Constants.validateMode,
                      validator: (v) => ValidatorHelper.email(v),
                      onSaved: (v) => _emailController.text = v!,
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    Consumer(
                      builder: (context, ref, _) {
                        final state = ref.watch(resetPasswordProvider);
                        final notifier = ref.watch(
                          resetPasswordProvider.notifier,
                        );

                        return FilledButton(
                          onPressed: () => _submit(context, notifier),
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
                        color: AppColors.white,
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
