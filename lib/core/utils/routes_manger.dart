import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/feature/auth_logic/auth_cubit.dart';
import 'package:movies_app/feature/auth_screen/login_screen/login_screen.dart';
import 'package:movies_app/feature/auth_screen/register_screen/register_screen.dart';
//import 'package:movies_app/feature/home_screen/home_screen.dart';
//import 'package:movies_app/feature/profile/profile_screen.dart';
import '../../feature/on_boarding/on_boarding_screen.dart';
import 'package:movies_app/feature/auth_screen/forget_password_screen/forget_screen.dart';


abstract class RouteManager {
  static const String onboardingScreen = '/';
  static const String loginScreen = '/loginScreen';
  static const String registerScreen = '/registerScreen';
  static const String forgetPasswordScreen = '/forgetPasswordScreen';
  static const String homeScreen = '/homeScreen';
  static const String profileScreen = '/profileScreen';

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
    forgetPasswordScreen: (_) => BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: ForgetPasswordScreen(),
    ),
   // homeScreen: (_) => const HomeScreen(),
   //  profileScreen: (_) => BlocProvider(
   //    create: (context) => getIt<AuthCubit>(),
   //    child: const ProfileScreen(),
   //  ),
  };

}
