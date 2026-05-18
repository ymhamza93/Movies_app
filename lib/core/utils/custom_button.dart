import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_manager.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon; // 1. ضفنا متغير اختياري للأيقونة هنا

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon, // 2. مررناه في الـ Constructor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? ColorManager.yellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        // 3. عمالنا شرط: لو في أيقونة، يعرض الـ Row، لو مفيش يعرض النص لوحده
        child: icon != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!, // الأيقونة (زي لوجو جوجل)
            SizedBox(width: 12.w),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: textColor ?? ColorManager.black,
              ),
            ),
          ],
        )
            : Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: textColor ?? ColorManager.black,
          ),
        ),
      ),
    );
  }
}