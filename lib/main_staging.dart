import 'package:flutter/material.dart';
import 'ui/features/onboarding/widgets/onboarding_screen.dart';
import 'ui/core/themes/app_theme.dart';
import 'config/app_config.dart';

void main() {
  // Staging environment configuration
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wello App - Staging',
      theme: AppTheme.light(),
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false, // Hide debug banner in staging
    );
  }
}
