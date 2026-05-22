import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/core/utils/app_text_field.dart';
import 'package:movies_app/core/utils/assets_manager.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/core/utils/custom_button.dart';
import 'package:movies_app/core/utils/routes_manger.dart';
import 'package:movies_app/feature/auth_logic/auth_cubit.dart';
import 'package:movies_app/feature/auth_logic/auth_state.dart';
import 'package:movies_app/feature/auth_screen/register_screen/avatar_carousel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  final List<String> avatars = [
    AssetsManager.avatar1,
    AssetsManager.avatar2,
    AssetsManager.avatar3,
    AssetsManager.avatar4,
    AssetsManager.avatar5,
    AssetsManager.avatar6,
    AssetsManager.avatar7,
    AssetsManager.avatar8,
    AssetsManager.avatar9,
  ];

  int selectedAvatarIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Register",
          style: GoogleFonts.inter(
            color: ColorManager.yellow,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorManager.yellow),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.h),
                  AvatarCarousel(
                    avatars: avatars,
                    onAvatarChanged: (index) {
                      selectedAvatarIndex = index;
                    },
                  ),

                  SizedBox(height: 25.h),
                  AppTextField(
                    hintText: "Name",
                    prefixIcon: Icons.badge_outlined,
                    controller: nameController,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    hintText: "Email",
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.h),
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
                      onPressed: () =>
                          setState(() => isPasswordHidden = !isPasswordHidden),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    hintText: "Confirm Password",
                    prefixIcon: Icons.lock_outline,
                    isPassword: isConfirmPasswordHidden,
                    controller: confirmPasswordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(
                        () =>
                            isConfirmPasswordHidden = !isConfirmPasswordHidden,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    hintText: "Phone Number",
                    prefixIcon: Icons.phone,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 30.h),

                  buildRegisterBlocConsumer(),

                  SizedBox(height: 20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already Have Account ? ",
                        style: TextStyle(color: ColorManager.white),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: ColorManager.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRegisterBlocConsumer() {
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
          text: "Create Account",
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if (passwordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Passwords do not match"),
                    backgroundColor: ColorManager.orange,
                  ),
                );
                return;
              }

              context.read<AuthCubit>().register(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
                name: nameController.text.trim(),
                phone: phoneController.text.trim(),
                avatarPath: avatars[selectedAvatarIndex],
              );
            }
          },
        );
      },
    );
  }
}
