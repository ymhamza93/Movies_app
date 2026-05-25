import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryState {
  final List<Map<String, dynamic>> watchedMovies;
  HistoryState({required this.watchedMovies});
}

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryState(watchedMovies: []));

  final List<Map<String, dynamic>> _allWatchedMovies = [];
  static const int _maxHistoryLimit = 20;

  void addMovieToHistory(Map<String, dynamic> movieMap) {
    _allWatchedMovies.removeWhere((item) => item['id'] == movieMap['id']);

    _allWatchedMovies.add(movieMap);

    if (_allWatchedMovies.length > _maxHistoryLimit) {
      _allWatchedMovies.removeAt(0);
    }

    emit(
      HistoryState(
        watchedMovies: List<Map<String, dynamic>>.from(_allWatchedMovies),
      ),
    );
  }
}
