// lib/screens/home/service/section_service.dart
import 'dart:convert';
import 'package:beecode/screens/home/model/coures_model.dart';
import 'package:beecode/screens/utils/api.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:http/http.dart' as http;
import 'package:beecode/screens/home/model/home_model.dart';

class SectionService {
  // API Endpoints - Fix the spelling
  // static const String baseUrl = 'https://beecodebackend.onrender.com';
  // static const String sectionsEndpoint = '/api/sections';
  // static const String coursesEndpoint = '/api/coures';  
  
  // ─────────────────────────────────────────────
  // Fetch all sections
  // ─────────────────────────────────────────────
  Future<List<SectionData>> fetchSections({String? categoryId}) async {
    try {
      String url = MyApi.section;
      if (categoryId != null && categoryId.isNotEmpty) {
        url += '?categoryId=$categoryId';
      }
      
      debugPrint('🌐 [SECTIONS] Fetching from: ${MyApi.section}');
      
      final response = await http.get(
        Uri.parse(MyApi.section),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));
      
      debugPrint('📡 [SECTIONS] Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          final List<dynamic> sectionsData = data['data'];
          debugPrint('✅ [SECTIONS] Total sections received: ${sectionsData.length}');
          
          final sections = sectionsData.map((json) {
            final section = SectionData.fromJson(json);
            debugPrint(
              '📦 [SECTION] ID: ${section.id}, Title: "${section.title}", Order: ${section.order}, Course ID: ${section.course.id ?? ''}',
            );
            return section;
          }).toList();
          
          sections.sort((a, b) => a.order.compareTo(b.order));
          
          debugPrint('✅ [SECTIONS] Successfully parsed ${sections.length} sections');
          return sections;
        }
      }
      return [];
      
    } catch (e) {
      debugPrint('❌ [SECTIONS] Error: $e');
      return [];
    }
  }
  
  // ─────────────────────────────────────────────
  // Fetch all courses - FIXED ENDPOINT
  // ─────────────────────────────────────────────
  Future<List<CourseData>> fetchAllCourses({String? categoryId, bool? isFree}) async {
    try {
      String url = MyApi.coures;  // Now '/api/coures'
      final params = <String>[];
      
      if (categoryId != null && categoryId.isNotEmpty) {
        params.add('category=$categoryId');
      }
      if (isFree != null) {
        params.add('isFree=$isFree');
      }
      
      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }
      
      debugPrint('🌐 [COURSES] Fetching from: ${MyApi.coures}');
      
      final response = await http.get(
        Uri.parse(MyApi.coures),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));
      
      debugPrint('📡 [COURSES] Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        debugPrint('📡 [COURSES] Response body preview: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
        
        if (data['success'] == true) {
          final List<dynamic> coursesData = data['data'];
          debugPrint('✅ [COURSES] Total courses received: ${coursesData.length}');
          
          final courses = coursesData.map((json) {
            final course = CourseData.fromJson(json);
            debugPrint('🎓 [COURSE] ID: ${course.id}, Title: "${course.title}", Institute: "${course.instituteName}"');
            return course;
          }).toList();
          
          debugPrint('✅ [COURSES] Successfully parsed ${courses.length} courses');
          return courses;
        } else {
          debugPrint('⚠️ [COURSES] API returned success: false');
          return [];
        }
      } else {
        debugPrint('❌ [COURSES] HTTP Error: ${response.statusCode}');
        return [];
      }
      
    } catch (e) {
      debugPrint('❌ [COURSES] Error: $e');
      return [];
    }
  }
  
  // ─────────────────────────────────────────────
  // Fetch sections with their courses (combined)
  // ─────────────────────────────────────────────
  // ─────────────────────────────────────────────
// Fetch sections with their courses (combined) - FIXED VERSION
// ─────────────────────────────────────────────
// ─────────────────────────────────────────────
// Fetch sections with their courses (combined)
// ─────────────────────────────────────────────
Future<List<SectionWithCourses>> fetchSectionsWithCourses() async {
  try {
    debugPrint('🌐 [SECTIONS-WITH-COURSES] Fetching sections with courses...');
    
    // Fetch sections and all courses in parallel
    final results = await Future.wait([
      fetchSections(),
      fetchAllCourses(),
    ]);
    
    final sections = results[0] as List<SectionData>;
    final allCourses = results[1] as List<CourseData>;
    
    debugPrint('✅ Found ${sections.length} sections and ${allCourses.length} total courses');
    
    // Create a map for quick course lookup by ID
    final Map<String, CourseData> courseMap = {
      for (var course in allCourses) course.id: course
    };
    
    final List<SectionWithCourses> result = [];
    
    for (var section in sections) {
      List<CourseData> sectionCourses = [];
      
      // Check if section has its own courses array in the response
      // But since we're fetching sections separately, we need to match by course ID
      // Each section has a 'course' field (single course ID)
      final courseId = section.course.id;

      if (courseId.isNotEmpty && courseMap.containsKey(courseId)) {
        sectionCourses.add(courseMap[courseId]!);
      }
      // if (courseId.isNotEmpty && courseMap.containsKey(courseId)) {
      //   // Section has a single course
      //   sectionCourses.add(courseMap[courseId]!);
      //   debugPrint('📚 Section "${section.title}" has 1 course: ${courseMap[courseId]!.title}');
      // }
      
      result.add(SectionWithCourses(
        section: section,
        courses: sectionCourses,
      ));
    }
    
    debugPrint('✅ [SECTIONS-WITH-COURSES] Successfully processed ${result.length} sections');
    return result;
    
  } catch (e) {
    debugPrint('❌ [SECTIONS-WITH-COURSES] Error: $e');
    return [];
  }
}
  
  // ─────────────────────────────────────────────
  // Fetch trending courses - use regular courses as trending
  // ─────────────────────────────────────────────
  Future<List<CourseData>> fetchTrendingCourses({int limit = 10}) async {
    try {
      debugPrint('🌐 [TRENDING] Fetching courses for trending, limit: $limit');
      
      // Just fetch all courses and use them as trending
      final allCourses = await fetchAllCourses();
      
      if (allCourses.isNotEmpty) {
        // Sort by rating or total students for trending
        final sorted = List<CourseData>.from(allCourses);
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        
        final trending = sorted.take(limit).toList();
        debugPrint('✅ [TRENDING] Using ${trending.length} courses as trending (sorted by rating)');
        
        for (var i = 0; i < trending.length && i < 3; i++) {
          debugPrint('  📈 Trending ${i+1}: ${trending[i].title} (Rating: ${trending[i].rating})');
        }
        
        return trending;
      }
      
      debugPrint('⚠️ [TRENDING] No courses found');
      return [];
      
    } catch (e) {
      debugPrint('❌ [TRENDING] Error: $e');
      return [];
    }
  }
  Future<List<SectionWithCourses>> fetchSectionsWithCoursesDirect() async {
  try {
    debugPrint('🌐 [SECTIONS-DIRECT] Fetching sections from: ${MyApi.section}');
    
    final response = await http.get(
      Uri.parse(MyApi.section),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 30));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      
      if (data['success'] == true && data['data'] != null) {
        final List<dynamic> sectionsData = data['data'];
        debugPrint('✅ Found ${sectionsData.length} sections with nested courses');
        
        // First, fetch all courses to get full details
        final allCourses = await fetchAllCourses();
        final Map<String, CourseData> courseMap = {
          for (var course in allCourses) course.id: course
        };
        
        final List<SectionWithCourses> result = [];
        
        for (var sectionJson in sectionsData) {
          final section = SectionData.fromJson(sectionJson);
          List<CourseData> sectionCourses = [];
          
          // Check for nested courses array
          if (sectionJson['courses'] != null && sectionJson['courses'] is List) {
            final nestedCourses = sectionJson['courses'] as List;
            debugPrint('  📚 Section "${section.title}" has ${nestedCourses.length} nested courses');
            
            for (var nestedCourse in nestedCourses) {
              if (nestedCourse is Map<String, dynamic>) {
                final courseId = nestedCourse['_id'] as String?;
                if (courseId != null && courseMap.containsKey(courseId)) {
                  sectionCourses.add(courseMap[courseId]!);
                } else if (courseId != null) {
                  // Create minimal course if full details not found
                  sectionCourses.add(CourseData(
                    id: courseId,
                    title: nestedCourse['title'] ?? 'Untitled',
                    subtitle: '',
                    description: '',
                    instituteName: '',
                    instituteLogo: '',
                    thumbnail: Thumbnail(url: ''),
                    bannerImage: BannerImage(url: ''),
                    certificate: Certificate(title: '', issuedBy: '', sampleImage: ''),
                    features: Features(careerSupport: false, projects: 0, alumni: 0),
                    category: CourseCategory(id: '', name: ''),
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
                  ));
                }
              }
            }
          }
          
          result.add(SectionWithCourses(
            section: section,
            courses: sectionCourses,
          ));
        }
        
        return result;
      }
    }
    
    return [];
    
  } catch (e) {
    debugPrint('❌ [SECTIONS-DIRECT] Error: $e');
    return [];
  }
}
  // ─────────────────────────────────────────────
  // Fetch free courses
  // ─────────────────────────────────────────────
  Future<List<CourseData>> fetchFreeCourses({int limit = 20}) async {
    try {
      debugPrint('🌐 [FREE] Fetching free courses, limit: $limit');
      
      final allCourses = await fetchAllCourses();
      
      if (allCourses.isNotEmpty) {
        final freeCourses = allCourses.where((c) => c.isFree == true).toList();
        final limited = freeCourses.take(limit).toList();
        
        debugPrint('✅ [FREE] Found ${freeCourses.length} free courses, showing ${limited.length}');
        
        for (var i = 0; i < limited.length && i < 3; i++) {
          debugPrint('  🆓 Free ${i+1}: ${limited[i].title}');
        }
        
        return limited;
      }
      
      debugPrint('⚠️ [FREE] No free courses found');
      return [];
      
    } catch (e) {
      debugPrint('❌ [FREE] Error: $e');
      return [];
    }
  }
  
  // ─────────────────────────────────────────────
  // Fetch course by ID
  // ─────────────────────────────────────────────
  Future<CourseData?> fetchCourseById(String courseId) async {
    try {
      debugPrint('🌐 [COURSE] Fetching course by ID: $courseId');
      
      final allCourses = await fetchAllCourses();
      final course = allCourses.firstWhereOrNull((c) => c.id == courseId);
      
      if (course != null) {
        debugPrint('✅ [COURSE] Found: "${course.title}"');
        return course;
      }
      
      debugPrint('⚠️ [COURSE] Course not found: $courseId');
      return null;
      
    } catch (e) {
      debugPrint('❌ [COURSE] Error: $e');
      return null;
    }
  }
  
  // ─────────────────────────────────────────────
  // Search courses
  // ─────────────────────────────────────────────
  Future<List<CourseData>> searchCourses(String query) async {
    try {
      debugPrint('🔍 [SEARCH] Searching courses with query: "$query"');
      
      final allCourses = await fetchAllCourses();
      final results = allCourses.where((c) =>
        c.title.toLowerCase().contains(query.toLowerCase()) ||
        c.instituteName.toLowerCase().contains(query.toLowerCase())
      ).toList();
      
      debugPrint('✅ [SEARCH] Found ${results.length} courses matching "$query"');
      return results;
      
    } catch (e) {
      debugPrint('❌ [SEARCH] Error: $e');
      return [];
    }
  }
}

// Add this to your home_models.dart file

// Add this to home_models.dart, not in the service file
class SectionWithCourses {
  final SectionData section;
  final List<CourseData> courses;

  SectionWithCourses({
    required this.section,
    required this.courses,
  });

  factory SectionWithCourses.fromJson(
      Map<String, dynamic> json, {
        List<CourseData>? allCourses,
      }) {
    final section = SectionData.fromJson(json);

    List<CourseData> parsedCourses = [];

    final rawCourses = json['courses'];

    if (rawCourses != null && rawCourses is List) {
      for (var item in rawCourses) {
        if (item is Map<String, dynamic>) {
          final courseId = item['_id']?.toString();

          CourseData? matchedCourse;

          if (allCourses != null && courseId != null) {
            try {
              matchedCourse =
                  allCourses.firstWhere((c) => c.id == courseId);
            } catch (_) {
              matchedCourse = null;
            }
          }

          if (matchedCourse != null) {
            parsedCourses.add(matchedCourse);
          } else {
            parsedCourses.add(
              CourseData(
                id: courseId ?? '',
                title: item['title'] ?? 'Python',
                subtitle: '',
                description: '',
                instituteName: '',
                instituteLogo: '',
                thumbnail: Thumbnail(url: ''),
                bannerImage: BannerImage(url: ''),
                certificate:
                Certificate(title: '', issuedBy: '', sampleImage: ''),
                features:
                Features(careerSupport: false, projects: 0, alumni: 0),
                category: CourseCategory(id: '', name: ''),
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
              ),
            );
          }
        }
      }
    }

    return SectionWithCourses(
      section: section,
      courses: parsedCourses,
    );
  }
}