
import 'dart:ui';

class MbaCourse {
  final String universityLogo;
  final String universityName;
  final String title;
  final String? badge;
  final Color? badgeColor;
  final String degreeType;
  final String duration;
  final String? tag; 

  const MbaCourse({
    required this.universityLogo,
    required this.universityName,
    required this.title,
    this.badge,
    this.badgeColor,
    required this.degreeType,
    required this.duration,
    this.tag,
  });
}
