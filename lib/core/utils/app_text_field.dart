import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_manager.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon; // تعديل هنا ليستقبل أيقونة العين
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword, // دي اللي بتخليه مخفي نجوم
      keyboardType: keyboardType,
      style: const TextStyle(color: ColorManager.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 16.sp),
        prefixIcon: Icon(prefixIcon, color: ColorManager.white),
        suffixIcon: suffixIcon, // عرض العين هنا
        filled: true,
        fillColor: ColorManager.textfieldBlack, // الرمادي الغامق بتاعك
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}