import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/core/utils/app_text_field.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/core/utils/custom_button.dart';
import 'package:movies_app/core/utils/routes_manger.dart';
import 'package:movies_app/feature/auth_logic/auth_cubit.dart';
import 'package:movies_app/feature/auth_logic/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h),
                  Image.asset(
                    "assets/images/splash_logo.png",
                    height: 120.h,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: 50.h),

                  AppTextField(
                    hintText: "Email Address",
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20.h),

                  AppTextField(
                    hintText: "Password",
                    prefixIcon: Icons.lock_outline,
                    isPassword: isPasswordHidden,
                    controller: passwordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 15.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: ColorManager.yellow,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  buildAuthBlocConsumer(),

                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: ColorManager.white),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteManager.registerScreen,
                        ), // غيريها لـ registerScreen لاحقاً
                        child: const Text(
                          "Create One",
                          style: TextStyle(
                            color: ColorManager.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      // الخط الأيسر
                      Expanded(
                        child: Divider(
                          color: ColorManager.yellow,
                          thickness: 1.5,
                          endIndent: 15.w,
                        ),
                      ),

                      Text(
                        "OR",
                        style: GoogleFonts.inter(
                          color: ColorManager.yellow,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Expanded(
                        child: Divider(
                          color: ColorManager.yellow,
                          thickness: 1.5,
                          indent: 15.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    text: "Login With Google",
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "assets/images/🦆 icon _google_.svg",
                      height: 24.h,
                      width: 24.w,
                      colorFilter: const ColorFilter.mode(
                        ColorManager.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAuthBlocConsumer() {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, RouteManager.homeScreen);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorManager.orange,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorManager.yellow),
          );
        }
        return CustomButton(
          text: "Login",
          onPressed: () {
            // if (formKey.currentState!.validate()) {
            //   context.read<AuthCubit>().login(
            //     email: emailController.text.trim(),
            //     password: passwordController.text.trim(),
            //   );
            // }
            Navigator.pushReplacementNamed(context, RouteManager.homeScreen);
          },
        );
      },
    );
  }
}
