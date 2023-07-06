import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/routes/app_routes.dart';
import 'package:quick_flashcards/app/presentation/screens/home_screen.dart';
import 'package:quick_flashcards/app/presentation/screens/sign_in_screen.dart';

import 'core/helpers/ui_helper.dart';
import 'core/theme/app_theme.dart';
import 'domain/usecases/auth_usecases/auth_status_usecase.dart';

class QuickFlashcards extends ConsumerWidget {
  const QuickFlashcards({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verifyAuth = ref.read(checkAuthProvider);
    return MaterialApp(
      title: 'Quick Flashcards',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: FutureBuilder<bool>(
        future: verifyAuth.execute(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: UiHelpers.loader(),
            );
          } else {
            if (snapshot.hasData && snapshot.data!) {
              return const HomeScreen();
            } else {
              return const SignInScreen();
            }
          }
        },
      ),
      routes: appRoutes,
    );
  }
}
