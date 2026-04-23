import 'package:flutter/material.dart';

class BadgeModel {
  final String label;
  const BadgeModel({required this.label});
}

class BulletModel {
  final String text;
  const BulletModel({required this.text});
}


class CourseInfoModel {
  final String title;
  final String tagline;
  final String duration;
  final String emiFrom;
  final String admissionDeadline;
  final String rating;
  final int ratingCount;
  final int alumniCount;
  final List<BadgeModel> badges;
  final List<BulletModel> bullets;

  const CourseInfoModel({
    required this.title,
    required this.tagline,
    required this.duration,
    required this.emiFrom,
    required this.admissionDeadline,
    required this.rating,
    required this.ratingCount,
    required this.alumniCount,
    required this.badges,
    required this.bullets,
  });
}
class FeatureModel {
  final IconData icon;
  final String title;
  const FeatureModel({required this.icon, required this.title});
}

class LearningStepModel {
  final String number;
  final String title;
  final String description;
  const LearningStepModel({
    required this.number,
    required this.title,
    required this.description,
  });
}

class CurriculumModule {
  final String title;
  final String courseNumber;
  final String duration;
  final String description;
  final List<String> topics;
  final List<String> skills;
  final bool isSpecialization;

  const CurriculumModule({
    required this.title,
    required this.courseNumber,
    required this.duration,
    required this.description,
    required this.topics,
    required this.skills,
    this.isSpecialization = false,
  });
}

class CertificateHighlight {
  final IconData icon;
  final String title;
  final String description;

  const CertificateHighlight({
    required this.icon,
    required this.title,
    required this.description,
  });
}


class ArticleModel {
  final String highlightedTitle;
  final String remainingTitle;
  final String body;

  const ArticleModel({
    required this.highlightedTitle,
    required this.remainingTitle,
    required this.body,
  });
}


class MLDiplomaModel {
  MLDiplomaModel._();

  static const CourseInfoModel courseInfo = CourseInfoModel(
    title: 'Executive Diploma in\nMachine Learning and AI\nfrom IIITB',
    tagline: "India's Top Machine Learning Program",
    duration: '12\nmonths',
    emiFrom: 'INR 8,125*',
    admissionDeadline: '30-Dec-2025',
    rating: '4.5/5',
    ratingCount: 7812,
    alumniCount: 10,
    badges: [
      BadgeModel(label: "🏅 Top 100 (NIRF '24)"),
      BadgeModel(label: '🏅 Graded A+ (NAAC)'),
    ],
    bullets: [
      BulletModel(
        text: "Enroll into India's pioneering Online Machine Learning Program; learn from the latest 2025 curriculum.",
      ),
      // BulletModel(
      //   text: 'Join an alumni network of ML Experts at Amazon, HSBC, ICICI, Kotak, Microsoft, Jio Digital, Lenskart, Swiggy, and more.',
      // ),
    ],
  );

  static const List<FeatureModel> features = [
    FeatureModel(icon: Icons.play_circle_outline,        title: 'Personalised learning paths'),
    FeatureModel(icon: Icons.description_outlined,       title: '30+ projects across domains'),
    FeatureModel(icon: Icons.menu_book_outlined,         title: 'Capstone Project of your choice'),
    FeatureModel(icon: Icons.workspace_premium_outlined, title: "A standout ML Engineer's portfolio"),
    FeatureModel(icon: Icons.support_agent_outlined,     title: 'Personalised Career Support'),
    FeatureModel(icon: Icons.verified_outlined,          title: 'Certification by Microsoft'),
  ];

  static const List<LearningStepModel> learningSteps = [
    LearningStepModel(
      number: '01',
      title: '2 Weeks of Fundamentals Training',
      description: 'Learn the fundamentals of Data Science, AI, and Machine Learning.',
    ),
    LearningStepModel(
      number: '02',
      title: 'Statistics & Python Essentials',
      description: 'Statistical foundations and Python programming for Data Science in 4 modules.',
    ),
    LearningStepModel(
      number: '03',
      title: 'Core ML Algorithms',
      description: 'Deep dive into supervised, unsupervised, and reinforcement learning.',
    ),
    LearningStepModel(
      number: '04',
      title: 'Deep Learning & Neural Networks',
      description: 'Build and train neural networks using TensorFlow and PyTorch.',
    ),
    LearningStepModel(
      number: '05',
      title: 'Specialization Track',
      description: 'Choose your domain: NLP, Computer Vision, or Time-Series Analysis.',
    ),
    LearningStepModel(
      number: '06',
      title: 'Capstone Project & Placement',
      description: 'Build an industry-grade project and receive career placement support.',
    ),
  ];
}
class FaqCategory {
  final String title;
  final List<FaqItem> questions;
  const FaqCategory({required this.title, required this.questions});
}

class FaqItem {
  final String question;
  final String answer;
  const FaqItem({required this.question, required this.answer});
}
class SupportContactModel {
  final String flag;
  final String label;
  final String displayPhone;
  final String dialNumber;

  const SupportContactModel({
    required this.flag,
    required this.label,
    required this.displayPhone,
    required this.dialNumber,
  });
}


class AboutStatModel {
  final IconData icon;
  final String value;
  final String label;

  const AboutStatModel({
    required this.icon,
    required this.value,
    required this.label,
  });
}
class CourseFeeModel {
  final String label;
  final String duration;
  final String monthlyPrice;
  final String totalPrice;
  final List<String> inclusions;

  CourseFeeModel({
    required this.label,
    required this.duration,
    required this.monthlyPrice,
    required this.totalPrice,
    required this.inclusions,
  });
}
