import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/courses_model.dart';

class CoursesController extends GetxController {
  final RxBool isLoading = true.obs;

  final RxList<String> domains = <String>['All'].obs;
  final RxString selectedDomain = 'All'.obs;

  final RxString selectedLevel = 'All'.obs;
  final RxString searchQuery = ''.obs;

  final TextEditingController searchController = TextEditingController();

  final RxList<CourseScreenModel> allCourses = <CourseScreenModel>[].obs;

  final List<String> levels = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchCoursesFromApi();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  /// ✅ CATEGORY API (YOUR RESPONSE FIXED)
  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse("https://beecodebackend.onrender.com/api/categories"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List list = data["categories"] ?? [];

        domains.value = [
          'All',
          ...list.map((e) => (e["name"] ?? '').toString()).toList()
        ];
      }
    } catch (e) {
      debugPrint("Category Error: $e");
    }
  }

  /// ✅ COURSE API
  Future<void> fetchCoursesFromApi() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse("https://beecodebackend.onrender.com/api/course"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List list = data["data"] ?? [];

        allCourses.value = list
            .map((e) => CourseScreenModel.fromJson(
            Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ FILTER (SAFE NULL FIX)
  List<CourseScreenModel> get filteredCourses {
    return allCourses.where((c) {
      final matchDomain =
          selectedDomain.value == 'All' || c.domain == selectedDomain.value;

      final matchLevel =
          selectedLevel.value == 'All' || c.level == selectedLevel.value;

      final query = searchQuery.value.toLowerCase();

      final matchSearch = query.isEmpty ||
          (c.title).toLowerCase().contains(query) ||
          (c.institute).toLowerCase().contains(query);

      return matchDomain && matchLevel && matchSearch;
    }).toList();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}