
// learning_model.dart

class CourseBadgeModel {
  final String label;
  final bool isFree;
  const CourseBadgeModel({required this.label, this.isFree = false});
}

class LessonModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String duration;
  final bool isPreview;
  final bool isCompleted;
  final bool isLocked;

  const LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.duration,
    this.isPreview = false,
    this.isCompleted = false,
    this.isLocked = false,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['video'] ?? '',
      duration: json['duration']?.toString() ?? '0',
      isPreview: json['isPreview'] ?? false,
      isCompleted: false,
      isLocked: false,
    );
  }
}

class CourseSectionModel {
  final String id;
  final String title;
  final String duration;
  final bool isSpecialization;
  final bool isLocked;
  final List<LessonModel> lessons;

  const CourseSectionModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.isSpecialization,
    required this.isLocked,
    required this.lessons,
  });

  int get totalVideos => lessons.length;
  int get completedVideos => lessons.where((l) => l.isCompleted).length;

  factory CourseSectionModel.fromJson(Map<String, dynamic> json) {
    final topics = json['topics'] as List<dynamic>? ?? [];
    return CourseSectionModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      duration: json['duration']?.toString() ?? '0',
      isSpecialization: json['isSpecialization'] ?? false,
      isLocked: false,
      lessons: topics.map((t) => LessonModel.fromJson(t)).toList(),
    );
  }
}

class AssessmentModel {
  final String id;
  final String title;
  final int totalItems;
  final bool isLocked;
  final int passingScore;

  const AssessmentModel({
    required this.id,
    required this.title,
    required this.totalItems,
    this.isLocked = true,
    this.passingScore = 70,
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) {
    return AssessmentModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      totalItems: json['totalQuestions'] ?? 0,
      isLocked: json['isLocked'] ?? true,
      passingScore: json['passingScore'] ?? 70,
    );
  }
}

class CertificateOfferModel {
  final String price;
  final String priceNote;
  final String description;
  final String sampleImageUrl;

  const CertificateOfferModel({
    required this.price,
    required this.priceNote,
    required this.description,
    this.sampleImageUrl = '',
  });
}

class ResumeInfoModel {
  final String lessonTitle;
  final String timeLeft;
  final String lessonId;

  const ResumeInfoModel({
    required this.lessonTitle,
    required this.timeLeft,
    required this.lessonId,
  });
}

class FeaturesModel {
  final bool careerSupport;
  final int projects;
  final int alumni;

  const FeaturesModel({
    required this.careerSupport,
    required this.projects,
    required this.alumni,
  });

  factory FeaturesModel.fromJson(Map<String, dynamic> json) {
    return FeaturesModel(
      careerSupport: json['careerSupport'] ?? false,
      projects: json['projects'] ?? 0,
      alumni: json['alumni'] ?? 0,
    );
  }
}

class CertificateModel {
  final String title;
  final String issuedBy;
  final String sampleImage;

  const CertificateModel({
    required this.title,
    required this.issuedBy,
    required this.sampleImage,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      title: json['title'] ?? '',
      issuedBy: json['issuedBy'] ?? '',
      sampleImage: json['sampleImage'] ?? '',
    );
  }
}

class CourseDetailModel {
  final String courseId;
  final String title;
  final String subtitle;
  final String description;
  final String thumbnailUrl;
  final String bannerUrl;
  final String previewVideo;
  final String instituteName;
  final String instituteLogoUrl;
  final String level;
  final String duration;
  final double price;
  final double discountPrice;
  final bool isFree;
  final double rating;
  final int totalRatings;
  final int totalStudents;
  final String emi;
  final CertificateModel certificate;
  final FeaturesModel features;
  final List<CourseSectionModel> sections;
  final CertificateOfferModel certificateOffer;
  final ResumeInfoModel resumeInfo;

  // Computed properties
  int get totalVideos => sections.fold(0, (sum, s) => sum + s.totalVideos);
  int get completedVideos => sections.fold(0, (sum, s) => sum + s.completedVideos);
  double get progressPercent => totalVideos == 0 ? 0.0 : completedVideos / totalVideos;
  
  int get totalAssessments => 0; // Will be set separately
  int get completedAssessments => 0;
  
  CourseBadgeModel get badge => CourseBadgeModel(
    label: isFree ? 'FREE' : 'PREMIUM',
    isFree: isFree,
  );

  const CourseDetailModel({
    required this.courseId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.thumbnailUrl,
    required this.bannerUrl,
    required this.previewVideo,
    required this.instituteName,
    required this.instituteLogoUrl,
    required this.level,
    required this.duration,
    required this.price,
    required this.discountPrice,
    required this.isFree,
    required this.rating,
    required this.totalRatings,
    required this.totalStudents,
    required this.emi,
    required this.certificate,
    required this.features,
    required this.sections,
    required this.certificateOffer,
    required this.resumeInfo,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    // Parse sections/steps
    final steps = json['steps'] as List<dynamic>? ?? [];
    final sections = steps.map((s) => CourseSectionModel.fromJson(s)).toList();

    // Get first unlocked lesson for resume info
    String resumeLessonId = '';
    String resumeLessonTitle = '';
    String resumeTimeLeft = '';
    
    for (final section in sections) {
      for (final lesson in section.lessons) {
        if (!lesson.isLocked) {
          resumeLessonId = lesson.id;
          resumeLessonTitle = lesson.title;
          resumeTimeLeft = lesson.duration;
          break;
        }
      }
      if (resumeLessonId.isNotEmpty) break;
    }

    return CourseDetailModel(
      courseId: json['_id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail']?['url'] ?? '',
      bannerUrl: json['bannerImage']?['url'] ?? '',
      previewVideo: json['video'] ?? '',
      instituteName: json['instituteName'] ?? '',
      instituteLogoUrl: json['instituteLogo'] ?? '',
      level: json['level'] ?? 'Beginner',
      duration: json['duration']?.toString() ?? '0',
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] ?? 0).toDouble(),
      isFree: json['isFree'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      totalRatings: json['totalRatings'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
      emi: json['emi']?.toString() ?? '0',
      certificate: CertificateModel.fromJson(json['certificate'] ?? {}),
      features: FeaturesModel.fromJson(json['features'] ?? {}),
      sections: sections,
      certificateOffer: CertificateOfferModel(
        price: '₹${json['emi'] ?? '0'}',
        priceNote: 'Inc. of GST',
        description: json['certificate']?['title'] ?? 'Get Your Certificate',
        sampleImageUrl: json['certificate']?['sampleImage'] ?? '',
      ),
      resumeInfo: ResumeInfoModel(
        lessonTitle: resumeLessonTitle,
        timeLeft: resumeTimeLeft,
        lessonId: resumeLessonId,
      ),
    );
  }
}

enum CourseDetailTab { learning, notes, relatedCourses }
// class CourseBadgeModel {
//   final String label;
//   final bool isFree;
//   const CourseBadgeModel({required this.label, this.isFree = false});
// }

// class LessonModel {
//   final String id;
//   final String title;
//   final String duration;
//   final String? videoUrl; 
//   final bool isCompleted;
//   final bool isLocked;

//   const LessonModel({
//     required this.id,
//     required this.title,
//     required this.duration,
//     this.videoUrl,        
//     this.isCompleted = false,
//     this.isLocked = false,
//   });
// }
// class CourseSectionModel {
//   final String title;
//   final int totalVideos;
//   final List<LessonModel> lessons;
//   final bool isLocked;

//   const CourseSectionModel({
//     required this.title,
//     required this.totalVideos,
//     required this.lessons,
//     this.isLocked = false,
//   });
// }

// class AssessmentModel {
//   final String title;
//   final int totalItems;
//   final bool isLocked;

//   const AssessmentModel({
//     required this.title,
//     required this.totalItems,
//     this.isLocked = true,
//   });
// }

// class CertificateOfferModel {
//   final String price;     
//   final String priceNote; 
//   final String description;

//   const CertificateOfferModel({
//     required this.price,
//     required this.priceNote,
//     required this.description,
//   });
// }


// class ResumeInfoModel {
//   final String lessonTitle;
//   final String timeLeft; 
//   final String lessonId;

//   const ResumeInfoModel({
//     required this.lessonTitle,
//     required this.timeLeft,
//     required this.lessonId,
//   });
// }


// enum CourseDetailTab { learning, notes, relatedCourses }


// class CourseDetailModel {
//   final String courseId;
//   final String title;
//   final CourseBadgeModel badge;
//   final int totalVideos;
//   final int completedVideos;
//   final int totalAssessments;
//   final int completedAssessments;
//   final double progressPercent; // 0.0 – 1.0
//   final CertificateOfferModel certificateOffer;
//   final List<CourseSectionModel> sections;
//   final List<AssessmentModel> assessments;
//   final ResumeInfoModel resumeInfo;

//   const CourseDetailModel({
//     required this.courseId,
//     required this.title,
//     required this.badge,
//     required this.totalVideos,
//     required this.completedVideos,
//     required this.totalAssessments,
//     required this.completedAssessments,
//     required this.progressPercent,
//     required this.certificateOffer,
//     required this.sections,
//     required this.assessments,
//     required this.resumeInfo,
//   });
// }