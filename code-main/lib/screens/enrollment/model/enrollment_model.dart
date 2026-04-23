
// ── Data Model for document rows ──────────────────────
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class DocItem {
  final String key;
  final String label;
  final String subtitle;
  final IconData icon;
  final Rxn<File> file;
  final bool isRequired;
  final bool isImage;

  DocItem({
    required this.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.file,
    required this.isRequired,
    required this.isImage,
  });
}