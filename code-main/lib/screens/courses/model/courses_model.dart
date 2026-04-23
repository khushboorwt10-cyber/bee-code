class CourseScreenModel {
  final String id; // 👈 ADD THIS
  final String logo;
  final String institute;
  final String title;
  final String tag;
  final String type;
  final String duration;
  final String level;
  final String domain;

  CourseScreenModel({
    required this.id,
    required this.logo,
    required this.institute,
    required this.title,
    required this.tag,
    required this.type,
    required this.duration,
    required this.level,
    required this.domain,
  });

  factory CourseScreenModel.fromJson(Map<String, dynamic> json) {
    return CourseScreenModel(
      id: json["_id"] ?? "",   // 👈 IMPORTANT
      logo: json["instituteLogo"] ?? "",
      institute: json["instituteName"] ?? "Unknown Institute",
      title: json["title"] ?? "No Title",
      tag: json["subtitle"] ?? "Course",
      type: json["category"]?["name"] ?? "General",
      duration: json["duration"]?.toString() ?? "0",
      level: json["level"] ?? "Beginner",
      domain: json["category"]?["name"] ?? "All",
    );
  }
}