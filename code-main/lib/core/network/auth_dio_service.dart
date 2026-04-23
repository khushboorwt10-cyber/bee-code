import 'package:beecode/core/network/dio_service.dart';
import 'package:beecode/core/service/auth_service.dart';
import 'package:beecode/screens/auth/model/auth_model.dart';
import 'package:beecode/screens/utils/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthDioService {
  AuthDioService._();
  static final AuthDioService instance = AuthDioService._();

  final Dio _dio = ApiClient.instance.dio;
  final AuthService _firebaseAuth = AuthService.instance;
  final LocalUserService _local = LocalUserService.instance;

  static const _loginEndpoint = '/users/login';
  static const _signUpEndpoint = '/users/signup';
  static const _googleLoginEndpoint = '/users/google';

  // ───────── FCM TOKEN ─────────
  Future<String?> _getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  // ───────── SAVE SESSION ─────────
  Future<void> _persistSession(AuthResponse res) async {
    _dio.options.headers['Authorization'] = 'Bearer ${res.token}';

    await _local.saveToken(res.token);
    await _local.saveUser(
      name: res.user.name,
      email: res.user.email,
      photoUrl: res.user.photoUrl ?? '',
    );
  }

  // ───────── ERROR PARSER ─────────
  String _parseError(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          e.message ??
          'Something went wrong';
    }
    return e.message ?? 'Something went wrong';
  }

  // ───────── LOGIN ─────────
  Future<AuthResponse> login(String email, String password) async {
    try {
      final fcmToken = await _getFcmToken();

      final res = await _dio.post(
        _loginEndpoint,
        data: {
          'email': email,
          'password': password,
          'fcmToken': fcmToken,
        },
      );

      final auth = AuthResponse.fromJson(res.data);
      await _persistSession(auth);
      return auth;
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  // ───────── SIGNUP ─────────
  Future<AuthResponse> signUp(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final fcmToken = await _getFcmToken();

      final res = await _dio.post(
        _signUpEndpoint,
        data: {
          'fullName': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'fcmToken': fcmToken,
        },
      );

      final auth = AuthResponse.fromJson(res.data);
      await _persistSession(auth);
      return auth;
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<AuthResponse?> signInWithGoogle() async {
  try {
    final credential = await _firebaseAuth.signInWithGoogle();
    if (credential == null) return null;

    // ✅ IMPORTANT: force refresh token
    final idToken = await credential.user?.getIdToken(true);

    if (idToken == null || idToken.isEmpty) {
      throw 'Firebase ID token missing';
    }

    final fcmToken = await _getFcmToken();

    print("🔥 Firebase ID TOKEN: $idToken");

    final res = await _dio.post(
      _googleLoginEndpoint,
      data: {
        "idToken": idToken,
        "fcmToken": ?fcmToken,
      },
    );

    final auth = AuthResponse.fromJson(res.data);
    await _persistSession(auth);
    return auth;
  } on DioException catch (e) {
    throw _parseError(e);
  }
}
  Future<void> signOut() async {
    _dio.options.headers.remove('Authorization');
    await Future.wait([
      _firebaseAuth.signOut(),
      _local.clear(),
    ]);
  }

  // ───────── RESTORE SESSION ─────────
  Future<bool> restoreSession() async {
    final token = await _local.getToken();
    if (token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return true;
    }
    return false;
  }
}