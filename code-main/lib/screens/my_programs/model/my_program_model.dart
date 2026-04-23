// lib/screens/my_programs/model/enrolled_course_model.dart

class EnrolledCourseModel {
  final String id;
  final String title;
  final String? instructor;
  final String? thumbnailUrl;
  final String? totalDuration; // e.g. "5 hrs 34 mins"
  final double progressPercent; // 0.0 → 1.0

  const EnrolledCourseModel({
    required this.id,
    required this.title,
    this.instructor,
    this.thumbnailUrl,
    this.totalDuration,
    required this.progressPercent,
  });

  factory EnrolledCourseModel.fromJson(Map<String, dynamic> json) {
    return EnrolledCourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      instructor: json['instructor'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      totalDuration: json['total_duration'] as String?,
      progressPercent:
          (json['progress_percent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}