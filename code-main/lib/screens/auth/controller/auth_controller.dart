import 'package:beecode/core/service/auth_service.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _authService = AuthService.instance;

  final Rx<User?> user = Rx<User?>(null);
  bool get isLoggedIn => user.value != null;
  String get displayName => user.value?.displayName ?? 'User';
  String get email => user.value?.email ?? '';
  String? get photoUrl => user.value?.photoURL;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_authService.authStateChanges);
  }
  
  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAllNamed(Routes.loginScreen);
  }
}