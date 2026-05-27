import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/utils/preference_manager.dart';
import 'package:movies_app/feature/auth_logic/data/firebase_auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  void getUserProfile() async {
    emit(AuthLoading());
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final snapshot = await _authService.getUserData(currentUser.uid);

        if (snapshot.exists && snapshot.data() != null) {
          emit(ProfileLoaded(snapshot.data()!));
        } else {
          emit(AuthError("User data does not exist in database."));
        }
      } else {
        emit(AuthError("No user currently logged in."));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  void login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await _authService.signInWithEmail(email: email, password: password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  void register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String avatarPath,
  }) async {
    emit(AuthLoading());
    try {
      await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
        avatarPath: avatarPath,
      );

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await _authService.sendPasswordResetEmail(email: email);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<UserCredential?> loginWithGoogleInCubit() async {
    emit(AuthLoading());
    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential != null) {
        emit(AuthSuccess());
        return userCredential;
      } else {
        throw "Sign-in canceled by user";
      }
    } catch (e) {
      if (e.toString().contains("canceled") || e.toString().contains("16")) {
        emit(AuthInitial());
      } else {
        emit(AuthError(e.toString().replaceAll("Exception: ", "")));
      }
      return null;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String avatarPath,
  }) async {
    emit(AuthLoading());
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await _authService.updateUserData(
          uid: currentUser.uid,
          name: name,
          phone: phone,
          avatarPath: avatarPath,
        );

        final snapshot = await _authService.getUserData(currentUser.uid);

        if (snapshot.exists && snapshot.data() != null) {
          emit(ProfileLoaded(snapshot.data()!));
        } else {
          emit(AuthError("Failed to fetch updated data."));
        }
      } else {
        emit(AuthError("No user currently logged in."));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> deleteAccount() async {
    emit(AuthLoading());
    try {
      await _authService.deleteUserAccount();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await signOut();

      await PreferenceManager.saveData(key: 'isLoggedIn', value: false);
    } catch (e) {
      emit(AuthError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}
