import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/constants/constants.dart';
import 'package:quick_flashcards/app/core/constants/string_constants.dart';
import 'package:quick_flashcards/app/core/helpers/validators_helper.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';
import 'package:quick_flashcards/app/presentation/widgets/app_textfield_widget.dart';

import '../../core/helpers/snackbar_helper.dart';
import '../../core/helpers/ui_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';
import '../providers/auth_logic/sign_in_notifier.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _key = GlobalKey<FormState>(debugLabel: 'sign_in');

  _submit(context, ref) async {
    final formState = _key.currentState!;

    final state = ref.watch(signInProvider);
    final notifier = ref.watch(signInProvider.notifier);

    try {
      if (formState.validate()) {
        formState.save();
        final result = await notifier.signIn(
          _emailController.text,
          _passwordController.text,
        );
        if (state != SignInState.success) {
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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Constants.padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back",
                style: AppTextTheme.textTheme.displaySmall,
              ),
              const SizedBox(height: 6),
              Text(
                "Continue to your account",
                style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppTextFieldWidget(
                      hintText: "Email",
                      controller: _emailController,
                      validator: (v) => ValidatorHelper.email(v),
                      onSaved: (v) => _emailController.text = v!,
                    ),
                    const SizedBox(height: 18),
                    AppTextFieldWidget(
                      hintText: "Password",
                      controller: _passwordController,
                      validator: (v) => ValidatorHelper.password(v),
                      onSaved: (v) => _passwordController.text = v!,
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.passwordReset,
                      ),
                      child: Text(
                        "Forget Password?",
                        style: AppTextTheme.textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Consumer(
                      builder: (context, ref, _) {
                        final state = ref.watch(signInProvider);

                        return FilledButton(
                          onPressed: () => _submit(context, ref),
                          child: state == SignInState.loading
                              ? UiHelpers.darkLoader()
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
