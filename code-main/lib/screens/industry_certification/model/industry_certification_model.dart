class CertificationCourse {
  final String universityLogo;
  final String university;
  final String title;
  final String badge;
  final String category;
  final String programLevel;
  final String duration;
  final bool isLogoCircular;

  const CertificationCourse({
    required this.universityLogo,
    required this.university,
    required this.title,
    required this.badge,
    required this.category,
    required this.programLevel,
    required this.duration,
    this.isLogoCircular = false,
  });
}