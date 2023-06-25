import 'package:flutter/material.dart';
import 'package:quick_flashcards/presentation/home_screen.dart';

import 'core/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airbnb Host Passport',
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}
