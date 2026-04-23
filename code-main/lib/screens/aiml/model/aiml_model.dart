import 'package:flutter/material.dart';

class AiModel {
  final String university;
  final String title;
  final String badge;
  final Color badgeColor;
  final List<String> features;

  AiModel({
    required this.university,
    required this.title,
    required this.badge,
    required this.badgeColor,
    required this.features,
  });
}