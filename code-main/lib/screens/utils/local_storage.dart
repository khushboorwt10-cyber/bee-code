
// lib/screens/utils/local_storage.dart
//
// Extends original LocalUserService with token save/get helpers
// needed by AuthDioService.

import 'package:shared_preferences/shared_preferences.dart';

class LocalUserService {
  LocalUserService._();
  static final LocalUserService instance = LocalUserService._();

  static const _keyName      = 'local_user_name';
  static const _keyEmail     = 'local_user_email';
  static const _keyPhone     = 'local_user_phone';
  static const _keyPhotoUrl  = 'local_user_photo';
  static const _keyLoggedIn  = 'local_user_logged_in';
  static const _keyToken     = 'local_user_token'; // ← NEW

  Future<void> saveUser({
    required String name,
    required String email,
    String phone    = '',
    String photoUrl = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName,    name);
    await prefs.setString(_keyEmail,   email);
    await prefs.setString(_keyPhone,   phone);
    await prefs.setString(_keyPhotoUrl, photoUrl);
    await prefs.setBool(_keyLoggedIn,  true);
  }

  // ── Token helpers (NEW) ───────────────────────────────────────────────────

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken) ?? '';
  }

  // ── Existing helpers ──────────────────────────────────────────────────────

  Future<void> updateName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }

  Future<void> updatePhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhone, phone);
  }

  Future<void> updatePhotoUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhotoUrl, url);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPhone);
    await prefs.remove(_keyPhotoUrl);
    await prefs.remove(_keyToken); // ← clear token too
    await prefs.setBool(_keyLoggedIn, false);
  }

  Future<Map<String, String>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name':     prefs.getString(_keyName)     ?? '',
      'email':    prefs.getString(_keyEmail)    ?? '',
      'phone':    prefs.getString(_keyPhone)    ?? '',
      'photoUrl': prefs.getString(_keyPhotoUrl) ?? '',
    };
  }

  Future<bool> get isLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }
}

// import 'package:shared_preferences/shared_preferences.dart';

// /// Stores email/password user details locally.
// /// Used when Firebase Email/Password auth is not connected.
// class LocalUserService {
//   LocalUserService._();
//   static final LocalUserService instance = LocalUserService._();

//   static const _keyName      = 'local_user_name';
//   static const _keyEmail     = 'local_user_email';
//   static const _keyPhone     = 'local_user_phone';
//   static const _keyPhotoUrl  = 'local_user_photo';
//   static const _keyLoggedIn  = 'local_user_logged_in';

//   Future<void> saveUser({
//     required String name,
//     required String email,
//     String phone    = '',
//     String photoUrl = '',
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyName,     name);
//     await prefs.setString(_keyEmail,    email);
//     await prefs.setString(_keyPhone,    phone);
//     await prefs.setString(_keyPhotoUrl, photoUrl);
//     await prefs.setBool(_keyLoggedIn,   true);
//   }

//   Future<void> updateName(String name) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyName, name);
//   }

//   Future<void> updatePhone(String phone) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyPhone, phone);
//   }

//   Future<void> updatePhotoUrl(String url) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyPhotoUrl, url);
//   }

//   Future<void> clear() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_keyName);
//     await prefs.remove(_keyEmail);
//     await prefs.remove(_keyPhone);
//     await prefs.remove(_keyPhotoUrl);
//     await prefs.setBool(_keyLoggedIn, false);
//   }

//   Future<Map<String, String>> getUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     return {
//       'name':     prefs.getString(_keyName)     ?? '',
//       'email':    prefs.getString(_keyEmail)    ?? '',
//       'phone':    prefs.getString(_keyPhone)    ?? '',
//       'photoUrl': prefs.getString(_keyPhotoUrl) ?? '',
//     };
//   }

//   Future<bool> get isLoggedIn async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_keyLoggedIn) ?? false;
//   }
// }