import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/constants/constants.dart';
import 'package:quick_flashcards/app/core/constants/string_constants.dart';
import 'package:quick_flashcards/app/core/helpers/validators_helper.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';

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

  // Show and Hide Password
  bool _obscureText = true;
  void _togglePassword() {
    setState(() => _obscureText = !_obscureText);
  }

  _submit(context, ref) async {
    // Dismiss the keyboard on method call
    FocusManager.instance.primaryFocus?.unfocus();

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
    const textTheme = AppTextTheme.textTheme;

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
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefix: Constants.prefixSpace,
                      ),
                      autovalidateMode: Constants.validateMode,
                      controller: _emailController,
                      validator: (v) => ValidatorHelper.email(v),
                      onSaved: (v) => _emailController.text = v!,
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefix: Constants.prefixSpace,
                        suffixIcon: UiHelpers.switchPassword(
                          () => _togglePassword(),
                          _obscureText,
                        ),
                      ),
                      autovalidateMode: Constants.validateMode,
                      controller: _passwordController,
                      style: textTheme.bodyLarge,
                      obscureText: _obscureText ? true : false,
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
