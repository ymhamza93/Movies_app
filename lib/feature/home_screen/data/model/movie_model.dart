class MovieModel {
  int id;
  String title;
  String image;
  double rating;
  int year;
  int runtime;
  List<String> genres;

  MovieModel({
    required this.id,
    required this.title,
    required this.image,
    required this.rating,
    required this.year,
    required this.runtime,
    required this.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['medium_cover_image'] ?? '',
      year: json['year'] ?? 0,

      rating: json['rating'] == null ? 0 : (json['rating'] as num).toDouble(),

      runtime: json['runtime'] is int ? json['runtime'] : 0,
      genres: List<String>.from(json['genres'] ?? []),
    );
  }
}
