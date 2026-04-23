import 'dart:convert';
import 'package:beecode/screens/home/controller/video_controller.dart';
import 'package:beecode/screens/home/model/home_model.dart';
import 'package:beecode/screens/home/model/learning_model.dart';
import 'package:beecode/screens/home/screen/video_screen.dart';
import 'package:beecode/screens/home/service/section.dart';
import 'package:beecode/widget/recent_courses_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../service/section_service.dart';

class CourseDetailController extends GetxController {
  final selectedTab = CourseDetailTab.learning.obs;
  final isLoadingCertificate = false.obs;
  final isResumingLesson = false.obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  late String sectionId;  // Change this to sectionId
  late String courseId;
  late CourseDetailModel course;

  final Rx<LessonModel?> lastWatchedLesson = Rx<LessonModel?>(null);
  final RxString lastWatchedTimeLeft = ''.obs;
  Duration _lastSavedPosition = Duration.zero;

  @override
  void onInit() {
    super.onInit();
     _extractArguments();
    // if (sectionId.isNotEmpty) {
    //   fetchCourseFromSection();
    // }
  }

  void _extractArguments() {
  try {
    final args = Get.arguments;
    
    debugPrint('📥 Received arguments type: ${args.runtimeType}');
    
    // Case 1: CourseData object (from DetailsController)
    if (args is CourseData) {
      courseId = args.id;
      debugPrint('✅ Course ID from CourseData: $courseId');
      debugPrint('📚 Course Title: ${args.title}');
      // Call direct course fetch
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchCourseDirectly();
      });
      return;
    } 
    // Case 2: String (could be section ID or course ID)
    else if (args is String) {
      courseId = args;  // ✅ yaha change
      debugPrint('✅ Course ID received: $courseId');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchCourseFromList(); // ✅ yaha change
      });
      return;
    }
    // Case 3: SectionData object
    else if (args is SectionData) {
      sectionId = args.id;
      debugPrint('✅ Section ID from SectionData: $sectionId');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchCourseFromSection();
      });
      return;
    }
    // Case 4: SectionWithCourses object
    else if (args is SectionWithCourses) {
      sectionId = args.section.id;
      debugPrint('✅ Section ID from SectionWithCourses: $sectionId');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchCourseFromSection();
      });
      return;
    }
    // Case 5: Direct course ID as String (for testing)
    else if (args is String) {
      courseId = args;
      debugPrint('✅ Course ID received: $courseId');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchCourseFromList(); // ✅ yaha change
      });
      return;
    }
    else {
      hasError.value = true;
      errorMessage.value = 'Invalid data format. Expected CourseData or Section ID';
      isLoading.value = false;
      debugPrint('❌ Unknown argument type: ${args.runtimeType}');
    }
  } catch (e) {
    hasError.value = true;
    errorMessage.value = 'Error loading: $e';
    debugPrint('❌ Error extracting arguments: $e');
    isLoading.value = false;
  }
}
  Future<void> fetchCourseFromList() async {
    if (courseId.isEmpty) {
      hasError.value = true;
      errorMessage.value = 'Course ID missing';
      return;
    }

    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await ApiService.get('/api/course');

      if (response['success'] == true && response['data'] != null) {
        final List courses = response['data'];

        final courseData = courses.where((c) => c['_id'] == courseId).toList();

        if (courseData.isNotEmpty) {
          course = CourseDetailModel.fromJson(courseData.first);
          debugPrint('✅ Course found from list: ${course.title}');
        } else {
          hasError.value = true;
          errorMessage.value = 'Course not found';
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Invalid API response';
      }

    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
// Add this method to fetch course directly
Future<void> fetchCourseDirectly() async {
  if (courseId.isEmpty) {
    hasError.value = true;
    errorMessage.value = 'Course ID is missing';
    isLoading.value = false;
    return;
  }

  try {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    final uri = Uri.parse('https://beecodebackend.onrender.com/api/courses/$courseId');
    debugPrint('🌐 Fetching course directly from: $uri');
    
    final response = await http.get(uri).timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw Exception('Connection timeout'),
    );

    debugPrint('📡 Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      
      dynamic courseData;
      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        if (jsonResponse['data'] is List && jsonResponse['data'].isNotEmpty) {
          courseData = jsonResponse['data'].first;
        } else {
          courseData = jsonResponse['data'];
        }
      } else {
        courseData = jsonResponse;
      }

      course = CourseDetailModel.fromJson(courseData);
      debugPrint('✅ Course loaded successfully: ${course.title}');
      
      SchedulerBinding.instance.addPostFrameCallback((_) {
        RecentCoursesService.to.addCourse(course);
      });
    } else if (response.statusCode == 404) {
      hasError.value = true;
      errorMessage.value = 'Course not found (ID: $courseId)';
      debugPrint('❌ Course not found: $courseId');
    } else {
      hasError.value = true;
      errorMessage.value = 'Failed to load course. Please try again.';
      debugPrint('❌ HTTP Error: ${response.statusCode}');
    }
  } catch (e) {
    hasError.value = true;
    errorMessage.value = e.toString().contains('timeout') 
        ? 'Connection timeout. Please check your internet.' 
        : 'Network error. Please try again.';
    debugPrint('❌ Error fetching course: $e');
  } finally {
    isLoading.value = false;
  }
}
  // Fetch course details using course ID
  // Fetch course details using course ID
Future<void> fetchCourseDetails() async {
  if (courseId.isEmpty) {
    hasError.value = true;
    errorMessage.value = 'Course ID is missing';
    isLoading.value = false;
    return;
  }

  try {
    final uri = Uri.parse('https://beecodebackend.onrender.com/api/courses/$courseId');
    debugPrint('🌐 Fetching course from: $uri');
    
    final response = await http.get(uri).timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw Exception('Connection timeout'),
    );

    debugPrint('📡 Course response status: ${response.statusCode}');
    debugPrint('📦 Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      
      // Handle API response structure
      dynamic courseData;
      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        if (jsonResponse['data'] is List && jsonResponse['data'].isNotEmpty) {
          courseData = jsonResponse['data'].first;
          debugPrint('✅ Course data from list: ${courseData['title']}');
        } else {
          courseData = jsonResponse['data'];
          debugPrint('✅ Course data from object: ${courseData['title']}');
        }
      } else {
        courseData = jsonResponse;
        debugPrint('✅ Course data direct: ${courseData['title']}');
      }

      course = CourseDetailModel.fromJson(courseData);
      debugPrint('✅ Course loaded successfully: ${course.title}');
      debugPrint('📚 Total Sections: ${course.sections.length}');

      for (var sec in course.sections) {
        debugPrint('📂 Section: ${sec.title}');
        debugPrint('🎥 Lessons count: ${sec.lessons.length}');
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        RecentCoursesService.to.addCourse(course);
      });
      
    } else if (response.statusCode == 404) {
      hasError.value = true;
      errorMessage.value = 'Course not found (ID: $courseId)';
      debugPrint('❌ Course not found: $courseId');
    } else {
      hasError.value = true;
      errorMessage.value = 'Failed to load course. Please try again.';
      debugPrint('❌ HTTP Error: ${response.statusCode}');
    }
  } catch (e) {
    hasError.value = true;
    errorMessage.value = e.toString().contains('timeout') 
        ? 'Connection timeout. Please check your internet.' 
        : 'Network error. Please try again.';
    debugPrint('❌ Error fetching course: $e');
  } finally {
    isLoading.value = false;
  }
}
  // Add this method to your CourseDetailController
// Fetch course details using section ID
Future<void> fetchCourseFromSection() async {
  if (sectionId.isEmpty) {
    hasError.value = true;
    errorMessage.value = 'Section ID is missing';
    isLoading.value = false;
    return;
  }

  try {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    // Fetch section to get course info
    final sectionUri = Uri.parse('https://beecodebackend.onrender.com/api/sections/$sectionId');
    debugPrint('🌐 Fetching section from: $sectionUri');
    
    final sectionResponse = await http.get(sectionUri).timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw Exception('Connection timeout'),
    );

    debugPrint('📡 Section response status: ${sectionResponse.statusCode}');

    if (sectionResponse.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(sectionResponse.body);
      
      String courseIdFromSection = '';
      
      // ✅ FIX: Parse the response which is an array of sections
      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        final data = jsonResponse['data'];
        
        // Case 1: Data is a List (array of sections)
        if (data is List) {
          // Find the section with matching ID
          for (var section in data) {
            if (section['_id'] == sectionId) {
              // Check for nested courses array
              if (section['courses'] != null && section['courses'] is List) {
                final courses = section['courses'] as List;
                if (courses.isNotEmpty) {
                  final firstCourse = courses.first as Map<String, dynamic>;
                  courseIdFromSection = firstCourse['_id'] ?? '';
                  debugPrint('✅ Found course ID from nested courses: $courseIdFromSection');
                  break;
                }
              }
              
              // Check for single course field
              if (courseIdFromSection.isEmpty && section['course'] != null) {
                if (section['course'] is String) {
                  courseIdFromSection = section['course'];
                } else if (section['course'] is Map<String, dynamic>) {
                  courseIdFromSection = section['course']['_id'] ?? '';
                }
                debugPrint('✅ Found course ID from course field: $courseIdFromSection');
                break;
              }
            }
          }
        } 
        // Case 2: Data is a Map (single section object)
        else if (data is Map<String, dynamic>) {
          if (data['courses'] != null && data['courses'] is List) {
            final courses = data['courses'] as List;
            if (courses.isNotEmpty) {
              final firstCourse = courses.first as Map<String, dynamic>;
              courseIdFromSection = firstCourse['_id'] ?? '';
              debugPrint('✅ Found course ID from nested courses (map): $courseIdFromSection');
            }
          }
          
          if (courseIdFromSection.isEmpty && data['course'] != null) {
            if (data['course'] is String) {
              courseIdFromSection = data['course'];
            } else if (data['course'] is Map<String, dynamic>) {
              courseIdFromSection = data['course']['_id'] ?? '';
            }
            debugPrint('✅ Found course ID from course field (map): $courseIdFromSection');
          }
        }
      }
      
      if (courseIdFromSection.isEmpty) {
        hasError.value = true;
        errorMessage.value = 'No course found for this section';
        debugPrint('❌ Could not extract course ID from section response');
        isLoading.value = false;
        return;
      }
      
      courseId = courseIdFromSection;
      debugPrint('✅ Course ID set: $courseId');
      
      // Now fetch the course details
      await fetchCourseDetails();
      
    } else if (sectionResponse.statusCode == 404) {
      hasError.value = true;
      errorMessage.value = 'Section not found (ID: $sectionId)';
      debugPrint('❌ Section not found: $sectionId');
      isLoading.value = false;
    } else {
      hasError.value = true;
      errorMessage.value = 'Failed to load section. Please try again.';
      debugPrint('❌ HTTP Error: ${sectionResponse.statusCode}');
      isLoading.value = false;
    }
    
  } catch (e) {
    hasError.value = true;
    errorMessage.value = e.toString().contains('timeout') 
        ? 'Connection timeout. Please check your internet.' 
        : 'Network error. Please try again.';
    debugPrint('❌ Error fetching section: $e');
    isLoading.value = false;
  }
}

// Add this helper method to fetch course details

  Future<void> fetchCourseFromSectionsAPI() async {
    try {
      isLoading.value = true;
      
      // Fetch all sections
      final sectionsUri = Uri.parse('https://beecodebackend.onrender.com/api/sections');
      final sectionsResponse = await http.get(sectionsUri).timeout(
        const Duration(seconds: 30),
      );
      
      if (sectionsResponse.statusCode == 200) {
        final sectionsJson = jsonDecode(sectionsResponse.body);
        
        if (sectionsJson['success'] == true && sectionsJson['data'] != null) {
          final sections = sectionsJson['data'] as List;
          
          // Find the section with matching ID
          final targetSection = sections.firstWhere(
            (section) => section['_id'] == sectionId,
            orElse: () => null,
          );
          
          if (targetSection != null) {
            // Check if section has nested courses
            if (targetSection['courses'] != null && targetSection['courses'] is List) {
              final courses = targetSection['courses'] as List;
              if (courses.isNotEmpty) {
                final firstCourse = courses.first;
                courseId = firstCourse['_id'];
                debugPrint('✅ Found course ID from nested courses: $courseId');
                await fetchCourseDetails();
                return;
              }
            }
            
            // Check for single course field
            if (targetSection['course'] != null) {
              if (targetSection['course'] is String) {
                courseId = targetSection['course'];
              } else if (targetSection['course'] is Map<String, dynamic>) {
                courseId = targetSection['course']['_id'] ?? '';
              }
              debugPrint('✅ Found course ID from course field: $courseId');
              await fetchCourseDetails();
              return;
            }
          }
        }
      }
      
      hasError.value = true;
      errorMessage.value = 'No course found for this section';
      isLoading.value = false;
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error fetching section data';
      debugPrint('❌ Error: $e');
      isLoading.value = false;
    }
  }

  // ... rest of your existing methods remain the same
  void clearLastWatched() {
    lastWatchedLesson.value = null;
    lastWatchedTimeLeft.value = '';
    _lastSavedPosition = Duration.zero;
  }

  void updateLastWatched(LessonModel lesson, String timeLeft, Duration position) {
    lastWatchedLesson.value = lesson;
    lastWatchedTimeLeft.value = timeLeft;
    _lastSavedPosition = position;
  }

  void resumeLastWatched() {
    final lesson = lastWatchedLesson.value;

    if (lesson == null) {
      final info = course.resumeInfo;
      if (info.lessonId.isNotEmpty) {
        for (final section in course.sections) {
          for (final l in section.lessons) {
            if (l.id == info.lessonId) {
              _openVideo(l, resumeAt: Duration.zero);
              return;
            }
          }
        }
      }
      return;
    }
    _openVideo(lesson, resumeAt: _lastSavedPosition);
  }

  void _openVideo(LessonModel lesson, {Duration resumeAt = Duration.zero}) async {
    if (lesson.isLocked) return;

    List<LessonModel> sectionLessons = [lesson];
    int lessonIndex = 0;
    for (final section in course.sections) {
      final idx = section.lessons.indexWhere((l) => l.id == lesson.id);
      if (idx != -1) {
        sectionLessons = section.lessons;
        lessonIndex = idx;
        break;
      }
    }

    await Get.to(
      () => const VideoScreen(),
      arguments: {
        'lessons': sectionLessons,
        'index': lessonIndex,
        'resumePosition': resumeAt,
        'courseId': courseId,
      },
      fullscreenDialog: true,
    );

    final savedPos = LessonPlayerController.lastSavedPosition;
    final savedLesson = LessonPlayerController.lastSavedLesson ?? lesson;
    _lastSavedPosition = savedPos;
    lastWatchedLesson.value = savedLesson;
    lastWatchedTimeLeft.value = savedPos.inSeconds > 0
        ? _formatTimeLeft(savedPos)
        : savedLesson.duration;
  }

  String get progressLabel {
    final videosText = '${course.completedVideos} / ${course.totalVideos} Videos';
    return videosText;
  }

  String get progressPercent {
    final percent = (course.progressPercent * 100).toStringAsFixed(0);
    return '$percent%';
  }

  void goBack() => Get.back();

  void onTabSelected(CourseDetailTab tab) => selectedTab.value = tab;

  void onSectionTap(CourseSectionModel section) {
    if (section.isLocked) {
      Get.snackbar(
        'Locked', 
        'Complete previous sections to unlock.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
    }
  }

  String _formatTimeLeft(Duration pos) {
    final mins = pos.inMinutes;
    final secs = pos.inSeconds.remainder(60);
    if (mins > 0) return '$mins Mins $secs Secs Left';
    return '$secs Secs Left';
  }

  Future<void> getCertificate() async {
    if (course.progressPercent < 1.0) {
      Get.snackbar(
        'Certificate Locked',
        'Complete 100% of the course to unlock certificate',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.toNamed("/subscriptionScreen");
  }
}



// class CourseDetailController extends GetxController {
//   final selectedTab = CourseDetailTab.learning.obs;
//   final isLoadingCertificate = false.obs;
//   final isResumingLesson = false.obs;
//   final isLoading = true.obs;
//   final hasError = false.obs;
//   final errorMessage = ''.obs;

//   late String courseId;
//   late CourseDetailModel course;

//   final Rx<LessonModel?> lastWatchedLesson = Rx<LessonModel?>(null);
//   final RxString lastWatchedTimeLeft = ''.obs;
//   Duration _lastSavedPosition = Duration.zero;

//   @override
//   void onInit() {
//     super.onInit();
//     _extractArguments();
//     fetchCourse();
//   }

//   void _extractArguments() {
//     try {
//       if (Get.arguments is String) {
//         courseId = Get.arguments as String;
//       } else if (Get.arguments is Map) {
//         final args = Get.arguments as Map;
//         courseId = args['courseId'] ?? '';
//       } else {
//         courseId = '';
//         hasError.value = true;
//         errorMessage.value = 'Invalid course data';
//       }
//     } catch (e) {
//       hasError.value = true;
//       errorMessage.value = 'Error loading course';
//     }
//   }

//   Future<void> fetchCourse() async {
//     if (courseId.isEmpty) {
//       hasError.value = true;
//       errorMessage.value = 'Course ID is missing';
//       isLoading.value = false;
//       return;
//     }

//     try {
//       isLoading.value = true;
//       hasError.value = false;
//       errorMessage.value = '';

//       final uri = Uri.parse('https://beecodebackend.onrender.com/api/courses/$courseId');
//       final response = await http.get(uri).timeout(
//         const Duration(seconds: 30),
//         onTimeout: () => throw Exception('Connection timeout'),
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
        
//         // Handle API response structure
//         dynamic courseData;
//         if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
//           if (jsonResponse['data'] is List && jsonResponse['data'].isNotEmpty) {
//             courseData = jsonResponse['data'].first;
//           } else {
//             courseData = jsonResponse['data'];
//           }
//         } else {
//           courseData = jsonResponse;
//         }

//         course = CourseDetailModel.fromJson(courseData);
        
//         SchedulerBinding.instance.addPostFrameCallback((_) {
//           RecentCoursesService.to.addCourse(course);
//         });
//       } else if (response.statusCode == 404) {
//         hasError.value = true;
//         errorMessage.value = 'Course not found';
//       } else {
//         hasError.value = true;
//         errorMessage.value = 'Failed to load course. Please try again.';
//       }
//     } catch (e) {
//       hasError.value = true;
//       errorMessage.value = e.toString().contains('timeout') 
//           ? 'Connection timeout. Please check your internet.' 
//           : 'Network error. Please try again.';
//       debugPrint('Error fetching course: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void clearLastWatched() {
//     lastWatchedLesson.value = null;
//     lastWatchedTimeLeft.value = '';
//     _lastSavedPosition = Duration.zero;
//   }

//   void updateLastWatched(LessonModel lesson, String timeLeft, Duration position) {
//     lastWatchedLesson.value = lesson;
//     lastWatchedTimeLeft.value = timeLeft;
//     _lastSavedPosition = position;
//   }

//   void resumeLastWatched() {
//     final lesson = lastWatchedLesson.value;

//     if (lesson == null) {
//       final info = course.resumeInfo;
//       if (info.lessonId.isNotEmpty) {
//         for (final section in course.sections) {
//           for (final l in section.lessons) {
//             if (l.id == info.lessonId) {
//               _openVideo(l, resumeAt: Duration.zero);
//               return;
//             }
//           }
//         }
//       }
//       return;
//     }
//     _openVideo(lesson, resumeAt: _lastSavedPosition);
//   }

//   void _openVideo(LessonModel lesson, {Duration resumeAt = Duration.zero}) async {
//     if (lesson.isLocked) return;

//     List<LessonModel> sectionLessons = [lesson];
//     int lessonIndex = 0;
//     for (final section in course.sections) {
//       final idx = section.lessons.indexWhere((l) => l.id == lesson.id);
//       if (idx != -1) {
//         sectionLessons = section.lessons;
//         lessonIndex = idx;
//         break;
//       }
//     }

//     await Get.to(
//       () => const VideoScreen(),
//       arguments: {
//         'lessons': sectionLessons,
//         'index': lessonIndex,
//         'resumePosition': resumeAt,
//         'courseId': courseId,
//       },
//       fullscreenDialog: true,
//     );

//     final savedPos = LessonPlayerController.lastSavedPosition;
//     final savedLesson = LessonPlayerController.lastSavedLesson ?? lesson;
//     _lastSavedPosition = savedPos;
//     lastWatchedLesson.value = savedLesson;
//     lastWatchedTimeLeft.value = savedPos.inSeconds > 0
//         ? _formatTimeLeft(savedPos)
//         : savedLesson.duration;
//   }

//   String get progressLabel {
//     final videosText = '${course.completedVideos} / ${course.totalVideos} Videos';
//     return videosText;
//   }

//   String get progressPercent {
//     final percent = (course.progressPercent * 100).toStringAsFixed(0);
//     return '$percent%';
//   }

//   void goBack() => Get.back();

//   void onTabSelected(CourseDetailTab tab) => selectedTab.value = tab;

//   void onSectionTap(CourseSectionModel section) {
//     if (section.isLocked) {
//       Get.snackbar(
//         'Locked', 
//         'Complete previous sections to unlock.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.black87,
//         colorText: Colors.white,
//       );
//     }
//   }

//   String _formatTimeLeft(Duration pos) {
//     final mins = pos.inMinutes;
//     final secs = pos.inSeconds.remainder(60);
//     if (mins > 0) return '$mins Mins $secs Secs Left';
//     return '$secs Secs Left';
//   }

//   Future<void> getCertificate() async {
//     if (course.progressPercent < 1.0) {
//       Get.snackbar(
//         'Certificate Locked',
//         'Complete 100% of the course to unlock certificate',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//     Get.toNamed("/subscriptionScreen");
//   }
// }



// import 'package:beecode/screens/home/controller/video_controller.dart';
// import 'package:beecode/screens/home/model/learning_model.dart';
// import 'package:beecode/screens/home/screen/video_screen.dart';
// import 'package:beecode/widget/recent_courses_service.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:get/get.dart';

// class CourseDetailController extends GetxController {
//   final selectedTab = CourseDetailTab.learning.obs;
//   final isLoadingCertificate = false.obs;
//   final isResumingLesson = false.obs;

//   late final CourseDetailModel course;

//   final Rx<LessonModel?> lastWatchedLesson = Rx<LessonModel?>(null);
//   final RxString lastWatchedTimeLeft = ''.obs;

//   Duration _lastSavedPosition = Duration.zero;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadCourse();

//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       RecentCoursesService.to.addCourse(course);
//     });
//   }

//   void clearLastWatched() {
//     lastWatchedLesson.value = null;
//     lastWatchedTimeLeft.value = '';
//   }

//   void updateLastWatched(
//       LessonModel lesson, String timeLeft, Duration position) {
//     lastWatchedLesson.value = lesson;
//     lastWatchedTimeLeft.value = timeLeft;
//     _lastSavedPosition = position;
//   }

//   void resumeLastWatched() {
//     final lesson = lastWatchedLesson.value;

//     if (lesson == null) {
//       final info = course.resumeInfo;
//       if (info.lessonId.isNotEmpty) {
//         for (final section in course.sections) {
//           for (final l in section.lessons) {
//             if (l.id == info.lessonId) {
//               _openVideo(l, resumeAt: Duration.zero);
//               return;
//             }
//           }
//         }
//       }
//       return;
//     }

//     _openVideo(lesson, resumeAt: _lastSavedPosition);
//   }

//   void _openVideo(LessonModel lesson,
//       {Duration resumeAt = Duration.zero}) async {
//     if (lesson.isLocked) return;

//     List<LessonModel> sectionLessons = [lesson];
//     int lessonIndex = 0;
//     for (final section in course.sections) {
//       final idx = section.lessons.indexWhere((l) => l.id == lesson.id);
//       if (idx != -1) {
//         sectionLessons = section.lessons;
//         lessonIndex = idx;
//         break;
//       }
//     }

//     await Get.to(
//       () => const VideoScreen(),
//       arguments: {
//         'lessons': sectionLessons,
//         'index': lessonIndex,
//         'resumePosition': resumeAt,
//       },
//     );

//     final savedPos = LessonPlayerController.lastSavedPosition;
//     final savedLesson = LessonPlayerController.lastSavedLesson ?? lesson;

//     _lastSavedPosition = savedPos;
//     lastWatchedLesson.value = savedLesson;
//     lastWatchedTimeLeft.value = savedPos.inSeconds > 0
//         ? _formatTimeLeft(savedPos)
//         : savedLesson.duration;
//   }

//   void _loadCourse() {
//     course = const CourseDetailModel(
//       courseId: 'excel-beginners-001',
//       title: 'Excel for Beginners',
//       badge: CourseBadgeModel(label: 'FREE', isFree: true),
//       totalVideos: 22,
//       completedVideos: 0,
//       totalAssessments: 3,
//       completedAssessments: 0,
//       progressPercent: 0.0,
//       certificateOffer: CertificateOfferModel(
//         price: '₹349',
//         priceNote: 'Inc. of GST',
//         description: 'Buy the certificate to showcase your skills',
//       ),
//       sections: [
//         CourseSectionModel(
//           title: 'Introduction to Excel',
//           totalVideos: 9,
//           isLocked: false,
//           lessons: [
//             LessonModel(id: 'l1', title: 'What is Excel?', duration: '3 Mins 57 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
//             LessonModel(id: 'l2', title: 'Excel Interface Overview', duration: '5 Mins 12 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
//             LessonModel(id: 'l3', title: 'Entering Data', duration: '4 Mins 33 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
//             LessonModel(id: 'l4', title: 'Basic Formatting', duration: '6 Mins 10 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
//             LessonModel(id: 'l5', title: 'Working with Rows & Cols', duration: '5 Mins 45 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
//             LessonModel(id: 'l6', title: 'Simple Formulas', duration: '7 Mins 02 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
//             LessonModel(id: 'l7', title: 'SUM and AVERAGE', duration: '4 Mins 58 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
//             LessonModel(id: 'l8', title: 'Cell References', duration: '5 Mins 20 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
//             LessonModel(id: 'l9', title: 'Saving & Printing', duration: '3 Mins 40 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
//           ],
//         ),
//         CourseSectionModel(
//           title: 'Charts & Data Visualization',
//           totalVideos: 7,
//           isLocked: true,
//           lessons: [
//             LessonModel(id: 'l10', title: 'Creating Bar Charts',  duration: '6 Mins 00 Secs', isLocked: true),
//             LessonModel(id: 'l11', title: 'Pie Charts',           duration: '4 Mins 30 Secs', isLocked: true),
//             LessonModel(id: 'l12', title: 'Line Graphs',          duration: '5 Mins 15 Secs', isLocked: true),
//             LessonModel(id: 'l13', title: 'Formatting Charts',    duration: '4 Mins 50 Secs', isLocked: true),
//             LessonModel(id: 'l14', title: 'Pivot Charts',         duration: '7 Mins 10 Secs', isLocked: true),
//             LessonModel(id: 'l15', title: 'Sparklines',           duration: '3 Mins 25 Secs', isLocked: true),
//             LessonModel(id: 'l16', title: 'Dashboard Basics',     duration: '8 Mins 00 Secs', isLocked: true),
//           ],
//         ),
//         CourseSectionModel(
//           title: 'Advanced Formulas',
//           totalVideos: 6,
//           isLocked: true,
//           lessons: [
//             LessonModel(id: 'l17', title: 'IF & Nested IF',       duration: '6 Mins 10 Secs', isLocked: true),
//             LessonModel(id: 'l18', title: 'VLOOKUP',              duration: '7 Mins 30 Secs', isLocked: true),
//             LessonModel(id: 'l19', title: 'HLOOKUP',              duration: '5 Mins 55 Secs', isLocked: true),
//             LessonModel(id: 'l20', title: 'INDEX & MATCH',        duration: '8 Mins 20 Secs', isLocked: true),
//             LessonModel(id: 'l21', title: 'COUNTIF & SUMIF',      duration: '6 Mins 45 Secs', isLocked: true),
//             LessonModel(id: 'l22', title: 'Array Formulas',       duration: '9 Mins 00 Secs', isLocked: true),
//           ],
//         ),
//       ],
//       assessments: [
//         AssessmentModel(title: 'Excel – Quiz',                  totalItems: 1, isLocked: true),
//         AssessmentModel(title: 'Claim your course certificate', totalItems: 1, isLocked: true),
//         AssessmentModel(title: 'Final Project',                 totalItems: 1, isLocked: true),
//       ],
//       resumeInfo: ResumeInfoModel(
//         lessonTitle: 'Introduction',
//         timeLeft: '3 Mins 57 Secs Left',
//         lessonId: 'l1',
//       ),
//     );
//   }

//   String get progressLabel =>
//       '${course.completedVideos} / ${course.totalVideos} Videos  ·  '
//       '${course.completedAssessments} / ${course.totalAssessments} Assessments';

//   String get progressPercent =>
//       '${(course.progressPercent * 100).toStringAsFixed(0)}%';

//   void goBack() => Get.back();

//   void onTabSelected(CourseDetailTab tab) => selectedTab.value = tab;

//   void onSectionTap(CourseSectionModel section) {
//     if (section.isLocked) {
//       Get.snackbar('Locked', 'Complete previous sections to unlock.',
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }

//   String _formatTimeLeft(Duration pos) {
//     final mins = pos.inMinutes;
//     final secs = pos.inSeconds.remainder(60);
//     if (mins > 0) return '$mins Mins $secs Secs Left';
//     return '$secs Secs Left';
//   }

//   Future<void> getCertificate() async {
//     Get.toNamed("/subscriptionScreen");
//   }

//   Future<void> resumeCourse() async {
//     isResumingLesson.value = true;
//     await Future.delayed(const Duration(milliseconds: 800));
//     isResumingLesson.value = false;
//     Get.snackbar('Resuming', course.resumeInfo.lessonTitle,
//         snackPosition: SnackPosition.BOTTOM);
//   }
// }


// // import 'package:beecode/screens/home/controller/video_controller.dart';
// // import 'package:beecode/screens/home/model/learning_model.dart';
// // import 'package:beecode/screens/home/screen/video_screen.dart';
// // import 'package:get/get.dart';

// // class CourseDetailController extends GetxController {

// //   final selectedTab = CourseDetailTab.learning.obs;
// //   final isLoadingCertificate = false.obs;
// //   final isResumingLesson = false.obs;

// //   late final CourseDetailModel course;

// //   final Rx<LessonModel?> lastWatchedLesson = Rx<LessonModel?>(null);
// //   final RxString lastWatchedTimeLeft = ''.obs;


// //   Duration _lastSavedPosition = Duration.zero;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _loadCourse();
  
// //   }
// // void clearLastWatched() {
// //   lastWatchedLesson.value = null;
// //   lastWatchedTimeLeft.value = '';
// // }
  
// //   void updateLastWatched(LessonModel lesson, String timeLeft, Duration position) {
// //     lastWatchedLesson.value = lesson;
// //     lastWatchedTimeLeft.value = timeLeft;
// //     _lastSavedPosition = position; 
// //   }

// //   void resumeLastWatched() {
// //     final lesson = lastWatchedLesson.value;

// //     if (lesson == null) {
// //       final info = course.resumeInfo;
// //       if (info.lessonId.isNotEmpty) {
// //         for (final section in course.sections) {
// //           for (final l in section.lessons) {
// //             if (l.id == info.lessonId) {
// //               _openVideo(l, resumeAt: Duration.zero);
// //               return;
// //             }
// //           }
// //         }
// //       }
// //       return;
// //     }

  
// //     _openVideo(lesson, resumeAt: _lastSavedPosition);
// //   }

// //   void _openVideo(LessonModel lesson, {Duration resumeAt = Duration.zero}) async {
// //     if (lesson.isLocked) return;

// //     List<LessonModel> sectionLessons = [lesson];
// //     int lessonIndex = 0;
// //     for (final section in course.sections) {
// //       final idx = section.lessons.indexWhere((l) => l.id == lesson.id);
// //       if (idx != -1) {
// //         sectionLessons = section.lessons;
// //         lessonIndex = idx;
// //         break;
// //       }
// //     }

// //     await Get.to(
// //       () => const VideoScreen(),
// //       arguments: {
// //         'lessons': sectionLessons,
// //         'index': lessonIndex,
// //         'resumePosition': resumeAt,
// //       },
// //     );

  
// //     final savedPos = LessonPlayerController.lastSavedPosition;
// //     final savedLesson = LessonPlayerController.lastSavedLesson ?? lesson;

// //     _lastSavedPosition = savedPos;
// //     lastWatchedLesson.value = savedLesson;
// //     lastWatchedTimeLeft.value = savedPos.inSeconds > 0
// //         ? _formatTimeLeft(savedPos)
// //         : savedLesson.duration;
// //   }

// //   void _loadCourse() {
// //     course = const CourseDetailModel(
// //       courseId: 'excel-beginners-001',
// //       title: 'Excel for Beginners',
// //       badge: CourseBadgeModel(label: 'FREE', isFree: true),
// //       totalVideos: 22,
// //       completedVideos: 0,
// //       totalAssessments: 3,
// //       completedAssessments: 0,
// //       progressPercent: 0.0,
// //       certificateOffer: CertificateOfferModel(
// //         price: '₹349',
// //         priceNote: 'Inc. of GST',
// //         description: 'Buy the certificate to showcase your skills',
// //       ),
// //       sections: [
// //         CourseSectionModel(
// //           title: 'Introduction to Excel',
// //           totalVideos: 9,
// //           isLocked: false,
// //           lessons: [
// //             LessonModel(id: 'l1', title: 'What is Excel?', duration: '3 Mins 57 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
// //             LessonModel(id: 'l2', title: 'Excel Interface Overview', duration: '5 Mins 12 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
// //             LessonModel(id: 'l3', title: 'Entering Data', duration: '4 Mins 33 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
// //             LessonModel(id: 'l4', title: 'Basic Formatting', duration: '6 Mins 10 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
// //             LessonModel(id: 'l5', title: 'Working with Rows & Cols', duration: '5 Mins 45 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
// //             LessonModel(id: 'l6', title: 'Simple Formulas', duration: '7 Mins 02 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
// //             LessonModel(id: 'l7', title: 'SUM and AVERAGE', duration: '4 Mins 58 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
// //             LessonModel(id: 'l8', title: 'Cell References', duration: '5 Mins 20 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
// //             LessonModel(id: 'l9', title: 'Saving & Printing', duration: '3 Mins 40 Secs', isCompleted: false, videoUrl: 'https://vz-fd5fa6c8-ece.b-cdn.net/24d07fc8-2468-45f9-95be-290a06553197/playlist.m3u8'),
// //           ],
// //         ),
// //         CourseSectionModel(
// //           title: 'Charts & Data Visualization',
// //           totalVideos: 7,
// //           isLocked: true,
// //           lessons: [
// //             LessonModel(id: 'l10', title: 'Creating Bar Charts',  duration: '6 Mins 00 Secs', isLocked: true),
// //             LessonModel(id: 'l11', title: 'Pie Charts',           duration: '4 Mins 30 Secs', isLocked: true),
// //             LessonModel(id: 'l12', title: 'Line Graphs',          duration: '5 Mins 15 Secs', isLocked: true),
// //             LessonModel(id: 'l13', title: 'Formatting Charts',    duration: '4 Mins 50 Secs', isLocked: true),
// //             LessonModel(id: 'l14', title: 'Pivot Charts',         duration: '7 Mins 10 Secs', isLocked: true),
// //             LessonModel(id: 'l15', title: 'Sparklines',           duration: '3 Mins 25 Secs', isLocked: true),
// //             LessonModel(id: 'l16', title: 'Dashboard Basics',     duration: '8 Mins 00 Secs', isLocked: true),
// //           ],
// //         ),
// //         CourseSectionModel(
// //           title: 'Advanced Formulas',
// //           totalVideos: 6,
// //           isLocked: true,
// //           lessons: [
// //             LessonModel(id: 'l17', title: 'IF & Nested IF',       duration: '6 Mins 10 Secs', isLocked: true),
// //             LessonModel(id: 'l18', title: 'VLOOKUP',              duration: '7 Mins 30 Secs', isLocked: true),
// //             LessonModel(id: 'l19', title: 'HLOOKUP',              duration: '5 Mins 55 Secs', isLocked: true),
// //             LessonModel(id: 'l20', title: 'INDEX & MATCH',        duration: '8 Mins 20 Secs', isLocked: true),
// //             LessonModel(id: 'l21', title: 'COUNTIF & SUMIF',      duration: '6 Mins 45 Secs', isLocked: true),
// //             LessonModel(id: 'l22', title: 'Array Formulas',       duration: '9 Mins 00 Secs', isLocked: true),
// //           ],
// //         ),
// //       ],
// //       assessments: [
// //         AssessmentModel(title: 'Excel – Quiz',                  totalItems: 1, isLocked: true),
// //         AssessmentModel(title: 'Claim your course certificate', totalItems: 1, isLocked: true),
// //         AssessmentModel(title: 'Final Project',                 totalItems: 1, isLocked: true),
// //       ],
// //       resumeInfo: ResumeInfoModel(
// //         lessonTitle: 'Introduction',
// //         timeLeft: '3 Mins 57 Secs Left',
// //         lessonId: 'l1',
// //       ),
// //     );
// //   }

// //   String get progressLabel =>
// //       '${course.completedVideos} / ${course.totalVideos} Videos  ·  '
// //       '${course.completedAssessments} / ${course.totalAssessments} Assessments';

// //   String get progressPercent =>
// //       '${(course.progressPercent * 100).toStringAsFixed(0)}%';

// //   void goBack() => Get.back();

// //   void onTabSelected(CourseDetailTab tab) => selectedTab.value = tab;

// //   void onSectionTap(CourseSectionModel section) {
// //     if (section.isLocked) {
// //       Get.snackbar('Locked', 'Complete previous sections to unlock.',
// //           snackPosition: SnackPosition.BOTTOM);
// //     }
// //   }

// //   String _formatTimeLeft(Duration pos) {
// //     final mins = pos.inMinutes;
// //     final secs = pos.inSeconds.remainder(60);
// //     if (mins > 0) return '$mins Mins $secs Secs Left';
// //     return '$secs Secs Left';
// //   }

// //   Future<void> getCertificate() async {
// //     Get.toNamed("/subscriptionScreen");
// //   }

// //   Future<void> resumeCourse() async {
// //     isResumingLesson.value = true;
// //     await Future.delayed(const Duration(milliseconds: 800));
// //     isResumingLesson.value = false;
// //     Get.snackbar('Resuming', course.resumeInfo.lessonTitle,
// //         snackPosition: SnackPosition.BOTTOM);
// //   }
// // }

