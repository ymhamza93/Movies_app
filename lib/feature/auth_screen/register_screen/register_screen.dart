import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/core/utils/app_text_field.dart';
import 'package:movies_app/core/utils/assets_manager.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/core/utils/custom_button.dart';
import 'package:movies_app/core/utils/language_animated_switch.dart';
import 'package:movies_app/core/utils/preference_manager.dart';
import 'package:movies_app/core/utils/routes_manger.dart';
import 'package:movies_app/feature/auth_logic/auth_cubit.dart';
import 'package:movies_app/feature/auth_logic/auth_state.dart';
import 'package:movies_app/feature/auth_screen/register_screen/avatar_carousel.dart';
import 'package:movies_app/l10n/app_localizations.dart';

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
          AppLocalizations.of(context)!.register,
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
                    hintText:AppLocalizations.of(context)!.name,
                    prefixIcon: Icons.badge_outlined,
                    controller: nameController,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    hintText: AppLocalizations.of(context)!.email,
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.h),
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
                      onPressed: () =>
                          setState(() => isPasswordHidden = !isPasswordHidden),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    hintText: AppLocalizations.of(context)!.confirm_password,
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
                    hintText: AppLocalizations.of(context)!.phone_number,
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
                       Text(
                      AppLocalizations.of(context)!.already_have_account  ,
                        style: TextStyle(color: ColorManager.white),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child:  Text(
                         AppLocalizations.of(context)!.login,
                          style: TextStyle(
                            color: ColorManager.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Center(
                    child: LanguageAnimatedSwitch(),
                  ),

                  const SizedBox(height: 24),

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
        if (state is AuthLoading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorManager.yellow),
          );
        }

        return CustomButton(
          text: AppLocalizations.of(context)!.create_account,
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
