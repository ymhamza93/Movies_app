import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/feature/auth_logic/data/firebase_auth_service.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // بنمرر الخدمة في الـ Constructor عشان نحقق الـ Dependency Injection صح
  final FirebaseAuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  // دالة الـ Login
  void login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await _authService.signInWithEmail(email: email, password: password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  // دالة الـ Register
  void register({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await _authService.signUpWithEmail(email: email, password: password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}
