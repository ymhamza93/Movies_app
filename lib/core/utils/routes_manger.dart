import 'package:flutter/material.dart';
import '../../feature/on_boarding/on_boarding_screen.dart';

abstract class RouteManager {
  static const String onboardingScreen = '/';
  static const String loginScreen = '/loginScreen';
  static const String homeScreen = '/homeScreen';

  static Map<String, WidgetBuilder> routes = {
    onboardingScreen: (_) => const OnboardingScreen(),
    // loginScreen: (_) => const LoginScreen(),
    // homeScreen: (_) => const HomeScreen(),
  };
}