import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/feature/home_screen/data/model/movie_model.dart';
import 'package:movies_app/feature/home_screen/profile_tab/watch_list/watchlist_cubit.dart';
import 'package:movies_app/feature/home_screen/profile_tab/watch_list/watchlist_state.dart';

class WatchlistButton extends StatefulWidget {
  final MovieModel movie;

  const WatchlistButton({super.key, required this.movie});

  @override
  State<WatchlistButton> createState() => _WatchlistButtonState();
}

class _WatchlistButtonState extends State<WatchlistButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkInitialWatchlistStatus();
  }

  Future<void> _checkInitialWatchlistStatus() async {
    final movieId = widget.movie.id.toString();
    final status = await context.read<WatchlistCubit>().checkMovieStatus(
      movieId,
    );
    if (mounted) {
      setState(() {
        isFavorite = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchlistCubit, WatchlistState>(
      listener: (context, state) {
        if (state is WatchlistSuccess) {
          _checkInitialWatchlistStatus();
        }
        if (state is WatchlistError) {}
      },
      builder: (context, state) {
        return IconButton(
          onPressed: () async {
            final movieId = widget.movie.id.toString();

            setState(() {
              isFavorite = !isFavorite;
            });

            if (isFavorite) {
              await context.read<WatchlistCubit>().addMovie(movieId, {
                'id': movieId,
                'title': widget.movie.title,
                'poster': widget.movie.image,
                'rating': widget.movie.rating.toString(),
              });

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Added to Watchlist"),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            } else {
              await context.read<WatchlistCubit>().removeMovie(movieId);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Removed from Watchlist"),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }
          },
          icon: Icon(
            isFavorite ? Icons.bookmark : Icons.bookmark_border,
            color: isFavorite ? Colors.yellow : Colors.white,
            size: 30,
          ),
        );
      },
    );
  }
}
