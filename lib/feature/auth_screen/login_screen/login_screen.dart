import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/core/utils/app_text_field.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/core/utils/custom_button.dart';
import 'package:movies_app/core/utils/language_animated_switch.dart';
import 'package:movies_app/core/utils/preference_manager.dart';
import 'package:movies_app/core/utils/routes_manger.dart';
import 'package:movies_app/feature/auth_logic/auth_cubit.dart';
import 'package:movies_app/feature/auth_logic/auth_state.dart';
import 'package:movies_app/l10n/app_localizations.dart';

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

  bool isGoogleClick = false;

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
                    hintText: AppLocalizations.of(context)!.email,
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20.h),

                  AppTextField(
                    hintText: AppLocalizations.of(context)!.password,
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
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteManager.forgetPasswordScreen,
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forget_password,
                        style: TextStyle(
                          color: ColorManager.yellow,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  buildAuthBlocConsumer(),

                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dont_have_account,
                        style: TextStyle(color: ColorManager.white),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteManager.registerScreen,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.create_one,
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
                      Expanded(
                        child: Divider(
                          color: ColorManager.yellow,
                          thickness: 1.5,
                          endIndent: 15.w,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.or,
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

                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) async {
                      if (state is AuthSuccess) {
                        await PreferenceManager.saveData(key: 'isLoggedIn', value: true);

                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteManager.homeScreen,
                                (route) => false,
                          );
                        }
                      }
                      if (state is AuthError) {
                        setState(() {
                          isGoogleClick = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Google Sign-In failed: ${state.message}",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }

                      if (state is AuthInitial) {
                        setState(() {
                          isGoogleClick = false;
                        });
                      }
                    },
                    builder: (context, state) {
                      bool isGoogleLoading =
                          state is AuthLoading && isGoogleClick;

                      if (isGoogleLoading) {
                        return SizedBox(
                          height: 55.h,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: ColorManager.yellow,
                            ),
                          ),
                        );
                      }

                      return InkWell(
                        onTap: () {
                          setState(() {
                            isGoogleClick = true;
                          });
                          context.read<AuthCubit>().loginWithGoogleInCubit();
                        },
                        child: Container(
                          height: 55.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorManager.yellow,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/🦆 icon _google_.svg",
                                height: 24.h,
                                width: 24.w,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                AppLocalizations.of(context)!.login_with_google,
                                style: GoogleFonts.inter(
                                  color: ColorManager.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  const Center(child: LanguageAnimatedSwitch()),

                  const SizedBox(height: 24),
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
      listener: (context, state) async {
        if (state is AuthSuccess) {
          await PreferenceManager.saveData(key: 'isLoggedIn', value: true);
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteManager.homeScreen,
                  (route) => false,
            );
          }
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
        bool isEmailLoading = state is AuthLoading && !isGoogleClick;

        if (isEmailLoading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorManager.yellow),
          );
        }
        return CustomButton(
          text: AppLocalizations.of(context)!.login,
          onPressed: () {
            setState(() {
              isGoogleClick = false;
            });
            if (formKey.currentState!.validate()) {
              context.read<AuthCubit>().login(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
            }
          },
        );
      },
    );
  }
}
