// lib/screens/utils/api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://beecodebackend.onrender.com';

  // =========================
  // TOKEN
  // =========================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // =========================
  // HEADERS (FIXED)
  // =========================
  static Future<Map<String, String>> getHeaders({
    bool requiresAuth = false,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // =========================
  // GET
  // =========================
  static Future<Map<String, dynamic>> get(
      String endpoint, {
        bool requiresAuth = false,
      }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('📡 GET: $uri');

      final headers = await getHeaders(requiresAuth: requiresAuth);

      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      debugPrint('📥 Response: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ GET error: $e');
      throw Exception('GET request failed: $e');
    }
  }

  // =========================
  // POST
  // =========================
  static Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> data, {
        bool requiresAuth = false,
      }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('📡 POST: $uri');

      final headers = await getHeaders(requiresAuth: requiresAuth);

      final response = await http
          .post(uri, headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 30));

      debugPrint('📥 Response: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ POST error: $e');
      throw Exception('POST request failed: $e');
    }
  }

  // =========================
  // PUT
  // =========================
  static Future<Map<String, dynamic>> put(
      String endpoint,
      Map<String, dynamic> data, {
        bool requiresAuth = false,
      }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final headers = await getHeaders(requiresAuth: requiresAuth);

      final response = await http
          .put(uri, headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ PUT error: $e');
      throw Exception('PUT request failed: $e');
    }
  }

  // =========================
  // DELETE
  // =========================
  static Future<Map<String, dynamic>> delete(
      String endpoint, {
        bool requiresAuth = false,
      }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final headers = await getHeaders(requiresAuth: requiresAuth);

      final response = await http
          .delete(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ DELETE error: $e');
      throw Exception('DELETE request failed: $e');
    }
  }

  // =========================
  // RESPONSE HANDLER
  // =========================
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        final msg = data['message'] ??
            data['error'] ??
            'Request failed (${response.statusCode})';
        throw Exception(msg);
      }
    } catch (e) {
      throw Exception('Invalid response format: $e');
    }
  }
}