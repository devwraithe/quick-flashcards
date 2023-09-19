import 'package:flutter/material.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';
import 'package:quick_flashcards/app/presentation/screens/reset_password_screen.dart';

import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/sign_up_screen.dart';

final appRoutes = <String, WidgetBuilder>{
  Routes.signUp: (context) => const SignUpScreen(),
  Routes.signIn: (context) => const LoginScreen(),
  Routes.passwordReset: (context) => const ResetPasswordScreen(),
  Routes.home: (context) => const HomeScreen(),
};
