// lib/screens/utils/api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Replace with your actual API base URL
  static const String baseUrl = 'https://beecodebackend.onrender.com';
  
  // Get headers with optional auth token
  static Map<String, String> getHeaders({bool requiresAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (requiresAuth) {
      final token = getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
  
  // Get stored token (implement based on your auth system)
  static String? getToken() {
    // TODO: Implement token retrieval from SharedPreferences or GetStorage
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString('auth_token');
    return null;
  }
  
  // GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('📡 GET: $uri');
      
      final response = await http.get(
        uri,
        headers: getHeaders(),
      ).timeout(const Duration(seconds: 30));
      
      debugPrint('📥 Response status: ${response.statusCode}');
      
      return _handleResponse(response);
      
    } catch (e) {
      debugPrint('❌ GET request failed: $e');
      throw Exception('GET request failed: $e');
    }
  }
  
  // POST request
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('📡 POST: $uri');
      debugPrint('📦 Body: $data');
      
      final response = await http.post(
        uri,
        headers: getHeaders(),
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));
      
      debugPrint('📥 Response status: ${response.statusCode}');
      
      return _handleResponse(response);
      
    } catch (e) {
      debugPrint('❌ POST request failed: $e');
      throw Exception('POST request failed: $e');
    }
  }
  
  // PUT request
  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('📡 PUT: $uri');
      
      final response = await http.put(
        uri,
        headers: getHeaders(),
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));
      
      return _handleResponse(response);
      
    } catch (e) {
      debugPrint('❌ PUT request failed: $e');
      throw Exception('PUT request failed: $e');
    }
  }
  
  // DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('📡 DELETE: $uri');
      
      final response = await http.delete(
        uri,
        headers: getHeaders(),
      ).timeout(const Duration(seconds: 30));
      
      return _handleResponse(response);
      
    } catch (e) {
      debugPrint('❌ DELETE request failed: $e');
      throw Exception('DELETE request failed: $e');
    }
  }
  
  // Handle API response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final Map<String, dynamic> data = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        final errorMessage = data['message'] ?? 
                            data['error'] ?? 
                            'Request failed with status ${response.statusCode}';
        throw Exception(errorMessage);
      }
      
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to parse response: $e');
    }
  }
}