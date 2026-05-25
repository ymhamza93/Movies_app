import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WatchlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // إضافة فيلم إلى قائمة الأمنيات (Sub-collection)
  Future<void> addToWatchlist({required String movieId, required Map<String, dynamic> movieData}) async {
    try {
      final user = _firebaseAuth.currentUser;

      // 🌟 سطر كشف حالة المستخدم
      print("🎬 [WatchlistService] Current User UID: ${user?.uid}");

      if (user != null) {
        print("⏳ [WatchlistService] Attempting to write to Firestore for Movie ID: $movieId");

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('watchlist')
            .doc(movieId)
            .set(movieData);

        print("✅ [WatchlistService] Successfully wrote to Firestore!");
      } else {
        print("❌ [WatchlistService] Failed: User is NULL");
        throw Exception("User not logged in");
      }
    } catch (e) {
      // 🌟 السطر ده هيطبع لكِ الخطأ الحقيقي في الـ Debug Console بالمللي
      print("❌ [WatchlistService] Firestore Catch Error: ${e.toString()}");
      throw Exception("Failed to add to watchlist: ${e.toString()}");
    }
  }

  // حذف فيلم من قائمة الأمنيات
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

  // جلب جميع أفلام المفضلة للمستخدم الحالي
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

  // فحص هل الفيلم مضاف مسبقاً للمفضلة أم لا (لتحديد شكل الأيقونة)
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