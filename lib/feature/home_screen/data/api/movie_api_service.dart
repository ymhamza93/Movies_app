import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_app/feature/home_screen/data/model/movie_model.dart';

class MovieApiService {
  static Future<List<MovieModel>> getMovies() async {
    Uri url = Uri.parse('https://movies-api.accel.li/api/v2/list_movies.json');

    var response = await http.get(url);

    var json = jsonDecode(response.body);

    List moviesJson = json['data']['movies'];

    return moviesJson.map((movie) => MovieModel.fromJson(movie)).toList();
  }

  static Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    Uri url = Uri.parse(
      'https://movies-api.accel.li/api/v2/movie_details.json?movie_id=$movieId&with_images=true&with_cast=true',
    );

    var response = await http.get(url);

    var json = jsonDecode(response.body);

    return json['data']['movie'];
  }

  static Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    Uri url = Uri.parse(
      'https://movies-api.accel.li/api/v2/movie_suggestions.json?movie_id=$movieId',
    );

    var response = await http.get(url);

    var json = jsonDecode(response.body);

    List moviesJson = json['data']['movies'] ?? [];

    return moviesJson.map((movie) => MovieModel.fromJson(movie)).toList();
  }

  static Future<List<MovieModel>> searchMovies(String query) async {
    Uri url = Uri.parse(
      'https://movies-api.accel.li/api/v2/list_movies.json?query_term=$query',
    );

    var response = await http.get(url);

    var json = jsonDecode(response.body);

    List moviesJson = json['data']['movies'] ?? [];

    return moviesJson.map((movie) => MovieModel.fromJson(movie)).toList();
  }

  static Future<List<MovieModel>> getMoviesByGenre(String genre) async {
    Uri url = Uri.parse(
      'https://movies-api.accel.li/api/v2/list_movies.json?genre=$genre',
    );

    var response = await http.get(url);

    var json = jsonDecode(response.body);

    List moviesJson = json['data']['movies'] ?? [];

    return moviesJson.map((movie) => MovieModel.fromJson(movie)).toList();
  }
}
