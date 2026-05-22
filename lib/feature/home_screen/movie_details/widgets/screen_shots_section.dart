import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/color_manager.dart';

class ScreenShotsSection extends StatelessWidget {
  final List<String> screenshots;

  const ScreenShotsSection({super.key, required this.screenshots});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Screen Shots',

          style: TextStyle(
            color: ColorManager.white,

            fontSize: MediaQuery.of(context).size.width * .055,

            fontWeight: FontWeight.bold,

            decoration: TextDecoration.none,
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * .02),

        ListView.separated(
          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * .03,
              ),

              child: Image.network(
                screenshots[index],
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .18,
                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .18,
                    color: const Color(0xff282A28),
                    child: const Icon(Icons.broken_image, color: Colors.white),
                  );
                },
              ),
            );
          },

          separatorBuilder: (_, __) {
            return SizedBox(height: MediaQuery.of(context).size.height * .015);
          },

          itemCount: screenshots.length,
        ),
      ],
    );
  }
}
