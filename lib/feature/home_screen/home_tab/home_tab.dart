import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/utils/assets_manager.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/core/utils/routes_manger.dart';
import 'package:movies_app/feature/home_screen/home_tab/widgets/movie_card.dart';
import 'package:movies_app/feature/home_screen/home_tab/widgets/movie_carousel.dart';
import 'package:movies_app/feature/home_screen/data/api/movie_api_service.dart';
import 'package:movies_app/feature/home_screen/data/model/movie_model.dart';
import 'package:movies_app/feature/home_screen/profile_tab/history_list/history_cubit.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Positioned.fill(
          child: Image.asset(AssetsManager.onboarding6, fit: BoxFit.fill),
        ),

        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),
        ),

        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
              ),
            ),
          ),
        ),

        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(AssetsManager.availableNow),
              ),
              MovieCarousel(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: Image.asset(AssetsManager.watchNow),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .032),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Action',
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'See More',
                      style: TextStyle(
                        color: ColorManager.yellow,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              FutureBuilder<List<MovieModel>>(
                future: MovieApiService.getMovies(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  List<MovieModel> movies = snapshot.data ?? [];

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * .22,

                    child: ListView.builder(
                      itemCount: movies.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final currentMovie = movies[index];

                        return GestureDetector(
                          onTap: () {


                            context.read<HistoryCubit>().addMovieToHistory({
                              'id': currentMovie.id?.toString() ?? '',
                              'poster': currentMovie.image ?? '',
                              'rating': currentMovie.rating?.toString() ?? '0.0',
                            });


                            Navigator.pushNamed(
                              context,
                              RouteManager.movieDetailsScreen,
                              arguments: currentMovie,
                            );
                          },
                          child: MovieCard(movie: currentMovie),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
