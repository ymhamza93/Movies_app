import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(
        designSize: Size(375, 812),
        splitScreenMode: true,
        minTextAdapt: true,
        builder: (context, _)=>MaterialApp());
  }}