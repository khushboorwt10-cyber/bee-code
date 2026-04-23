class Course {
  final String university;
  final String universityLogo; 
  final String title;
  final String badge;
  final String programType;
  final String duration;
  final String category;
  final String programLevel; 
  final List<String> tags;

  Course({
    required this.university,
    required this.universityLogo,
    required this.title,
    required this.badge,
    required this.programType,
    required this.duration,
    required this.category,
    required this.programLevel,
    this.tags = const [],
  });
}
