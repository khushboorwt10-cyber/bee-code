import 'package:beecode/screens/aiml/model/aiml_model.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiCoursesController extends GetxController {
  final RxInt selectedFilter = 0.obs;

  final List<String> filterOptions = ['All', 'Certification', 'Diploma', 'Masters'];

  final List<AiModel> courses = [
    AiModel(
      university: 'IIIT Bangalore',
      title: 'Executive Post Graduate Programme in Applied AI and Agentic AI',
      badge: 'New Course',
      badgeColor: const Color(0xFF1565C0),
      features: ['Certification', 'Building AI Agent'],
    ),
    AiModel(
      university: 'IIIT Bangalore',
      title: 'Executive Diploma in Machine Learning and AI',
      badge: 'Bestseller',
      badgeColor: const Color(0xFF6A1B9A),
      features: ['Diploma', 'Deep Learning'],
    ),
    AiModel(
      university: 'IIT Roorkee',
      title: 'Post Graduate Certificate Programme in AI and Deep Learning',
      badge: 'Popular',
      badgeColor: const Color(0xFF2E7D32),
      features: ['Certificate', 'Neural Networks'],
    ),
    AiModel(
      university: 'IIT Bombay',
      title: 'M.Tech in Artificial Intelligence',
      badge: 'New Course',
      badgeColor: const Color(0xFF1565C0),
      features: ['Masters Degree', 'Research Focus'],
    ),
    AiModel(
      university: 'IIM Calcutta',
      title: 'Executive Programme in AI for Business',
      badge: 'Bestseller',
      badgeColor: const Color(0xFF6A1B9A),
      features: ['Certification', 'Business Analytics'],
    ),
  ];

  final List<Map<String, String>> heroFeatures = [
    {'text': 'Learn to build smart, real-world models with AI courses'},
    {'text': 'Gain expertise in Deep Learning & GenAI tools and techniques'},
    {'text': 'Learn from top global university faculty and industry mentors'},
    {'text': 'Build real skills with 17+ projects in an Artificial Intelligence course'},
  ];

  void onFilterTap() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: filterOptions.asMap().entries.map((entry) {
                return Obx(() => FilterChip(
                  label: Text(entry.value),
                  selected: selectedFilter.value == entry.key,
                  onSelected: (_) => selectedFilter.value = entry.key,
                  selectedColor:  AppColors.prime,
                  checkmarkColor:  AppColors.prime,
                ));
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void onViewProgram(AiModel course) {
    Get.snackbar(
      'Program Details',
      course.title,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1A1A1A),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }

  void onExploreCourses() {
    // Scroll to courses list
  }
}