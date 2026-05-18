import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/core/utils/color_manager.dart';

class AvatarCarousel extends StatefulWidget {
  final List<String> avatars;
  final Function(int) onAvatarChanged;

  const AvatarCarousel({
    super.key,
    required this.avatars,
    required this.onAvatarChanged,
  });

  @override
  State<AvatarCarousel> createState() => _AvatarCarouselState();
}

class _AvatarCarouselState extends State<AvatarCarousel> {
  late final PageController _avatarController;
  int selectedAvatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _avatarController = PageController(viewportFraction: 0.40, initialPage: 0);
  }

  @override
  void dispose() {
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 150.h,
          child: PageView.builder(
            controller: _avatarController,
            itemCount: widget.avatars.length,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                selectedAvatarIndex = index;
              });
              widget.onAvatarChanged(index);
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _avatarController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_avatarController.position.haveDimensions) {
                    value = _avatarController.page! - index;
                    value = (1 - (value.abs() * 0.45)).clamp(0.55, 1.0);
                  } else {
                    value = index == selectedAvatarIndex ? 1.0 : 0.55;
                  }

                  return Center(
                    child: SizedBox(
                      height: value * 140.h,
                      width: value * 140.w,
                      child: child,
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    _avatarController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: selectedAvatarIndex == index
                          ? Border.all(color: Colors.blue, width: 3.w)
                          : null,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        widget.avatars[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "Avatar",
          style: GoogleFonts.inter(
            color: ColorManager.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}