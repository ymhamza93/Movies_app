import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/utils/app_text_field.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/core/utils/custom_button.dart';
import 'package:movies_app/feature/auth_logic/auth_cubit.dart';
import 'package:movies_app/feature/auth_logic/auth_state.dart';
import 'package:movies_app/l10n/app_localizations.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorManager.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.forget_password,
          style: TextStyle(
            color: ColorManager.yellow,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),

                  Container(
                    width: 300.w,
                    height: 300.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Forgot password-bro 1.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  AppTextField(
                    controller: emailController,
                    hintText: AppLocalizations.of(context)!.email,
                    prefixIcon: Icons.email_outlined,
                    isPassword: false,
                  ),

                  SizedBox(height: 24.h),

                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('A password reset.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Center(
                          child: CircularProgressIndicator(color: ColorManager.yellow),
                        );
                      }

                      return CustomButton(
                        text: AppLocalizations.of(context)!.verify_email,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthCubit>().resetPassword(
                              email: emailController.text.trim(),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}