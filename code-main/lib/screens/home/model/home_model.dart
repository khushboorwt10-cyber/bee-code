// lib/screens/home/model/home_models.dart
import 'package:beecode/screens/home/model/coures_model.dart';
import 'package:flutter/material.dart';

class CarouselItem {
  final String? imageUrl;
  CarouselItem({this.imageUrl});
}

class CourseCategoryCard {
  final String title;
  final String courses;
  final IconData icon;
  final List<Color> gradient;
  final String route;
  
  CourseCategoryCard({
    required this.title,
    required this.courses,
    required this.icon,
    required this.gradient,
    required this.route,
  });
}class SectionData {
  final String id;
  final String title;
  final int order;

  final CourseReference course;

  final DateTime createdAt;
  final DateTime updatedAt;

  SectionData({
    required this.id,
    required this.title,
    required this.order,
    required this.course,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SectionData.fromJson(Map<String, dynamic> json) {
    return SectionData(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      order: json['order'] ?? 0,

      // ✅ SAFE: handles both Map and String
      course: json['course'] is Map<String, dynamic>
          ? CourseReference.fromJson(json['course'])
          : CourseReference(
        id: json['course']?.toString() ?? '',
        title: '',
      ),

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),

      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  // ✅ helper getter (optional but useful)
  String get courseId => course.id;
}
class CourseReference {
  final String id;
  final String title;

  CourseReference({
    required this.id,
    required this.title,
  });

  factory CourseReference.fromJson(Map<String, dynamic> json) {
    return CourseReference(
      id: json['_id'],
      title: json['title'],
    );
  }
}

// Complete Course Data Model
class CourseData {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String instituteName;
  final String instituteLogo;
  final String? video;
  final Thumbnail thumbnail;
  final BannerImage bannerImage;
  final Certificate certificate;
  final Features features;
  final CourseCategory category; // Changed from Category to CourseCategory
  final String level;
  final String duration;
  final String emi;
  final int price;
  final int discountPrice;
  final bool isFree;
  final double rating;
  final int totalRatings;
  final int totalStudents;
  final String about;
  final List<dynamic> highlights;
  final List<Step> steps;
  final List<dynamic> faqs;
  final bool isPublished;
  final bool isApproved;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.instituteName,
    required this.instituteLogo,
    this.video,
    required this.thumbnail,
    required this.bannerImage,
    required this.certificate,
    required this.features,
    required this.category, // Changed here
    required this.level,
    required this.duration,
    required this.emi,
    required this.price,
    required this.discountPrice,
    required this.isFree,
    required this.rating,
    required this.totalRatings,
    required this.totalStudents,
    required this.about,
    required this.highlights,
    required this.steps,
    required this.faqs,
    required this.isPublished,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) {
  return CourseData(
    id: json['_id'] ?? '',
    title: json['title'] ?? '',
    subtitle: json['subtitle'] ?? '',
    description: json['description'] ?? '',
    instituteName: json['instituteName'] ?? '',
    instituteLogo: json['instituteLogo'] ?? '',
    video: json['video'],
    thumbnail: Thumbnail.fromJson(json['thumbnail'] ?? {'url': ''}),
    bannerImage: BannerImage.fromJson(json['bannerImage'] ?? {'url': ''}),
    certificate: Certificate.fromJson(json['certificate'] ?? {
      'title': '', 
      'issuedBy': '', 
      'sampleImage': ''
    }),
    features: Features.fromJson(json['features'] ?? {
      'careerSupport': false, 
      'projects': 0, 
      'alumni': 0
    }),
    category: CourseCategory.fromJson(json['category'] ?? {'_id': '', 'name': ''}),
    level: json['level'] ?? '',
    duration: json['duration']?.toString() ?? '0',
    emi: json['emi']?.toString() ?? '0',
    price: json['price'] ?? 0,
    discountPrice: json['discountPrice'] ?? 0,
    isFree: json['isFree'] ?? false,
    rating: (json['rating'] ?? 0).toDouble(),
    totalRatings: json['totalRatings'] ?? 0,
    totalStudents: json['totalStudents'] ?? 0,
    about: json['about'] ?? '',
    highlights: json['highlights'] ?? [],
    steps: (json['steps'] as List?)?.map((e) => Step.fromJson(e)).toList() ?? [],
    faqs: json['faqs'] ?? [],
    isPublished: json['isPublished'] ?? false,
    isApproved: json['isApproved'] ?? false,
    createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt']) 
        : DateTime.now(),
    updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt']) 
        : DateTime.now(),
  );
}

  factory CourseData.empty() {
    return CourseData(
      id: '',
      title: '',
      subtitle: '',
      description: '',
      instituteName: '',
      instituteLogo: '',
      thumbnail: Thumbnail(url: ''),
      bannerImage: BannerImage(url: ''),
      certificate: Certificate(title: '', issuedBy: '', sampleImage: ''),
      features: Features(careerSupport: false, projects: 0, alumni: 0),
      category: CourseCategory(id: '', name: ''), // Changed here
      level: '',
      duration: '0',
      emi: '0',
      price: 0,
      discountPrice: 0,
      isFree: false,
      rating: 0.0,
      totalRatings: 0,
      totalStudents: 0,
      about: '',
      highlights: [],
      steps: [],
      faqs: [],
      isPublished: false,
      isApproved: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

class Thumbnail {
  final String url;
  Thumbnail({required this.url});
  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(url: json['url'] ?? '');
}

class BannerImage {
  final String url;
  BannerImage({required this.url});
  factory BannerImage.fromJson(Map<String, dynamic> json) => BannerImage(url: json['url'] ?? '');
}

class Certificate {
  final String title;
  final String issuedBy;
  final String sampleImage;
  Certificate({required this.title, required this.issuedBy, required this.sampleImage});
  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
    title: json['title'] ?? '',
    issuedBy: json['issuedBy'] ?? '',
    sampleImage: json['sampleImage'] ?? '',
  );
}

class Features {
  final bool careerSupport;
  final int projects;
  final int alumni;
  Features({required this.careerSupport, required this.projects, required this.alumni});
  factory Features.fromJson(Map<String, dynamic> json) => Features(
    careerSupport: json['careerSupport'] ?? false,
    projects: json['projects'] ?? 0,
    alumni: json['alumni'] ?? 0,
  );
}

class Category {
  final String id;
  final String name;
  Category({required this.id, required this.name});
  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
  );
}

class Step {
  final String title;
  final String duration;
  final bool isSpecialization;
  final List<Topic> topics;
  Step({required this.title, required this.duration, required this.isSpecialization, required this.topics});
  factory Step.fromJson(Map<String, dynamic> json) => Step(
    title: json['title'] ?? '',
    duration: json['duration']?.toString() ?? '0',
    isSpecialization: json['isSpecialization'] ?? false,
    topics: (json['topics'] as List?)?.map((e) => Topic.fromJson(e)).toList() ?? [],
  );
}

class Topic {
  final String title;
  final String description;
  final String video;
  final bool isPreview;
  Topic({required this.title, required this.description, required this.video, required this.isPreview});
  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    video: json['video'] ?? '',
    isPreview: json['isPreview'] ?? false,
  );
}