import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/feature/home_screen/movie_details/movie_details_screen.dart';
import 'package:movies_app/feature/home_screen/data/model/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(20),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movie: movie),
            ),
          );
        },

        child: Container(
          width: MediaQuery.of(context).size.width * .32,

          margin: const EdgeInsets.only(right: 12),

          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),

                child: Image.network(
                  movie.image,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),

              Positioned(
                top: 8,
                left: 8,

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.7),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Row(
                    children: [
                      Text(
                        movie.rating.toString(),

                        style: const TextStyle(
                          color: ColorManager.white,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(width: 4),

                      const Icon(
                        Icons.star,
                        color: ColorManager.yellow,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
