import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/color_manager.dart';

class GenresSection extends StatelessWidget {
  final List<String> genres;

  const GenresSection({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Genres',
          style: TextStyle(
            color: ColorManager.white,
            fontSize: MediaQuery.of(context).size.width * .055,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * .015),

        Wrap(
          spacing: MediaQuery.of(context).size.width * .03,
          runSpacing: MediaQuery.of(context).size.height * .012,
          children: genres.map((genre) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .045,
                vertical: MediaQuery.of(context).size.height * .012,
              ),
              decoration: BoxDecoration(
                color: const Color(0xff282A28),
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * .035,
                ),
              ),
              child: Text(
                genre,
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: MediaQuery.of(context).size.width * .04,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
