import 'package:flutter/material.dart';
import 'package:movies_app/feature/home_screen/data/api/movie_api_service.dart';
import 'package:movies_app/feature/home_screen/data/model/movie_model.dart';

class MovieGridView extends StatelessWidget {
  const MovieGridView({super.key, required this.genre});

  final String genre;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<MovieModel>>(
        future: MovieApiService.getMoviesByGenre(genre),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final movies = snapshot.data ?? [];

          return GridView.builder(
            itemCount: movies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 189 / 279,
            ),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  movies[index].image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.white);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
