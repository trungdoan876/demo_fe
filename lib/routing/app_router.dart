import 'package:flutter/material.dart';
import 'route_names.dart';
import '../ui/features/onboarding/widgets/onboarding_screen.dart';
import '../ui/features/auth/widgets/login_screen.dart';
import '../ui/features/auth/widgets/register_screen.dart';
import '../ui/features/survey/widgets/survey_question_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case RouteNames.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      case RouteNames.survey:
        return MaterialPageRoute(
          builder: (_) => const SurveyFlowRemoteScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
    }
  }
}
