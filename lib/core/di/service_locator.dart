import 'package:get_it/get_it.dart';
import 'package:movies_app/feature/auth_logic/auth_cubit.dart';
import 'package:movies_app/feature/auth_logic/data/firebase_auth_service.dart';


// 1. إنشاء نسخة (Instance) عالمية من GetIt
final getIt = GetIt.instance;

// 2. دالة تسجيل كل الـ Services والـ Cubits في التطبيق
void setupServiceLocator() {

  // تسجيل خدمة الفايربيز كـ Singleton (تنشأ مرة واحدة فقط في التطبيق كله وتفضل عايشة)
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());

  // تسجيل الـ AuthCubit كـ Factory (ينشأ نسخة جديدة منه كل ما تفتحي الشاشة ويتمسح لما تقفليها)
  // وبنمرر له الـ FirebaseAuthService تلقائياً عن طريق getIt()
  getIt.registerFactory(() => AuthCubit(getIt<FirebaseAuthService>()));
}