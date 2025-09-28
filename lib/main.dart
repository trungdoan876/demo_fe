import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Login App',
      theme: AppTheme.light(),
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
