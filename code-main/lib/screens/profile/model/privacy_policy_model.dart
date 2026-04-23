// ─────────────────────────────────────────────
// MODEL — privacy_policy_model.dart
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';

class PrivacyPolicySection {
  final String id;
  final IconData icon;
  final String title;
  final String short;
  final String content;

  const PrivacyPolicySection({
    required this.id,
    required this.icon,
    required this.title,
    required this.short,
    required this.content,
  });
}

class PrivacyPolicyModel {
  final String lastUpdated;
  final String version;
  final String contactEmail;
  final List<PrivacyPolicySection> sections;

  const PrivacyPolicyModel({
    required this.lastUpdated,
    required this.version,
    required this.contactEmail,
    required this.sections,
  });
}