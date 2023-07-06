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
import '../logic/auth_logic/sign_up_notifier.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _key = GlobalKey<FormState>(debugLabel: 'sign_up');

  _submit(context, ref) async {
    final formState = _key.currentState!;

    final state = ref.watch(signUpProvider);
    final notifier = ref.watch(signUpProvider.notifier);

    try {
      if (formState.validate()) {
        formState.save();
        final result = await notifier.signUp(
          _emailController.text,
          _passwordController.text,
        );
        if (state != SignUpState.success) {
          debugPrint('[UI AUTH ERROR] $result');
          return AppSnackbar.error(context, result);
        } else {
          Navigator.pushNamed(context, Routes.home);
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
                        final state = ref.watch(signUpProvider);
                        final notifier = ref.watch(signUpProvider.notifier);

                        return FilledButton(
                          onPressed: () => _submit(context, ref),
                          child: state == SignUpState.loading
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
