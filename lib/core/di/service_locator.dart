import 'package:get_it/get_it.dart';
import 'package:movies_app/feature/auth_logic/auth_cubit.dart';
import 'package:movies_app/feature/auth_logic/data/firebase_auth_service.dart';



final getIt = GetIt.instance;

void setupServiceLocator() {

  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());

  getIt.registerFactory(() => AuthCubit(getIt<FirebaseAuthService>()));
}