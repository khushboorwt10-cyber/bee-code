// lib/screens/beebites/model/beebites_model.dart

import 'dart:ui';

import 'package:flutter/material.dart';

class BeeBitesModel {
  final String id;
  final String videoUrl;
  final String authorName;
  final String title;
  final String likes;
  final String views;
  final String duration;

  const BeeBitesModel({
    required this.id,
    required this.videoUrl,
    required this.authorName,
    required this.title,
    required this.likes,
    required this.views,
    required this.duration,
  });
}



class CourseModel {
  final String id;
  final String title;
  final String subtitle;
  final String duration;
  final String lessons;
  final String level;
  final String instructor;
  final Color color;
  final IconData icon;

  const CourseModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.lessons,
    required this.level,
    required this.instructor,
    required this.color,
    required this.icon,
  });
}
final List<CourseModel> dummyCourses = [
  const CourseModel(
    id: '1',
    title: 'Flutter for Beginners',
    subtitle: 'Build your first cross-platform app from scratch',
    duration: '12h 30m',
    lessons: '42 lessons',
    level: 'Beginner',
    instructor: 'BeeCode Team',
    color: Color(0xFF2563EB),
    icon: Icons.phone_android_rounded,
  ),
  const CourseModel(
    id: '2',
    title: 'GetX Mastery',
    subtitle: 'State management, routing & dependency injection',
    duration: '8h 15m',
    lessons: '28 lessons',
    level: 'Intermediate',
    instructor: 'BeeCode Team',
    color: Color(0xFF7C3AED),
    icon: Icons.bolt_rounded,
  ),
  const CourseModel(
    id: '3',
    title: 'Dart Advanced',
    subtitle: 'Futures, Streams, Isolates & null safety',
    duration: '10h 00m',
    lessons: '35 lessons',
    level: 'Advanced',
    instructor: 'BeeCode Team',
    color: Color(0xFF059669),
    icon: Icons.code_rounded,
  ),
  const CourseModel(
    id: '4',
    title: 'Firebase & Flutter',
    subtitle: 'Auth, Firestore, Storage & Cloud Functions',
    duration: '14h 45m',
    lessons: '50 lessons',
    level: 'Intermediate',
    instructor: 'BeeCode Team',
    color: Color(0xFFEA580C),
    icon: Icons.cloud_rounded,
  ),
  const CourseModel(
    id: '5',
    title: 'Flutter Animations',
    subtitle: 'Tween, Hero, Lottie & custom painters',
    duration: '6h 20m',
    lessons: '22 lessons',
    level: 'Intermediate',
    instructor: 'BeeCode Team',
    color: Color(0xFFDB2777),
    icon: Icons.animation_rounded,
  ),
];