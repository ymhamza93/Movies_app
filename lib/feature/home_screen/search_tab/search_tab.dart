import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/assets_manager.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/feature/home_screen/data/api/movie_api_service.dart';
import 'package:movies_app/feature/home_screen/data/model/movie_model.dart';
import 'package:movies_app/feature/home_screen/movie_details/movie_details_screen.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: ColorManager.white),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: ColorManager.white),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: ColorManager.white,
                  ),
                  filled: true,
                  fillColor: const Color(0xff282A28),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * .03,
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),

              SizedBox(height: MediaQuery.of(context).size.height * .03),

              searchText.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Image.asset(
                          AssetsManager.searchEmpty,

                          width: MediaQuery.of(context).size.width * .35,
                        ),
                      ),
                    )
                  : Expanded(
                      child: FutureBuilder<List<MovieModel>>(
                        future: MovieApiService.searchMovies(searchText),

                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          List<MovieModel> movies = snapshot.data ?? [];

                          return GridView.builder(
                            itemCount: movies.length,

                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,

                                  crossAxisSpacing: 12,

                                  mainAxisSpacing: 12,

                                  childAspectRatio: .7,
                                ),

                            itemBuilder: (context, index) {
                              return Material(
                                color: Colors.transparent,

                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),

                                  onTap: () {
                                    Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MovieDetailsScreen(
                                              movie: movies[index],
                                            ),
                                      ),
                                    );
                                  },

                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          movies[index].image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                movies[index].rating.toString(),
                                                style: const TextStyle(
                                                  color: ColorManager.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
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
                              );
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
