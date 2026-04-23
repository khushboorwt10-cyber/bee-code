import 'package:beecode/screens/home/controller/course_detail_controller.dart';
import 'package:beecode/screens/home/model/details_model.dart';
import 'package:beecode/screens/home/model/home_model.dart';
import 'package:beecode/screens/home/service/section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsController extends GetxController {
  final SectionService _sectionService = SectionService();
  var courseTitle = ''.obs;
  final RxBool isApplying = false.obs;
  final RxBool isDownloading = false.obs;
  final RxInt activeStep = 0.obs;
  
  // API Course Data
  final Rx<CourseData?> courseData = Rx<CourseData?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  
  // Add this - Store section ID
  String? sectionId;
  String? sectionTitle;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args == null) {
      errorMessage.value = 'No course data provided';
      isLoading.value = false;
      return;
    }

    // -------------------------
    // CASE 1: CourseData object
    // -------------------------
    if (args is CourseData) {
      courseData.value = args;
      courseTitle.value = args.title;
      isLoading.value = false;
      return;
    }

    // -------------------------
    // CASE 2: String (courseId)
    // -------------------------
    if (args is String) {
      _loadCourseFromId(args);
      return;
    }

    // -------------------------
    // CASE 3: Map arguments
    // -------------------------
    if (args is Map<String, dynamic>) {
      sectionId = args['courseId'] ?? '';
      courseTitle.value = (args['title'] ?? '').toString().trim();

      debugPrint("🔥 TITLE FROM ARG: ${courseTitle.value}");

      if (sectionId != null && sectionId!.isNotEmpty) {
        _loadCourseFromId(sectionId!);
      } else {
        errorMessage.value = "Invalid course id";
        isLoading.value = false;
      }
    }
    // -------------------------
    // CASE 4: SectionData object
    // -------------------------
    if (args is SectionData) {
      sectionId = args.id;
      sectionTitle = args.title;

      final courseId = args.course.id;

      if (courseId.isNotEmpty) {
        _loadCourseFromId(courseId);
      }

      return;
    }

    // -------------------------
    // CASE 5: SectionWithCourses
    // -------------------------
    if (args is SectionWithCourses) {
      sectionId = args.section.id;
      sectionTitle = args.section.title;

      if (args.courses.isNotEmpty) {
        courseData.value = args.courses.first;
        courseTitle.value = args.courses.first.title;
        isLoading.value = false;
      } else {
        _loadCourseFromId(args.section.course.id);
      }

      return;
    }

    // -------------------------
    // fallback
    // -------------------------
    errorMessage.value = 'Unsupported argument type';
    isLoading.value = false;
  }
  Future<void> _loadCourseFromId(String courseId) async {
    try {
      isLoading.value = true;

      final course = await _sectionService.fetchCourseById(courseId);

      if (course != null) {
        courseData.value = course;

        // ❗ ONLY override if
        if (courseTitle.value.trim().isEmpty || courseTitle.value == '') {
          courseTitle.value = course.title;
        }


      } else {
        errorMessage.value = 'Course not found';
      }

    } catch (e) {
      errorMessage.value = 'Failed to load course: $e';
    } finally {
      isLoading.value = false;
    }
  }
  // Getters
  CourseData? get course => courseData.value;
  
  String get courseId => courseData.value?.id ?? '';
  String get courseTitleText => courseData.value?.title ?? '';
  String get displayTitle =>
      courseData.value?.title ?? courseTitle.value;
  String get instituteName => courseData.value?.instituteName ?? '';
  String get instituteLogo => courseData.value?.instituteLogo ?? '';
  String get thumbnailUrl => courseData.value?.thumbnail.url ?? '';
  String get bannerImageUrl => courseData.value?.bannerImage.url ?? '';
  String get duration => courseData.value?.duration ?? '0';
  String get emi => courseData.value?.emi ?? '0';
  int get price => courseData.value?.price ?? 0;
  int get discountPrice => courseData.value?.discountPrice ?? 0;
  bool get isFree => courseData.value?.isFree ?? false;
  double get rating => courseData.value?.rating ?? 0;
  int get totalRatings => courseData.value?.totalRatings ?? 0;
  int get totalStudents => courseData.value?.totalStudents ?? 0;
  String get description => courseData.value?.description ?? '';
  String get about => courseData.value?.about ?? '';
  String get level => courseData.value?.level ?? '';
  
  // Convert steps to curriculum modules
  List<CurriculumModule> get curriculumModules {
    final steps = courseData.value?.steps ?? [];
    
    if (steps.isEmpty) {
      // Return default if no steps
      return [
        CurriculumModule(
          title: 'Course Curriculum',
          courseNumber: 'Module 1',
          duration: '$duration Months',
          description: about.isNotEmpty ? about : 'Comprehensive course covering all aspects of $courseTitleText',
          topics: ['Introduction to $courseTitleText', 'Core Concepts', 'Advanced Topics', 'Practical Applications'],
          skills: ['Problem Solving', 'Analytical Thinking', 'Technical Skills'],
          isSpecialization: false,
        ),
      ];
    }
    
    return steps.asMap().entries.map((entry) {
      final index = entry.key;
      final step = entry.value;
      
      return CurriculumModule(
        title: step.title,
        courseNumber: 'Module ${index + 1}',
        duration: '${step.duration} weeks',
        description: step.topics.isNotEmpty ? step.topics.first.description : 'Learn ${step.title}',
        topics: step.topics.map((t) => t.title).toList(),
        skills: _extractSkillsFromTopics(step.topics),
        isSpecialization: step.isSpecialization,
      );
    }).toList();
  }
  
  List<String> _extractSkillsFromTopics(List<Topic> topics) {
    final skills = <String>[];
    for (var topic in topics) {
      if (topic.title.contains('Python')) skills.add('Python');
      if (topic.title.contains('ML')) skills.add('Machine Learning');
      if (topic.title.contains('AI')) skills.add('Artificial Intelligence');
      if (topic.title.contains('Data')) skills.add('Data Analysis');
      if (topic.title.contains('Deep')) skills.add('Deep Learning');
      if (topic.title.contains('NLP')) skills.add('NLP');
    }
    
    if (skills.isEmpty) {
      return ['Technical Skills', 'Problem Solving', 'Analytical Thinking'];
    }
    return skills;
  }
  
  // Course info for hero section
  CourseInfoModel get courseInfo {
    final title = courseData.value?.title ?? courseTitle.value;

    final durationValue = courseData.value?.duration ?? '0';
    final priceValue = courseData.value?.price ?? 0;
    final emiValue = courseData.value?.emi ?? '0';
    final ratingValue = courseData.value?.rating ?? 0;
    final totalRatingsValue = courseData.value?.totalRatings ?? 0;
    final totalStudentsValue = courseData.value?.totalStudents ?? 0;
    final levelValue = courseData.value?.level ?? '';
    final descriptionValue = courseData.value?.description ?? '';

    return CourseInfoModel(
      title: title,
      tagline: levelValue.isNotEmpty ? '$levelValue Program' : 'Professional Certification',
      duration: '$durationValue\nmonths',
      emiFrom: emiValue.isNotEmpty ? 'INR ${(priceValue / 12).toInt()}*' : 'Contact Us',
      admissionDeadline: _getAdmissionDeadline(),
      rating: ratingValue.toString(),
      ratingCount: totalRatingsValue,
      alumniCount: (totalStudentsValue / 1000).toInt(),
      badges: [
        BadgeModel(label: "🏅 $totalStudentsValue+ Students"),
        BadgeModel(label: "⭐ $ratingValue Rating"),
      ],
      bullets: [
        BulletModel(text: descriptionValue.isNotEmpty ? descriptionValue : 'Comprehensive $title program'),
        BulletModel(text: 'Learn from industry experts'),
        BulletModel(text: 'Get certified and boost your career'),
      ],
    );
  }
  String _getAdmissionDeadline() {
    final deadline = DateTime.now().add(const Duration(days: 30));
    return '${deadline.day}-${_getMonthAbbr(deadline.month)}-${deadline.year}';
  }
  
  String _getMonthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
  
  // Features lis
  List<FeatureModel> get features {
    final featuresList = <FeatureModel>[];
    
    if (courseData.value?.features.careerSupport == true) {
      featuresList.add(const FeatureModel(icon: Icons.support_agent_outlined, title: 'Career Support'));
    }
    
    if ((courseData.value?.features.projects ?? 0) > 0) {
      featuresList.add(FeatureModel(icon: Icons.description_outlined, title: '${courseData.value?.features.projects}+ Projects'));
    }
    
    if ((courseData.value?.features.alumni ?? 0) > 0) {
      featuresList.add(FeatureModel(icon: Icons.people_outline, title: '${(courseData.value?.features.alumni ?? 0) / 1000}k+ Alumni'));
    }
    
    featuresList.add(const FeatureModel(icon: Icons.play_circle_outline, title: 'Personalised learning paths'));
    featuresList.add(const FeatureModel(icon: Icons.workspace_premium_outlined, title: 'Professional Certification'));
    
    return featuresList;
  }
  
  // Certificate highlights
  List<CertificateHighlight> get certificateHighlights {
    final cert = courseData.value?.certificate;
    
    return [
      CertificateHighlight(
        icon: Icons.verified_outlined,
        title: cert?.title.isNotEmpty == true ? cert!.title : 'Official & Verifiable',
        description: cert?.issuedBy.isNotEmpty == true 
            ? 'Certificate issued by ${cert!.issuedBy}'
            : 'Receive a signed and verifiable e-certificate upon successful completion',
      ),
      const CertificateHighlight(
        icon: Icons.share_outlined,
        title: 'Share Your Achievement',
        description: 'Post your certificate on LinkedIn or add it to your resume',
      ),
      const CertificateHighlight(
        icon: Icons.workspace_premium_outlined,
        title: 'Stand Out to Recruiters',
        description: 'Use your certificate to enhance your professional credibility',
      ),
    ];
  }
  
  // FAQ categories
  List<FaqCategory> get faqCategories {
    return [
      FaqCategory(
        title: 'Program FAQs',
        questions: [
          FaqItem(
            question: 'What is the duration of this program?',
            answer: 'The program duration is $duration months with flexible learning options.',
          ),
          FaqItem(
            question: 'What is the eligibility criteria?',
            answer: 'This program is designed for professionals and students looking to enhance their skills in $courseTitleText.',
          ),
          FaqItem(
            question: 'Will I get a certificate?',
            answer: 'Yes, upon successful completion of the program, you will receive a certificate.',
          ),
        ],
      ),
      FaqCategory(
        title: 'Payment & Enrollment',
        questions: [
          FaqItem(
            question: 'What is the fee structure?',
            answer: isFree 
                ? 'This course is completely free!'
                : 'The course fee is ₹${price.toString()}. EMI options starting from ₹$emi/month are available.',
          ),
          FaqItem(
            question: 'How do I enroll?',
            answer: 'Click on "Start learning" button to begin your enrollment process.',
          ),
        ],
      ),
    ];
  }
  
  void beeCodePro() {
    Get.toNamed('/subscriptionScreen');
  }

  void startlearning() {
    if (Get.isRegistered<CourseDetailController>()) {
      Get.delete<CourseDetailController>(force: true);
    }
    
    // Use sectionId if available, otherwise use course ID
    if (sectionId != null && sectionId!.isNotEmpty) {
      debugPrint('🎯 Navigating with Section ID: $sectionId');
      Get.toNamed("/courseDetailScreen", arguments: sectionId);
    } else if (courseData.value?.id != null) {
      debugPrint('🎯 Navigating with Course ID: ${courseData.value?.id}');
      Get.toNamed("/courseDetailScreen", arguments: courseData.value?.id);
    } else {
      debugPrint('❌ No ID available for navigation');
      Get.snackbar('Error', 'Unable to start learning. Please try again.');
    }
  }
  
  void downloadBrochure() {
    if (isDownloading.value) return;
    isDownloading.value = true;
    Future.delayed(const Duration(seconds: 2), () => isDownloading.value = false);
  }

  void selectStep(int index) => activeStep.value = index;
  void goBack() => Get.back();
}
// import 'package:beecode/screens/home/controller/course_detail_controller.dart';
// import 'package:beecode/screens/home/model/details_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DetailsController extends GetxController {
//   final RxBool   isApplying    = false.obs;
//   final RxBool   isDownloading = false.obs;
//   final RxInt    activeStep    = 0.obs;
//   final RxString courseTitle   = ''.obs;

//   final Rx<Map<String, dynamic>> courseData = Rx<Map<String, dynamic>>({});

//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments;
//     if (args != null && args is Map<String, dynamic>) {
//       courseTitle.value = args['title'] ?? '';
//       courseData.value  = args;
//     }
//   }
//   CourseInfoModel         get courseInfo => MLDiplomaModel.courseInfo;
//   List<FeatureModel>      get features   => MLDiplomaModel.features;
//   List<LearningStepModel> get steps      => MLDiplomaModel.learningSteps;
// void beeCodePro() {
//   Get.toNamed('/subscriptionScreen');
// }

//  void startlearning() {
//   if (Get.isRegistered<CourseDetailController>()) {
//     Get.delete<CourseDetailController>(force: true);
//   }
//   Get.toNamed("/courseDetailScreen");
// }
//    void downloadBrochure() {
//     if (isDownloading.value) return;
//     isDownloading.value = true;
//     Future.delayed(const Duration(seconds: 2), () => isDownloading.value = false);
//     //  Get.toNamed("/courseDetailScreen");
//   }

//   void selectStep(int index) => activeStep.value = index;
//   void goBack() => Get.back();

//   final List<CertificateHighlight> certificateHighlights = [
//     CertificateHighlight(
//       icon: Icons.verified_outlined,
//       title: 'Official & Verifiable',
//       description: 'Receive a signed and verifiable e-certificate upon successfully completing the ML & AI program.',
//     ),
//     CertificateHighlight(
//       icon: Icons.share_outlined,
//       title: 'Share Your Achievement',
//       description: 'Post your certificate on LinkedIn or add it to your resume. Share it on Instagram or Twitter.',
//     ),
//     CertificateHighlight(
//       icon: Icons.workspace_premium_outlined,
//       title: 'Stand Out to Recruiters',
//       description: 'Use your certificate to enhance your professional credibility and stand out among your peers.',
//     ),
//   ];

//   final List<ArticleModel> articles = [
//     ArticleModel(
//       highlightedTitle: 'Benefits of Earning',
//       remainingTitle: 'a Free Certificate in Machine Learning & AI',
//       body: 'Level up your career with an ML & AI certificate! Stand out in the job market, show off your skills to employers, and prove your expertise in one of the fastest-growing fields in tech. A verified certificate signals to recruiters that you have hands-on experience with real-world AI systems and modern machine learning workflows.',
//     ),
//     ArticleModel(
//       highlightedTitle: 'Skills You will Gain',
//       remainingTitle: 'in Executive Diploma in ML & AI by AIGrad',
//       body: 'Learn how to work with data effectively and build production-ready ML models. This program covers Python, Deep Learning, NLP, MLOps, and Generative AI. You will gain practical skills in model training, fine-tuning LLMs, deploying APIs, and building end-to-end AI pipelines used in top tech companies.',
//     ),
//   ];


//   final List<CurriculumModule> curriculumModules = [
//     CurriculumModule(
//       title: 'Advanced Math & Programming',
//       courseNumber: 'Course 1',
//       duration: '5 weeks',
//       description: 'Master core mathematical and programming skills needed to build and deploy ML models effectively.',
//       topics: [
//         'Conditional Probability and Probability Distributions',
//         'Advanced Linear Algebra and Linear Transformations',
//         'Multivariate Calculus',
//         'GenAI for Coding and Problem-Solving',
//         'Object-Oriented Programming',
//         'Python Data Science Libraries',
//         'Database Design and SQL Querying',
//         'Introduction to NoSQL Databases',
//         'Version Control',
//       ],
//       skills: ['Python', 'MySQL', 'NumPy', 'Pandas', 'Matplotlib', 'Seaborn', 'Bokeh', 'MongoDB', 'PostgreSQL', 'Scipy'],
//     ),
//     CurriculumModule(
//       title: 'Data Analysis & Exploration',
//       courseNumber: 'Course 2',
//       duration: '5 weeks',
//       description: 'Learn to explore, clean, and analyze data using industry-standard tools and techniques.',
//       topics: [
//         'Exploratory Data Analysis (EDA)',
//         'Data Wrangling and Cleaning',
//         'Statistical Hypothesis Testing',
//         'Feature Engineering',
//         'Data Visualization best practices',
//       ],
//       skills: ['Pandas', 'Seaborn', 'Matplotlib', 'SciPy', 'Plotly'],
//     ),
//     CurriculumModule(
//       title: 'Cloud Computing & Big Data',
//       courseNumber: 'Course 3',
//       duration: '5 weeks',
//       description: 'Understand cloud infrastructure and big data processing pipelines for ML at scale.',
//       topics: [
//         'Cloud Architecture on AWS and GCP',
//         'Apache Spark and Hadoop',
//         'Data Lakes and Warehouses',
//         'Streaming Data with Kafka',
//         'ETL Pipelines',
//       ],
//       skills: ['AWS', 'GCP', 'Spark', 'Kafka', 'Airflow'],
//     ),
//     CurriculumModule(
//       title: 'Foundations of ML',
//       courseNumber: 'Course 4',
//       duration: '5 weeks',
//       description: 'Build strong foundations in supervised and unsupervised machine learning algorithms.',
//       topics: [
//         'Linear and Logistic Regression',
//         'Decision Trees and Random Forests',
//         'Support Vector Machines',
//         'K-Means and Hierarchical Clustering',
//         'Model Evaluation and Cross Validation',
//       ],
//       skills: ['Scikit-learn', 'XGBoost', 'LightGBM', 'Python'],
//     ),
//     CurriculumModule(
//       title: 'Deep Learning & NLP',
//       courseNumber: 'Course 5',
//       duration: '5 weeks',
//       description: 'Master neural networks, computer vision, and natural language processing techniques.',
//       topics: [
//         'Neural Networks and Backpropagation',
//         'Convolutional Neural Networks (CNNs)',
//         'Recurrent Neural Networks and LSTMs',
//         'Transformers and Attention Mechanism',
//         'Text Classification and Named Entity Recognition',
//       ],
//       skills: ['TensorFlow', 'PyTorch', 'Keras', 'HuggingFace', 'NLTK'],
//     ),
//     CurriculumModule(
//       title: 'MLOps',
//       courseNumber: 'Course 6',
//       duration: '16 weeks',
//       description: 'Learn to deploy, monitor and maintain ML models in production environments.',
//       topics: [
//         'Model Versioning with MLflow',
//         'Containerization with Docker and Kubernetes',
//         'CI/CD for ML Pipelines',
//         'Model Monitoring and Drift Detection',
//         'FastAPI for Model Serving',
//       ],
//       skills: ['Docker', 'Kubernetes', 'MLflow', 'FastAPI', 'GitHub Actions'],
//       isSpecialization: true,
//     ),
//     CurriculumModule(
//       title: 'GenAI',
//       courseNumber: 'Course 7',
//       duration: '16 weeks',
//       description: 'Explore Generative AI, LLMs, prompt engineering, and RAG-based application development.',
//       topics: [
//         'Large Language Models (LLMs)',
//         'Prompt Engineering',
//         'Fine-tuning with LoRA and PEFT',
//         'RAG Pipeline Development',
//         'Building AI Agents',
//       ],
//       skills: ['LangChain', 'OpenAI API', 'HuggingFace', 'ChromaDB', 'LlamaIndex'],
//       isSpecialization: true,
//     ),
//   ];
//   final List<FaqCategory> faqCategories = [
//   FaqCategory(
//     title: 'General FAQs',
//     questions: [
//       FaqItem(
//         question: 'What is the Executive Diploma in ML & AI?',
//         answer: 'The Executive Diploma in Machine Learning & AI is a comprehensive 12-month program designed for working professionals who want to master AI and ML concepts and apply them in real-world scenarios.',
//       ),
//       FaqItem(
//         question: 'Who is this program designed for?',
//         answer: 'This program is ideal for software engineers, data analysts, product managers, and any professional looking to transition into or advance in the AI/ML field.',
//       ),
//       FaqItem(
//         question: 'What are the prerequisites?',
//         answer: 'Basic knowledge of programming (preferably Python) and high school level mathematics is recommended. No prior ML experience is required.',
//       ),
//     ],
//   ),
//   FaqCategory(
//     title: 'Enrollment & Access',
//     questions: [
//       FaqItem(
//         question: 'How do I enroll in the program?',
//         answer: 'Click "Start Application" and complete the registration form. Our admissions team will reach out within 24 hours to guide you through the process.',
//       ),
//       FaqItem(
//         question: 'Is there an application deadline?',
//         answer: 'The current batch deadline is 30-Dec-2025. We recommend applying early as seats are limited.',
//       ),
//       FaqItem(
//         question: 'Can I access course material after completion?',
//         answer: 'Yes, you get lifetime access to all course materials, recorded sessions, and future updates to the curriculum.',
//       ),
//     ],
//   ),
//   FaqCategory(
//     title: 'Course Details & Career Outcomes',
//     questions: [
//       FaqItem(
//         question: 'What kind of projects will I work on?',
//         answer: 'You will work on 30+ industry-grade projects across domains like finance, healthcare, e-commerce, and more. The capstone project is entirely your choice.',
//       ),
//       FaqItem(
//         question: 'Will I get placement support?',
//         answer: 'Yes, we provide dedicated career support including resume reviews, mock interviews, LinkedIn optimization, and access to our hiring partner network.',
//       ),
//       FaqItem(
//         question: 'What companies have hired our alumni?',
//         answer: 'Our alumni work at Amazon, Microsoft, HSBC, ICICI, Kotak, Jio Digital, Lenskart, Swiggy, and 500+ other top companies.',
//       ),
//     ],
//   ),
//   FaqCategory(
//     title: 'Concept-Based FAQs',
//     questions: [
//       FaqItem(
//         question: 'What is the difference between AI and ML?',
//         answer: 'AI (Artificial Intelligence) is the broader concept of machines simulating human intelligence. ML (Machine Learning) is a subset of AI where systems learn from data to improve their performance without being explicitly programmed.',
//       ),
//       FaqItem(
//         question: 'Do I need to know deep learning before joining?',
//         answer: 'No. The program starts from the fundamentals and progressively builds up to advanced deep learning, LLMs, and generative AI topics.',
//       ),
//       FaqItem(
//         question: 'What is MLOps and why does it matter?',
//         answer: 'MLOps (Machine Learning Operations) is the practice of deploying, monitoring, and maintaining ML models in production. It bridges the gap between data science and engineering, which is critical for real-world AI applications.',
//       ),
//     ],
//   ),
// ];

// }
// class CourseFeeController extends GetxController {
//   final RxInt selectedTab = 0.obs;
//   final RxBool isApplying = false.obs;
 
//   final List<String> tabs = [
//     'Course Fee',
//     'Base Program + IT Professional Pack',
//   ];
 
//   final List<CourseFeeModel> plans = [
//     CourseFeeModel(
//       label: 'Course Fee',
//       duration: '3 MONTHS',
//       monthlyPrice: 'INR 6.667/month',
//       totalPrice: 'INR 20,000*',
//       inclusions: const [
//         'Pay INR 15,000 and block your seat Now!',
//       ],
//     ),
//     CourseFeeModel(
//       label: 'Base Program + IT Professional Pack',
//       duration: '6 MONTHS',
//       monthlyPrice: 'INR 5,000/month',
//       totalPrice: 'INR 30,000*',
//       inclusions: const [
//         'Pay INR 15,000 and block your seat Now!',
//         'Includes IT Professional Pack',
//       ],
//     ),
//   ];
 
//   CourseFeeModel get currentPlan => plans[selectedTab.value];
 
//   void selectTab(int index) => selectedTab.value = index;
 
// }