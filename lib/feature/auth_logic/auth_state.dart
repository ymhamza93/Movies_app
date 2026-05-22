abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class ProfileLoaded extends AuthState {
  final Map<String, dynamic> userData;
  ProfileLoaded(this.userData);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

}