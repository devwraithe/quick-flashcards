import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_flashcards/app/core/helpers/validators_helper.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';

import '../../core/constants/constants.dart';
import '../../core/helpers/ui_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';
import '../providers/auth_logic/sign_up_notifier.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _key = GlobalKey<FormState>(debugLabel: 'create-account');

  final Map<String, dynamic> data = {
    "email": "",
    "password": "",
  };

  /// TOGGLING ICON
  bool _obscureText = true;
  void _togglePassword() {
    setState(() => _obscureText = !_obscureText);
  }

  _submit(context, CreateAccountNotifier notifier) async {
    final formState = _key.currentState!;

    if (formState.validate()) {
      formState.save();
      final result = await notifier.createAccount(data);
      if (result == CreateAccountState.success) {
        Navigator.pushNamed(context, Routes.home);
      } else if (result == CreateAccountState.failed) {
        UiHelpers.errorFlush(
          notifier.errorMessage!,
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const textTheme = AppTextTheme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 26,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/vectors/logo.svg',
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 60),
              Text(
                "Create an Account",
                style: AppTextTheme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 30),
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
                    const SizedBox(height: 20),
                    Consumer(
                      builder: (context, ref, _) {
                        final createAccount = createAccountProvider(data);
                        final state = ref.watch(createAccount);
                        final notifier = ref.read(createAccount.notifier);

                        return FilledButton(
                          onPressed: () => _submit(context, notifier),
                          child: state == CreateAccountState.loading
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
