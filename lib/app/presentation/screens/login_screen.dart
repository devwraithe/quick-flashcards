import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/constants/constants.dart';
import 'package:quick_flashcards/app/core/helpers/validators_helper.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';

import '../../core/helpers/ui_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';
import '../providers/auth_logic/login_notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>(debugLabel: 'login');

  final Map<String, dynamic> data = {
    "email": "",
    "password": "",
  };

  // Show and Hide Password
  bool _obscureText = true;
  void _togglePassword() {
    setState(() => _obscureText = !_obscureText);
  }

  _submit(context, LoginNotifier notifier) async {
    // Dismiss the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    final formState = _key.currentState!;

    if (formState.validate()) {
      formState.save();
      final result = await notifier.login(data);
      if (result == LoginState.success) {
        Navigator.pushNamed(context, Routes.home);
      }
      if (result == LoginState.failed) {
        return UiHelpers.errorFlush(notifier.error!, context);
      }
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
                      validator: (v) => ValidatorHelper.email(v),
                      onSaved: (v) => data['email'] = v!,
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
                      style: textTheme.bodyLarge,
                      obscureText: _obscureText ? true : false,
                      validator: (v) => ValidatorHelper.password(v),
                      onSaved: (v) => data['password'] = v!,
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
                        final state = ref.watch(loginProvider);
                        final notifier = ref.watch(loginProvider.notifier);

                        return FilledButton(
                          onPressed: () => _submit(context, notifier),
                          child: state == LoginState.loading
                              ? UiHelpers.darkLoader()
                              : const Text("Login"),
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
