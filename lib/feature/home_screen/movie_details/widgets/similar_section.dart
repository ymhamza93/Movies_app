import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/feature/home_screen/data/api/movie_api_service.dart';
import 'package:movies_app/feature/home_screen/data/model/movie_model.dart';
import 'package:movies_app/feature/home_screen/movie_details/movie_details_screen.dart';

class SimilarSection extends StatelessWidget {
  final int movieId;

  const SimilarSection({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Similar',
          style: TextStyle(
            color: ColorManager.white,
            fontSize: MediaQuery.of(context).size.width * .055,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * .02),

        FutureBuilder<List<MovieModel>>(
          future: MovieApiService.getMovieSuggestions(movieId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            List<MovieModel> movies = snapshot.data ?? [];

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movies.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: MediaQuery.of(context).size.width * .03,
                mainAxisSpacing: MediaQuery.of(context).size.height * .015,
                childAspectRatio: .7,
              ),
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * .03,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailsScreen(movie: movies[index]),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * .03,
                      ),
                      child: Image.network(
                        movies[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
