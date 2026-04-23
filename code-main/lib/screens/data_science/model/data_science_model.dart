import 'package:flutter/material.dart';

// ── Paid course model ──────────────────────────────────────────────────────────
class CourseModel {
  final bool isBestseller;
  final String institution;
  final String logoAsset;
  final String title;
  final String badge;
  final Color badgeColor;
  final Color badgeTextColor;
  final String credentialType;
  final String duration;

  const CourseModel({
    required this.isBestseller,
    required this.institution,
    required this.logoAsset,
    required this.title,
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.credentialType,
    required this.duration,
  });
}

// ── Free course model ──────────────────────────────────────────────────────────
class FreeCourseModel {
  final String imageAsset;
  final String title;
  final String description;
  final String duration;

  const FreeCourseModel({
    required this.imageAsset,
    required this.title,
    required this.description,
    required this.duration,
  });
}

// ── GenAI course model ─────────────────────────────────────────────────────────
class GenAiCourseModel {
  final String imageAsset;
  final String provider;
  final String title;
  final String highlight;
  final String credentialType;
  final String duration;
  final bool isBestseller;

  const GenAiCourseModel({
    required this.imageAsset,
    required this.provider,
    required this.title,
    required this.highlight,
    required this.credentialType,
    required this.duration,
    required this.isBestseller,
  });
}