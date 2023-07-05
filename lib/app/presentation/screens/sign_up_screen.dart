import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/helpers/validators_helper.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';
import 'package:quick_flashcards/app/presentation/widgets/app_textfield_widget.dart';

import '../../core/helpers/ui_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';
import '../logic/auth_logic/sign_up_notifier.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
        notifier.signUp(
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
                      onSaved: (v) => data['email'] = v!,
                    ),
                    const SizedBox(height: 18),
                    AppTextFieldWidget(
                      hintText: "Password",
                      controller: _passwordController,
                      validator: (v) => ValidatorsHelper.password(v),
                      onSaved: (v) => data['password'] = v!,
                      helperText: "Note: Letters and numbers are required",
                    ),
                    const SizedBox(height: 20),
                    Consumer(
                      builder: (context, ref, _) {
                        final signUpState = ref.watch(
                          signUpProvider,
                        );
                        final signUpNotifier = ref.watch(
                          signUpProvider.notifier,
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
                          onPressed: () => _submit(signUpNotifier),
                          child: signUpState == SignUpState.loading
                              ? UiHelpers.loader()
                              : const Text("Create Account"),
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
                    "Already have account?",
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
