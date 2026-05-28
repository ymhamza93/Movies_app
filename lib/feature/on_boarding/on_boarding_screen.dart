import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/core/utils/preference_manager.dart';
import 'package:movies_app/core/utils/routes_manger.dart';
import '../../core/utils/custom_button.dart';
import 'onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = OnboardingData.pages;

    return Scaffold(
      backgroundColor: ColorManager.backgroundBlack,
      body: Stack(
        children: [
          // الـ PageView المسؤول عن عرض الـ 6 خلفيات
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index; // هنا الـ index بيتحدث طبيعي وسلس جداً مع الحركة
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                pages[index].image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          // الـ Gradient السينمائي لتوضيح النصوص والأزرار
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  ColorManager.black.withOpacity(0.2),
                  ColorManager.black.withOpacity(0.8),
                  ColorManager.black,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          // محتوى النصوص والأزرار في الأسفل
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 34.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pages[_currentIndex].title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.white,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    pages[_currentIndex].desc,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: ColorManager.white.withOpacity(0.6),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // زرار التحكم الأساسي (Explore Now / Next / Finish)
                  CustomButton(
                    text: pages[_currentIndex].buttonText,
                    onPressed: () async {
                      if (_currentIndex < pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // عند الضغط على Finish في الصفحة السادسة والأخيرة
                        await PreferenceManager.saveData(
                          key: 'isFirstTime',
                          value: false,
                        );
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            RouteManager.loginScreen,
                          );
                        }
                      }
                    },
                  ),
                  // هنا التعديل: زرار الـ Back يظهر فقط بدءاً من الصورة الثالثة (index 2) كما في التصميم تماماً
                  if (_currentIndex >= 2) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      height: 55.h,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: ColorManager.yellow,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          "Back",
                          style: GoogleFonts.inter(
                            color: ColorManager.yellow,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}