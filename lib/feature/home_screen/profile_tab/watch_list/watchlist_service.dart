import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WatchlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> addToWatchlist({
    required String movieId,
    required Map<String, dynamic> movieData,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('watchlist')
            .doc(movieId)
            .set(movieData);
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      throw Exception("Failed to add to watchlist: ${e.toString()}");
    }
  }

  Future<void> removeFromWatchlist({required String movieId}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('watchlist')
            .doc(movieId)
            .delete();
      }
    } catch (e) {
      throw Exception("Failed to remove from watchlist: ${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlist() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('watchlist')
            .get();

        return snapshot.docs.map((doc) => doc.data()).toList();
      }
      return [];
    } catch (e) {
      throw Exception("Failed to fetch watchlist: ${e.toString()}");
    }
  }

  Future<bool> isMovieInWatchlist(String movieId) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('watchlist')
            .doc(movieId)
            .get();

        return doc.exists;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
