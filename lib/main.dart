import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/di/service_locator.dart';

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
    return ScreenUtilInit(
      designSize: Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          //title: 'Movies App',

          //رجعي السطرين دول تاني يا شروق عشان الكود يتظبط

          // initialRoute: RouteManager.onboardingScreen,
          // routes: RouteManager.routes,
          initialRoute: RouteManager.homeScreen,
          routes: RouteManager.routes,
        );
      },
    );
  }
}
