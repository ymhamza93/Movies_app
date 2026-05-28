import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/feature/home_screen/browse_tab/widgets/genre_item.dart';
import 'package:movies_app/feature/home_screen/browse_tab/widgets/movie_gridview.dart';

class BrowseTab extends StatefulWidget {
  const BrowseTab({super.key});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  String selectedGenre = 'Action';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GenreItem(
                selectedGenre: selectedGenre,

                onGenreSelected: (genre) {
                  setState(() {
                    selectedGenre = genre;
                  });
                },
              ),

              SizedBox(height: MediaQuery.of(context).size.height * .027),

              MovieGridView(genre: selectedGenre),
            ],
          ),
        ),
      ),
    );
  }
}
