import 'package:beecode/screens/data_science/model/data_science_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataSciencePromotionController extends GetxController {
  final String goal = Get.arguments ?? 'Data Science';

  // ── Paid courses (grid) ────────────────────────────────────────────────────
  final List<CourseModel> courses = const [
    CourseModel(
      isBestseller: true,
      institution: 'IIIT Bangalore',
      logoAsset: 'assets/images/iiitb_logo.png',
      title: 'The Executive Diploma in DS & ML',
      badge: '360° Career Support',
      badgeColor: Color(0xFFE3F0FF),
      badgeTextColor: Color(0xFF1A73E8),
      credentialType: 'Executive PG Program',
      duration: '12 Months',
    ),
    CourseModel(
      isBestseller: false,
      institution: 'IIIT Bangalore',
      logoAsset: 'assets/images/iiitb_logo.png',
      title: 'IIIT Executive Post Graduate Program',
      badge: 'Placement Assistance',
      badgeColor: Color(0xFFE3F0FF),
      badgeTextColor: Color(0xFF1A73E8),
      credentialType: 'Certification',
      duration: '6 Months',
    ),
    CourseModel(
      isBestseller: true,
      institution: 'Liverpool Business School',
      logoAsset: 'assets/images/liverpool_logo.png',
      title: 'MS in Data Science',
      badge: 'Double Credentials',
      badgeColor: Color(0xFFE3F0FF),
      badgeTextColor: Color(0xFF1A73E8),
      credentialType: "Master's Degree",
      duration: '18 Months',
    ),
    CourseModel(
      isBestseller: false,
      institution: 'IIT Madras',
      logoAsset: 'assets/images/iitm_logo.png',
      title: 'PG Certificate in Data Science',
      badge: 'Job Guarantee',
      badgeColor: Color(0xFFE3F0FF),
      badgeTextColor: Color(0xFF1A73E8),
      credentialType: 'PG Certificate',
      duration: '9 Months',
    ),
  ];

  // ── Free courses ───────────────────────────────────────────────────────────
  final List<FreeCourseModel> freeCourses = const [
    FreeCourseModel(
      imageAsset: 'assets/images/free_course_1.png',
      title: 'Learn Basic...',
      description: 'Solve coding questions based on Lists, Strings...',
      duration: '5 Hours',
    ),
    FreeCourseModel(
      imageAsset: 'assets/images/free_course_2.png',
      title: 'Introducti...',
      description: 'Learn how you can transform data into...',
      duration: '8 Hours',
    ),
    FreeCourseModel(
      imageAsset: 'assets/images/free_course_3.png',
      title: 'Fundament...',
      description: 'Learn about cutting-edge ML models like...',
      duration: '28 Hours',
    ),
  ];

  // ── GenAI courses ──────────────────────────────────────────────────────────
  final List<GenAiCourseModel> genAiCourses = const [
    GenAiCourseModel(
      imageAsset: 'assets/images/genai_1.png',
      provider: 'Microsoft',
      title: 'Generative AI...',
      highlight: 'Access to GPT 4.0 credits worth 499',
      credentialType: 'Certification',
      duration: '6 Hours',
      isBestseller: true,
    ),
    GenAiCourseModel(
      imageAsset: 'assets/images/genai_2.png',
      provider: 'Microsoft',
      title: 'Generative AI Maste...',
      highlight: 'Learn to use ChatGPT & Power BI, & more',
      credentialType: 'Certification',
      duration: '2 Months',
      isBestseller: false,
    ),
    GenAiCourseModel(
      imageAsset: 'assets/images/genai_3.png',
      provider: 'Microsoft',
      title: 'Generative AI Maste...',
      highlight: 'Learn to use GitHub copilot, Azure & more',
      credentialType: 'Certification',
      duration: '2 months',
      isBestseller: false,
    ),
  ];

  // ── University partners ────────────────────────────────────────────────────
  final List<String> universityPartners = const [
    'assets/images/iiitb_logo.png',
    'assets/images/loyola_logo.png',
    'assets/images/university_logo.png',
    'assets/images/liverpool_logo.png',
    'assets/images/iitm_logo.png',
  ];
}