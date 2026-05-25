import 'package:flutter_bloc/flutter_bloc.dart';
import 'watchlist_state.dart';
import 'watchlist_service.dart'; // تأكدي من كتابة مسار ملف السيرفيس الصحيح هنا

class WatchlistCubit extends Cubit<WatchlistState> {
  final WatchlistService _watchlistService;

  WatchlistCubit(this._watchlistService) : super(WatchlistInitial());

  // جلب القائمة بالكامل وتحديث الواجهة
  Future<void> fetchWatchlist() async {
    emit(WatchlistLoading());
    try {
      final movies = await _watchlistService.getWatchlist();
      emit(WatchlistSuccess(movies));
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  // إضافة فيلم وإعادة جلب البيانات تلقائياً
  Future<void> addMovie(String movieId, Map<String, dynamic> movieData) async {
    try {
      await _watchlistService.addToWatchlist(movieId: movieId, movieData: movieData);
     await fetchWatchlist();
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  // حذف فيلم وإعادة جلب البيانات تلقائياً
  Future<void> removeMovie(String movieId) async {
    try {
      await _watchlistService.removeFromWatchlist(movieId: movieId);
      fetchWatchlist();
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  // فحص حالة الفيلم الحالي لشاشة التفاصيل
  Future<bool> checkMovieStatus(String movieId) async {
    return await _watchlistService.isMovieInWatchlist(movieId);
  }
}