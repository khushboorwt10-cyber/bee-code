// lib/screens/home/controller/home_controller.dart
import 'dart:async';
import 'package:beecode/screens/home/model/home_model.dart';
import 'package:beecode/screens/home/service/section.dart';
import 'package:beecode/screens/home/service/section_service.dart';
import 'package:beecode/screens/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final SectionService _sectionService = SectionService();

  // API Data
  final RxList<SectionData> sections = <SectionData>[].obs;
  final RxList<CourseData> courses = <CourseData>[].obs;
  final RxList<SectionWithCourses> sectionsWithCourses =
      <SectionWithCourses>[].obs;

  // Dynamic data from API
  final RxList<CourseData> apiTrendingCourses = <CourseData>[].obs;
  final RxList<CourseData> apiFreeCourses = <CourseData>[].obs;

  // UI States
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedSectionIndex = 0.obs;

  // Carousel
  RxInt currentPage = 0.obs;
  Timer? _carouselTimer;
  late final PageController pageController;

  final List<CarouselItem> carouselItems = [
    CarouselItem(imageUrl: AppImages.banner),
    CarouselItem(imageUrl: AppImages.banner),
  ];

  // Masterclasses
  final List<Map<String, dynamic>> masterclasses = const [
    {
      "bannerImage":
      "https://images.unsplash.com/photo-1627556704302-624286467c65?w=600",
      "date": "Monday, Mar 9",
      "time": "08:00 PM",
      "title":
      "Scholarships & Grants You're Missing: How to Unlock ₹50L+ Scholarships",
      "speakerName": "Amit Gorain",
      "speakerRole": "Global Education Strategist",
    },
    {
      "bannerImage":
      "https://images.unsplash.com/photo-1543269865-cbf427effbad?w=600",
      "date": "Wednesday, Mar 11",
      "time": "07:00 PM",
      "title": "Cracking Data Science Interviews at Top MNCs in 2025",
      "speakerName": "Priya Sharma",
      "speakerRole": "Senior Data Scientist, Google",
    },
    {
      "bannerImage":
      "https://images.unsplash.com/photo-1531482615713-2afd69097998?w=600",
      "date": "Friday, Mar 13",
      "time": "06:30 PM",
      "title":
      "How to Land a Product Manager Role with No Prior Experience",
      "speakerName": "Rahul Mehta",
      "speakerRole": "VP Product, Flipkart",
    },
  ];

  final List<Map<String, dynamic>> testimonials = const [
    {
      "image":
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600",
      "quote":
      "As a commerce student, the course gave me the data science skills I needed.",
      "name": "Anish Sharma",
      "role": "People's Analytics Consultant @Momentum Group",
    },
    {
      "image":
      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=600",
      "quote":
      "The certification helped me transition into a product management role.",
      "name": "Tuhi Bose",
      "role": "Solution Consultant @SAP",
    },
    {
      "image":
      "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=600",
      "quote":
      "I got a 40% salary hike within 6 months of completing the program.",
      "name": "Rajan Mehta",
      "role": "Senior Data Engineer @Infosys",
    },
  ];

  // Free courses
  final RxMap<String, List<CourseData>> freeCoursesByCategory =
      <String, List<CourseData>>{}.obs;
  final RxInt selectedFreeTab = 0.obs;
  final RxInt selectedCourseIndex = (-1).obs;
  final ScrollController logoScrollController = ScrollController();
  Timer? _logoTimer;

  // Trending courses
  List<Map<String, dynamic>> get trendingCourses {
    return apiTrendingCourses.map((course) {
      return {
        "institute": course.instituteName,
        "title": course.title,
        "tag": course.level,
        "type": course.isFree ? "Free Course" : "Paid Course",
        "duration": "${course.duration} Months",
        "logo": course.instituteLogo.isNotEmpty
            ? course.instituteLogo
            : AppImages.aiml,
      };
    }).toList();
  }

  // Free courses getter
  Map<String, List<Map<String, dynamic>>> get freeCourses {
    final Map<String, List<Map<String, dynamic>>> result = {};

    for (var entry in freeCoursesByCategory.entries) {
      result[entry.key] = entry.value.map((course) {
        return {
          "title": course.title,
          "learners": "${course.totalStudents}+",
          "hours": course.duration,
          "image": course.thumbnail.url,
        };
      }).toList();
    }

    return result;
  }

  List<String> get freeCourseTabs => freeCoursesByCategory.keys.toList();

  @override
  void onInit() {
    super.onInit();
    pageController =
        PageController(viewportFraction: 1.0, initialPage: 1000);

    startAutoSlide();
    startLogoAutoScroll();
    fetchHomeData();
  }

  // =========================
  // FETCH HOME DATA (FIXED)
  // =========================
  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await Future.wait([
        _sectionService.fetchSections(),
        _sectionService.fetchAllCourses(),
        _sectionService.fetchSectionsWithCoursesDirect(),
        _sectionService.fetchTrendingCourses(limit: 10),
        _sectionService.fetchFreeCourses(limit: 20),
      ]);

      sections.value = (results[0] as List<SectionData>);
      courses.value = (results[1] as List<CourseData>);
      sectionsWithCourses.value =
      (results[2] as List<SectionWithCourses>);
      apiTrendingCourses.value = (results[3] as List<CourseData>);
      apiFreeCourses.value = (results[4] as List<CourseData>);

      debugPrint("✅ Sections: ${sections.length}");
      debugPrint("✅ SectionsWithCourses: ${sectionsWithCourses.length}");

      for (var item in sectionsWithCourses) {
        debugPrint("📌 ${item.section.title} -> ${item.courses.length}");
      }

      organizeFreeCourses();
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("❌ ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // ORGANIZE FREE COURSES
  // =========================
  void organizeFreeCourses() {
    final Map<String, List<CourseData>> organized = {};

    for (var course in apiFreeCourses) {
      final key =
      course.level.isNotEmpty ? course.level : 'Popular Programs';

      organized.putIfAbsent(key, () => []);
      organized[key]!.add(course);
    }

    if (organized.isEmpty) {
      organized['All Free Courses'] = apiFreeCourses;
    }

    freeCoursesByCategory.value = organized;
  }

  List<CourseData> getCoursesForSection(String sectionId) {
    final section = sectionsWithCourses.firstWhereOrNull(
          (s) => s.section.id == sectionId,
    );

    return section?.courses ?? [];
  }

  Future<void> refreshData() async {
    await fetchHomeData();
  }

  void startAutoSlide() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (pageController.hasClients) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void startLogoAutoScroll() {
    _logoTimer?.cancel();
    _logoTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (logoScrollController.hasClients) {
        final max = logoScrollController.position.maxScrollExtent;

        if (logoScrollController.offset >= max) {
          logoScrollController.jumpTo(0);
        } else {
          logoScrollController.jumpTo(
            logoScrollController.offset + 1,
          );
        }
      }
    });
  }

  void updatePage(int index) {
    currentPage.value = index % carouselItems.length;
  }

  @override
  void onClose() {
    _carouselTimer?.cancel();
    _logoTimer?.cancel();
    pageController.dispose();
    logoScrollController.dispose();
    super.onClose();
  }
}
// import 'dart:async';
// import 'package:beecode/screens/home/model/coures_model.dart';
// import 'package:beecode/screens/utils/images.dart';
// import 'package:beecode/screens/utils/route.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HomeController extends GetxController {
//   RxInt currentPage = 0.obs;
//   Timer? _carouselTimer;
//   late final PageController pageController;

//   final List<CarouselItem> carouselItems = [
//   CarouselItem(
//     imageUrl:AppImages.banner
//   ),
//   CarouselItem(
//      imageUrl:AppImages.banner
//   ),
// ];
//   void updatePage(int index) {
//     currentPage.value = index % carouselItems.length;
//   }
//   void startAutoSlide() {
//     _carouselTimer?.cancel();
//     _carouselTimer = Timer.periodic(const Duration(seconds: 3), (_) {
     
//       if (pageController.hasClients && pageController.positions.length == 1) {
//         pageController.nextPage(
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeIn,
//         );
//       }
//     });
//   }
//   final RxBool isLoading = true.obs;
//   final selectedGoal = 'Get a promotion'.obs;
//   final List<String> goals = [
//     "Get a promotion",
//     "Industry Certification",
//     "Data Science",
//     "Free Course",
//     "Study Abroad",
//     "Prepare for your first job",
//   ];

//   final RxInt selectedFreeTab = 0.obs;
//   final ScrollController logoScrollController = ScrollController();
//   Timer? _logoTimer;

//   final List<String> logos = [
//     "https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Oracle_logo.svg/2560px-Oracle_logo.svg.png",
//     "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/PayPal.svg/2560px-PayPal.svg.png",
//     "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/2560px-Google_2015_logo.svg.png",
//     "https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Microsoft_logo.svg/2560px-Microsoft_logo.svg.png",
//     "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Amazon_logo.svg/2560px-Amazon_logo.svg.png",
//   ];
// final RxInt selectedCourseIndex = (-1).obs;
// void selectCourseCard(int index) {
//   selectedCourseIndex.value = index;
//   Get.toNamed(courseCategoryCards[index].route);
// }
// final List<CourseCategoryCard> courseCategoryCards = [
//   CourseCategoryCard(
//     title: 'Doctorate Courses',
//     courses: '11 Courses',
//     icon: Icons.school,
//     gradient: [const Color(0xFF7F5AF0), const Color(0xFFA78BFA)],
//     route: Routes.doctorateScreen,
//   ),
//   CourseCategoryCard(
//     title: 'Artificial Intelligence',
//     courses: '12 Courses',
//     icon: Icons.smart_toy,
//     gradient: [const Color(0xFF2563EB), const Color(0xFF60A5FA)],
//     route: Routes.aiCoursesScreen,
//   ),
//   CourseCategoryCard(
//     title: 'Data Science',
//     courses: '9 Courses',
//     icon: Icons.hub,
//     gradient: [const Color(0xFF10B981), const Color(0xFF6EE7B7)],
//     route: Routes.dataScienceScreen,
//   ),
//   CourseCategoryCard(
//     title: 'MBA Courses',
//     courses: '11 Courses',
//     icon: Icons.business_center,
//     gradient: [const Color(0xFFF59E0B), const Color(0xFFFCD34D)],
//     route: Routes.mbaCoursesScreen,
//   ),
// ];

//   final List<Map<String, dynamic>> trendingCourses = [
//     {
//       "institute": "AI/ML Developer ",
//       "title": "Certificate in Machine Learning & Artifical Intelligence ",
//       "tag": "360° Career Support",
//       "type": "Certificate Program",
//       "duration": "6 Months",
     
//       "logo":
//           AppImages.aiml,
//     },
//     {
//       "institute": "IIT Roorkee",
//       "title": "Executive Program in Data Science & Machine Learning",
//       "tag": "Placement Assistance",
//       "type": "PG Certificate",
//       "duration": "6 Months",
     
//       "logo":
//           AppImages.aiml,
//     },
//     {
//       "institute": "LJMU",
//       "title": "MBA (Global) with Specialization in Finance",
//       "tag": "Industry Mentorship",
//       "type": "Master's Degree",
//       "duration": "18 Months",
     
//       "logo":
//             AppImages.aiml,
//     },
//     {
//       "institute": "IIT Madras",
//       "title": "Advanced Certification in Full Stack Development",
//       "tag": "Job Guarantee",
//       "type": "Advanced Certification",
//       "duration": "9 Months",
      
//       "logo":
//              AppImages.aiml,
//     },
//     {
//       "institute": "Duke CE",
//       "title": "Post Graduate Certificate in Product Management",
//       "tag": "Live Sessions",
//       "type": "PG Certificate",
//       "duration": "8 Months",
      
//       "logo":
//             AppImages.aiml,
//     },
//   ];

//   final Map<String, List<Map<String, dynamic>>> freeCourses = const {
//     "Popular Programs": [
//       {
//         "title": "Introduction to Data Analysis using Excel",
//         "learners": "99.2k+",
//         "hours": "9",
//         "image":
//             "https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=600",
//       },
//       {
//         "title": "Learn Python Basics for Data Science",
//         "learners": "120k+",
//         "hours": "12",
//         "image":
//             "https://images.unsplash.com/photo-1526379095098-d400fd0bf935?w=600",
//       },
//       {
//         "title": "Fundamentals of Cloud Computing",
//         "learners": "75k+",
//         "hours": "8",
//         "image":
//             "https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=600",
//       },
//     ],
//     "ChatGPT & AI": [
//       {
//         "title": "ChatGPT for Beginners: The Complete Guide",
//         "learners": "210k+",
//         "hours": "6",
//         "image":
//             "https://images.unsplash.com/photo-1677442135703-1787eea5ce01?w=600",
//       },
//       {
//         "title": "Generative AI for Everyone",
//         "learners": "180k+",
//         "hours": "10",
//         "image":
//             "https://images.unsplash.com/photo-1620712943543-bcc4688e7485?w=600",
//       },
//       {
//         "title": "Prompt Engineering Fundamentals",
//         "learners": "95k+",
//         "hours": "5",
//         "image":
//             "https://images.unsplash.com/photo-1655720828018-edd2daec9349?w=600",
//       },
//     ],
//     "Data Science": [
//       {
//         "title": "Statistics for Data Science and Business Analysis",
//         "learners": "88k+",
//         "hours": "14",
//         "image":
//             "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600",
//       },
//       {
//         "title": "Machine Learning with Python",
//         "learners": "142k+",
//         "hours": "16",
//         "image":
//             "https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?w=600",
//       },
//       {
//         "title": "Data Visualization with Tableau",
//         "learners": "63k+",
//         "hours": "7",
//         "image":
//             "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600",
//       },
//     ],
//   };
//   final List<Map<String, dynamic>> masterclasses = const [
//     {
//       "bannerImage":
//           "https://images.unsplash.com/photo-1627556704302-624286467c65?w=600",
//       "date": "Monday, Mar 9",
//       "time": "08:00 PM",
//       "title":
//           "Scholarships & Grants You're Missing: How to Unlock ₹50L+ Scholarships",
//       "speakerName": "Amit Gorain",
//       "speakerRole": "Global Education Strategist",
//     },
//     {
//       "bannerImage":
//           "https://images.unsplash.com/photo-1543269865-cbf427effbad?w=600",
//       "date": "Wednesday, Mar 11",
//       "time": "07:00 PM",
//       "title": "Cracking Data Science Interviews at Top MNCs in 2025",
//       "speakerName": "Priya Sharma",
//       "speakerRole": "Senior Data Scientist, Google",
//     },
//     {
//       "bannerImage":
//           "https://images.unsplash.com/photo-1531482615713-2afd69097998?w=600",
//       "date": "Friday, Mar 13",
//       "time": "06:30 PM",
//       "title": "How to Land a Product Manager Role with No Prior Experience",
//       "speakerName": "Rahul Mehta",
//       "speakerRole": "VP Product, Flipkart",
//     },
//   ];

//   final List<Map<String, dynamic>> testimonials = const [
//     {
//       "image":
//           "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600",
//       "quote":
//           "As a commerce student, upGrad's course gave me the data science skills I needed.",
//       "name": "Anish Sharma",
//       "role": "People's Analytics Consultant @Momentum Group",
//     },
//     {
//       "image":
//           "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=600",
//       "quote":
//           "The certification helped me transition into a product management role at a top MNC.",
//       "name": "Tuhi Bose",
//       "role": "Solution Consultant @SAP",
//     },
//     {
//       "image":
//           "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=600",
//       "quote":
//           "I got a 40% salary hike within 6 months of completing the AI & ML program.",
//       "name": "Rajan Mehta",
//       "role": "Senior Data Engineer @Infosys",
//     },
//     {
//       "image":
//           "https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=600",
//       "quote":
//           "The live sessions and mentorship made all the difference in my career switch.",
//       "name": "Sneha Kulkarni",
//       "role": "Business Analyst @Deloitte",
//     },
//   ];


//   @override
//   void onInit() {
//     super.onInit();

//     final arg = Get.arguments;
//     if (arg != null && arg is String) selectedGoal.value = arg;

//     pageController = PageController(
//       // viewportFraction: 0.90,
//  viewportFraction: 1.0,
//       initialPage: 1000,
//     );

//     startAutoSlide();
//     startLogoAutoScroll();


//     fetchData();
//   }


//   Future<void> fetchData() async {
//     try {
//       isLoading.value = true;
      
//       await Future.delayed(const Duration(seconds: 2));
//     } catch (e) {
      
//       debugPrint("HomeController fetchData error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void startLogoAutoScroll() {
//     _logoTimer?.cancel();
//     _logoTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
//       if (logoScrollController.hasClients) {
//         final maxExtent = logoScrollController.position.maxScrollExtent;
//         if (logoScrollController.offset >= maxExtent) {
//           logoScrollController.jumpTo(0);
//         } else {
//           logoScrollController.jumpTo(logoScrollController.offset + 1);
//         }
//       }
//     });
//   }

//   @override
//   void onClose() {
//     _carouselTimer?.cancel();
//     _logoTimer?.cancel();
//     pageController.dispose();
//     logoScrollController.dispose();
//     super.onClose();
//   }
// }
