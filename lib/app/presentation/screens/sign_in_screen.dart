import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/helpers/validators_helper.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';
import 'package:quick_flashcards/app/presentation/logic/auth_logic/sign_in_notifier.dart';
import 'package:quick_flashcards/app/presentation/widgets/app_textfield_widget.dart';

import '../../core/helpers/ui_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Map<String, dynamic> data = {
    "email": "",
    "password": "",
  };

  final _key = GlobalKey<FormState>(debugLabel: 'sign_up');

  _submit(notifier) {
    final formState = _key.currentState!;
    try {
      if (formState.validate()) {
        formState.save();
        notifier.signIn(
          _emailController.text,
          _passwordController.text,
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
                    const SizedBox(height: 18),
                    AppTextFieldWidget(
                      hintText: "Password",
                      controller: _passwordController,
                      validator: (v) => ValidatorsHelper.password(v),
                      onSaved: (v) => _passwordController.text = v!,
                      helperText: "Note: Letters and numbers are required",
                    ),
                    const SizedBox(height: 20),
                    Consumer(
                      builder: (context, ref, _) {
                        final state = ref.watch(signInProvider);
                        final notifier = ref.watch(signInProvider.notifier);

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
                          child: state == SignInState.loading
                              ? UiHelpers.loader()
                              : const Text("Sign In"),
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
                      Routes.signUp,
                    ),
                    child: Text(
                      " Sign Up",
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
