import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/feature/auth_logic/auth_cubit.dart';
import 'package:movies_app/feature/auth_screen/login_screen/login_screen.dart';
import 'package:movies_app/feature/auth_screen/register_screen/register_screen.dart';
import '../../feature/on_boarding/on_boarding_screen.dart';

abstract class RouteManager {
  static const String onboardingScreen = '/';
  static const String loginScreen = '/loginScreen';
  static const String registerScreen = '/registerScreen';
  static const String homeScreen = '/homeScreen';

  static Map<String, WidgetBuilder> routes = {
    onboardingScreen: (_) => const OnboardingScreen(),
    loginScreen: (_) => BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: const LoginScreen(),
    ),
    registerScreen: (_) => BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: const RegisterScreen(),
    ),
  };
  // homeScreen: (_) => const HomeScreen(),
}
