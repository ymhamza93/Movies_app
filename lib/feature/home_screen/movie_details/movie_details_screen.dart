import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/utils/assets_manager.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/feature/home_screen/data/api/movie_api_service.dart';
import 'package:movies_app/feature/home_screen/movie_details/cast_section.dart';
import 'package:movies_app/feature/home_screen/movie_details/genres_section.dart';
import 'package:movies_app/feature/home_screen/movie_details/widgets/movie_info_row.dart';
import 'package:movies_app/feature/home_screen/movie_details/widgets/screen_shots_section.dart';
import 'package:movies_app/feature/home_screen/data/model/movie_model.dart';
import 'package:movies_app/feature/home_screen/movie_details/widgets/similar_section.dart';
import 'package:movies_app/feature/home_screen/movie_details/widgets/summary_section.dart';
import 'package:movies_app/feature/home_screen/profile_tab/history_list/history_cubit.dart';
import 'package:movies_app/feature/home_screen/profile_tab/watch_list/watchlist_button.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // MovieApiService.getMovieDetails(movie.id).then((value) {
    //   print(value);
    // });
    context.read<HistoryCubit>().addMovieToHistory({
      'id': movie.id.toString(),
      'poster': movie.image,
      'rating': movie.rating.toString(),
    });
    return FutureBuilder<Map<String, dynamic>>(
      future: MovieApiService.getMovieDetails(movie.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final details = snapshot.data ?? {};

        return Stack(
          children: [
            Positioned.fill(
              child: Image.network(movie.image, fit: BoxFit.cover),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),

                          WatchlistButton(movie: movie),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .62,
                        child: Stack(
                          children: [
                            Center(child: Image.asset(AssetsManager.playIcon)),

                            Positioned(
                              bottom: MediaQuery.of(context).size.height * .03,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    movie.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: ColorManager.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        .01,
                                  ),
                                  Text(
                                    movie.year.toString(),
                                    style: const TextStyle(
                                      color: Color(0xFFADADAD),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //watch
                      SizedBox(
                        width: double.infinity,
                        // width: MediaQuery.of(context).size.width * .925,
                        height: MediaQuery.of(context).size.height * .062,

                        child: ElevatedButton(
                          onPressed: () {},

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * .035,
                              ),
                            ),
                          ),

                          child: Text(
                            'Watch',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .025,
                      ),

                      MovieInfoRow(
                        movie: movie,
                        likes: details['like_count'] ?? 0,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .025,
                      ),

                      ScreenShotsSection(
                        screenshots: [
                          details['large_screenshot_image1'] ?? '',
                          details['large_screenshot_image2'] ?? '',
                          details['large_screenshot_image3'] ?? '',
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),

                      SimilarSection(movieId: movie.id),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      SummarySection(
                        summary: details['description_intro'] ?? movie.title,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      CastSection(cast: details['cast'] ?? []),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      GenresSection(
                        genres: List<String>.from(
                          details['genres'] ?? movie.genres,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
