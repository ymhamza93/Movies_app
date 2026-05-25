sealed class WatchlistState {}

final class WatchlistInitial extends WatchlistState {}

final class WatchlistLoading extends WatchlistState {}

final class WatchlistSuccess extends WatchlistState {
  final List<Map<String, dynamic>> movies;
  WatchlistSuccess(this.movies);
}

final class WatchlistError extends WatchlistState {
  final String message;
  WatchlistError(this.message);
}