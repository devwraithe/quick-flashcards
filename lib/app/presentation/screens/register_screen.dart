import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';
import '../../core/utilities/constants/constants.dart';
import '../../core/utilities/helpers/ui_helper.dart';
import '../../core/utilities/helpers/validators_helper.dart';
import '../providers/auth_logic/register_notifier.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _key = GlobalKey<FormState>(debugLabel: 'register');

  final Map<String, dynamic> data = {
    "email": "",
    "password": "",
  };

  // Show and hide password
  bool _obscureText = true;
  void _togglePassword() {
    setState(() => _obscureText = !_obscureText);
  }

  _submit(context, RegisterNotifier notifier) async {
    // Dismiss the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    final formState = _key.currentState!;

    if (formState.validate()) {
      formState.save();
      final result = await notifier.register(data);
      if (result == RegisterState.success) {
        Navigator.pushNamed(context, Routes.home);
      }
      if (result == RegisterState.failed) {
        UiHelpers.errorFlush(notifier.error!, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const textTheme = AppTextTheme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Constants.padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create an Account",
                style: AppTextTheme.textTheme.displaySmall,
              ),
              const SizedBox(height: 6),
              Text(
                "Get started with Flashcards",
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
                      onSaved: (v) => data['email'] = v,
                      validator: (v) => ValidatorHelper.email(v),
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
                      onSaved: (v) => data['password'] = v,
                      obscureText: _obscureText ? true : false,
                      validator: (v) => ValidatorHelper.password(v),
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 30),
                    Consumer(
                      builder: (context, ref, _) {
                        final state = ref.watch(registerProvider);
                        final notifier = ref.read(registerProvider.notifier);

                        return FilledButton(
                          onPressed: () => _submit(context, notifier),
                          child: state == RegisterState.loading
                              ? UiHelpers.darkLoader()
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
                      style: AppTextTheme.textTheme.bodyLarge,
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
