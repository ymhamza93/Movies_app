import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/feature/auth_logic/auth_cubit.dart';
import 'package:movies_app/feature/auth_screen/login_screen/login_screen.dart';
import 'package:movies_app/feature/auth_screen/register_screen/register_screen.dart';
import 'package:movies_app/feature/home_screen/data/model/movie_model.dart';

import 'package:movies_app/feature/home_screen/home_screen.dart';
import 'package:movies_app/feature/home_screen/movie_details/movie_details_screen.dart';
import 'package:movies_app/feature/home_screen/profile_tab/edit_profile_screen.dart';
import 'package:movies_app/feature/home_screen/profile_tab/history_list/history_cubit.dart';
import 'package:movies_app/feature/home_screen/profile_tab/profile_tab.dart';

import '../../feature/on_boarding/on_boarding_screen.dart';
import 'package:movies_app/feature/auth_screen/forget_password_screen/forget_screen.dart';

// 🌟 استيراد الكوبيت الخاص بالـ Watchlist
import 'package:movies_app/feature/home_screen/profile_tab/watch_list/watchlist_cubit.dart';

abstract class RouteManager {
  static const String onboardingScreen = '/';
  static const String loginScreen = '/loginScreen';
  static const String registerScreen = '/registerScreen';
  static const String forgetPasswordScreen = '/forgetPasswordScreen';
  static const String homeScreen = '/homeScreen';
  static const String profileScreen = '/profileScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String movieDetailsScreen = '/movieDetailsScreen';

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
    homeScreen: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider.value(value: BlocProvider.of<WatchlistCubit>(context)),
        BlocProvider.value(value: BlocProvider.of<HistoryCubit>(context)),
      ],
      child: const HomeScreen(),
    ),

    profileScreen: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider.value(value: BlocProvider.of<WatchlistCubit>(context)),
        BlocProvider.value(value: BlocProvider.of<HistoryCubit>(context)),
      ],
      child: const ProfileTab(),
    ),

    editProfileScreen: (context) {
      final authCubit = ModalRoute.of(context)!.settings.arguments as AuthCubit;
      return BlocProvider.value(
        value: authCubit,
        child: const EditProfileScreen(),
      );
    },

    movieDetailsScreen: (context) {
      final movieModel =
          ModalRoute.of(context)!.settings.arguments as MovieModel;
      return MovieDetailsScreen(movie: movieModel);
    },
  };
}
