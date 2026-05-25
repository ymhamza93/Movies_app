import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/feature/auth_logic/locale_cubit.dart';
import 'package:movies_app/feature/home_screen/profile_tab/history_list/history_cubit.dart';
import 'package:movies_app/feature/home_screen/profile_tab/watch_list/watchlist_cubit.dart';
import 'package:movies_app/l10n/app_localizations.dart';

import 'core/utils/routes_manger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  setupServiceLocator();
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(
          create: (context) => getIt<WatchlistCubit>()..fetchWatchlist(),
        ),

        BlocProvider(create: (context) => HistoryCubit()),
      ],

      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, currentLocale) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            splitScreenMode: true,
            minTextAdapt: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,

                locale: currentLocale,

                initialRoute: RouteManager.homeScreen,
                routes: RouteManager.routes,
              );
            },
          );
        },
      ),
    );
  }
}
