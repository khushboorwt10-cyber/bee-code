
import 'package:beecode/screens/home/model/learning_model.dart';
import 'package:get/get.dart';
 
class RecentCoursesService extends GetxService {
  static RecentCoursesService get to => Get.find();
 
  // Memory mein courses ki list — duplicates nahi aayenge
  final RxList<CourseDetailModel> recentCourses =
      <CourseDetailModel>[].obs;
 
  /// Jab bhi CourseDetailScreen khule, yeh call karo.
  /// Agar course already list mein hai toh pehle remove karke
  /// top pe rakh do (most recent first).
  void addCourse(CourseDetailModel course) {
    recentCourses.removeWhere((c) => c.courseId == course.courseId);
    recentCourses.insert(0, course);
  }
}
 