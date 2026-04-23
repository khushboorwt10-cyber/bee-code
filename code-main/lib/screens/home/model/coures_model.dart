
import 'package:flutter/material.dart';

class CourseCategory {
  final String id;
  final String name;
  
  CourseCategory({
    required this.id,
    required this.name,
  });
  
  factory CourseCategory.fromJson(Map<String, dynamic> json) => CourseCategory(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
  );
}
class CarouselItem {
  final String? imageUrl;   
  const CarouselItem({
    this.imageUrl,
  });
}
class CourseCategoryCard {
  final String title;
  final String courses;
  final IconData icon;
  final List<Color> gradient;
  final String route;

  CourseCategoryCard({
    required this.title,
    required this.courses,
    required this.icon,
    required this.gradient,
    required this.route,
  });
}

