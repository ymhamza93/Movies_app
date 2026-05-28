import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/color_manager.dart';

class GenreItem extends StatelessWidget {
  GenreItem({
    super.key,
    required this.selectedGenre,
    required this.onGenreSelected,
  });

  final String selectedGenre;
  final Function(String) onGenreSelected;

  final List<String> genres = [
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Horror',
    'Romance',
    'Sci-Fi',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .06,

      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,

        itemBuilder: (context, index) {
          bool isSelected = selectedGenre == genres[index];

          return Padding(
            padding: const EdgeInsets.only(left: 8),

            child: InkWell(
              borderRadius: BorderRadius.circular(16),

              onTap: () {
                onGenreSelected(genres[index]);
              },

              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: ColorManager.yellow),

                  color: isSelected ? ColorManager.yellow : Colors.transparent,
                ),

                child: Text(
                  genres[index],

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,

                    color: isSelected ? Colors.black : ColorManager.yellow,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
