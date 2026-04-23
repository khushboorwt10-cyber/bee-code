// lib/models/course_model.dart

class DoctorateModel {
  final String id;
  final String universityName;
  final String programTitle;
  final String logoAsset;
  final String duration;
  final String level;
  final List<String> tags;
  final bool isPopular;
  final String? syllabusUrl;

  DoctorateModel({
    required this.id,
    required this.universityName,
    required this.programTitle,
    required this.logoAsset,
    required this.duration,
    required this.level,
    required this.tags,
    this.isPopular = false,
    this.syllabusUrl,
  });
}