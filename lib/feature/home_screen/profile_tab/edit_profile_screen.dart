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

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  bool _showAvatarGrid = false;
  late String _selectedAvatar;

  final List<String> _avatars = [
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();

    _selectedAvatar = AssetsManager.avatar8;

    final authCubit = context.read<AuthCubit>();
    if (authCubit.state is ProfileLoaded) {
      final userData = (authCubit.state as ProfileLoaded).userData;
      _nameController.text = userData['name'] ?? '';
      _phoneController.text = userData['phone'] ?? '';
      if (userData['avatarPath'] != null && userData['avatarPath'].isNotEmpty) {
        _selectedAvatar = userData['avatarPath'];
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Update Profile",
          style: GoogleFonts.inter(
            color: ColorManager.white.withOpacity(0.6),
            fontSize: 16.sp,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorManager.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showAvatarGrid = !_showAvatarGrid;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "Pick Avatar",
                                style: GoogleFonts.inter(
                                  color: ColorManager.yellow,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 25.h),
                              CircleAvatar(
                                radius: 65.r,
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(_selectedAvatar),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 35.h),

                      AppTextField(
                        controller: _nameController,
                        hintText: "John Safwat",
                        prefixIcon: Icons.person,
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        controller: _phoneController,
                        hintText: "01200000000",
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 25.h),

                      GestureDetector(
                        onTap: () async {
                          final authState = context.read<AuthCubit>().state;

                          if (authState is ProfileLoaded) {
                            final String? userEmail =
                                authState.userData['email'];

                            if (userEmail != null && userEmail.isNotEmpty) {
                              await context.read<AuthCubit>().resetPassword(
                                email: userEmail,
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "A password reset link has been sent to $userEmail",
                                      style: const TextStyle(
                                        color: ColorManager.black,
                                      ),
                                    ),
                                    backgroundColor: ColorManager.yellow,
                                  ),
                                );
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Email not found for this user.",
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: Text(
                          "Reset Password",
                          style: GoogleFonts.inter(
                            color: ColorManager.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      if (_showAvatarGrid) _buildAvatarGrid(),
                    ],
                  ),
                ),
              ),
            ),

            if (!_showAvatarGrid) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: CustomButton(
                  text: "Delete Account",
                  backgroundColor: ColorManager.orange,
                  textColor: ColorManager.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        backgroundColor: ColorManager.backgroundBlack,
                        title: const Text(
                          "Delete Account",
                          style: TextStyle(color: ColorManager.white),
                        ),
                        content: Text(
                          "Are you sure you want to delete your account permanently?",
                          style: TextStyle(
                            color: ColorManager.white.withOpacity(0.8),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(dialogContext);
                              await context.read<AuthCubit>().deleteAccount();

                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteManager.loginScreen,
                                  (route) => false,
                                );
                              }
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: CustomButton(
                  text: "Update Data",
                  backgroundColor: ColorManager.yellow,
                  textColor: ColorManager.black,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await context.read<AuthCubit>().updateProfile(
                        name: _nameController.text.trim(),
                        phone: _phoneController.text.trim(),
                        avatarPath: _selectedAvatar,
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profile Updated Successfully!"),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 15.h),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarGrid() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.backgroundBlack,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _avatars.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.h,
        ),
        itemBuilder: (context, index) {
          final avatar = _avatars[index];
          final isSelected = _selectedAvatar == avatar;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedAvatar = avatar;
                _showAvatarGrid = false;
              });
            },
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorManager.yellow.withOpacity(0.4)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: ColorManager.yellow,
                  width: isSelected ? 1.8.w : 1.0.w,
                ),
              ),
              child: Image.asset(avatar, fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }
}
