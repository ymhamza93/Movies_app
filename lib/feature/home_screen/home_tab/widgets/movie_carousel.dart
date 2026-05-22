import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/feature/home_screen/data/api/movie_api_service.dart';
import 'package:movies_app/feature/home_screen/data/model/movie_model.dart';
import 'package:movies_app/feature/home_screen/movie_details/movie_details_screen.dart';

class MovieCarousel extends StatelessWidget {
  const MovieCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MovieModel>>(
      future: MovieApiService.getMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        List<MovieModel> movies = snapshot.data ?? [];

        return CarouselSlider.builder(
          itemCount: movies.length,
          itemBuilder: (context, index, realIndex) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailsScreen(movie: movies[index]),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        movies[index].image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),

                    Positioned(
                      top: MediaQuery.of(context).size.height * .012,
                      left: MediaQuery.of(context).size.width * .025,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .018,
                          vertical: MediaQuery.of(context).size.height * .004,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              movies[index].rating.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * .035,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .01,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: MediaQuery.of(context).size.width * .04,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * .37,
            enlargeCenterPage: true,
            viewportFraction: 0.72,
          ),
        );
      },
    );
  }
}
