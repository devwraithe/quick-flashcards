import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/helpers/validators_helper.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';
import 'package:quick_flashcards/app/presentation/logic/auth_logic/reset_password_notifier.dart';
import 'package:quick_flashcards/app/presentation/widgets/app_textfield_widget.dart';

import '../../core/helpers/ui_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  final _key = GlobalKey<FormState>(debugLabel: 'password_reset');

  _submit(notifier) {
    final formState = _key.currentState!;
    try {
      if (formState.validate()) {
        formState.save();
        notifier.resetPassword(
          _emailController.text,
        );
      }
    } catch (e) {
      debugPrint("Something went wrong: ${e.toString()}");
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
                      validator: (v) => ValidatorsHelper.email(v),
                      onSaved: (v) => _emailController.text = v!,
                    ),
                    const SizedBox(height: 20),
                    Consumer(
                      builder: (context, ref, _) {
                        final state = ref.watch(
                          resetPasswordProvider,
                        );
                        final notifier = ref.watch(
                          resetPasswordProvider.notifier,
                        );

                        // if (signUpState == SignUpState.error) {
                        //   final error = signUpNotifier.errorMessage!;
                        //   WidgetsBinding.instance.addPostFrameCallback((_) {
                        //     AppSnackbar.error(
                        //       context,
                        //       error.message,
                        //     );
                        //   });
                        // }

                        return FilledButton(
                          onPressed: () => _submit(notifier),
                          child: state == ResetPasswordState.loading
                              ? UiHelpers.loader()
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
