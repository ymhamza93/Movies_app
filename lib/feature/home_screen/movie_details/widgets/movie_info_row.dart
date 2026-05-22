import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/feature/home_screen/data/model/movie_model.dart';

class MovieInfoRow extends StatelessWidget {
  final MovieModel movie;
  final int likes;

  const MovieInfoRow({super.key, required this.movie, required this.likes});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MovieInfoItem(icon: Icons.favorite, text: likes.toString()),
        MovieInfoItem(icon: Icons.access_time, text: movie.runtime.toString()),

        MovieInfoItem(icon: Icons.star, text: movie.rating.toString()),
      ],
    );
  }
}

class MovieInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const MovieInfoItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .29,
      height: MediaQuery.of(context).size.height * .047,
      decoration: BoxDecoration(
        color: const Color(0xff282A28),
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * .035,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: ColorManager.yellow,
            size: MediaQuery.of(context).size.width * .06,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * .025),
          Text(
            text,
            style: TextStyle(
              color: ColorManager.white,
              fontSize: MediaQuery.of(context).size.width * .045,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
