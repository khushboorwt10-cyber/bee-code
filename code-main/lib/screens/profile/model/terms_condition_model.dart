import 'package:flutter/material.dart';

class TermsSection {
  final String id;
  final IconData icon;
  final String title;
  final String short;
  final String content;

  const TermsSection({
    required this.id,
    required this.icon,
    required this.title,
    required this.short,
    required this.content,
  });
}

class TermsConditionModel {
  final String lastUpdated;
  final String version;
  final String contactEmail;
  final List<TermsSection> sections;

  const TermsConditionModel({
    required this.lastUpdated,
    required this.version,
    required this.contactEmail,
    required this.sections,
  });
}