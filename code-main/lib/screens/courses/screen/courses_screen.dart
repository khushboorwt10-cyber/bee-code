import 'package:beecode/screens/call/controller/call_controller.dart';
import 'package:beecode/screens/courses/controller/courses_controller.dart';
import 'package:beecode/screens/courses/model/courses_model.dart';
import 'package:beecode/screens/home/controller/details_controller.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:beecode/screens/utils/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class CoursesScreen extends StatelessWidget {
  CoursesScreen({super.key});

  final CoursesController controller = Get.put(CoursesController());
 @override
Widget build(BuildContext context) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light,
    child: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Column(
          children: [
            _buildHeader(context),
            _buildDomainTabs(),
            Divider(color: Colors.grey.shade200, height: 1),
            _buildLevelFilter(),
            Divider(color: Colors.grey.shade200, height: 1),
            Expanded(child: _buildCourseList()),
          ],
        ),
      ),
    ),
  );
}
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 16.h,
        left: 16.w,
        right: 16.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "All Courses",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Obx(() => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.prime,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      "${controller.filteredCourses.length} Courses",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
            ],
          ),
          SizedBox(height: 14.h),

          // Search bar
          Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                SizedBox(width: 12.w),
                Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search courses, institutes...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13.sp,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Obx(() => controller.searchQuery.value.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          controller.searchController.clear();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: Icon(Icons.close_rounded,
                              color: Colors.grey.shade400, size: 18),
                        ),
                      )
                    : const SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainTabs() {
    return Container(
      color: Colors.white,
      child: Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: controller.domains.map((domain) {
                final isSelected = controller.selectedDomain.value == domain;
                return GestureDetector(
                  onTap: () => controller.selectedDomain.value = domain,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? Colors.black
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Text(
                      domain,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )),
    );
  }


  Widget _buildLevelFilter() {
    return Container(
      color: Colors.white,
      child: Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Text(
                  "Level: ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4.w),
                ...controller.levels.map((level) {
                  final isSelected = controller.selectedLevel.value == level;
                  return GestureDetector(
                    onTap: () => controller.selectedLevel.value = level,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.prime.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.prime
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        level,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.prime
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          )),
    );
  }


  Widget _buildCourseList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerList();
      }

      final courses = controller.filteredCourses;

      if (courses.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: courses.length,
        separatorBuilder: (_, _) => SizedBox(height: 14.h),
        itemBuilder: (context, index) =>
            _courseCard(courses[index])
      );
    });
  }


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 56, color: Colors.grey.shade300),
          SizedBox(height: 16.h),
          Text(
            "No courses found",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Try adjusting your filters",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: 4,
      separatorBuilder: (_, _) => SizedBox(height: 14.h),
      itemBuilder: (_, _) =>
          ShimmerBox(width: double.infinity, height: 260.h, radius: 16),
    );
  }
  Widget _courseCard(CourseScreenModel course) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 140.h,
              child: Image.network(
                course.logo,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade100,
                  child: Icon(Icons.school_rounded, size: 40),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.institute,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  course.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 8.h),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    course.tag,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                Row(
                  children: [
                    Text(course.type),
                    SizedBox(width: 12.w),
                    Text("${course.duration} Months"),
                  ],
                ),
              ],
            ),
          ),

          Divider(),

          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                  //    Get.delete<DetailsController>();

                      // ✅ IMPORTANT FIX HERE
                      Get.toNamed(
                        Routes.detailsScreen,
                        arguments: {
                          "courseId": course.id ?? course.title, // fallback safe
                          "title": course.title,
                          "course": course, // full object bhi pass
                        },
                      );

                      print("course id: ${course.id}");
                      print("course title: ${course.title}");
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
            child: Text(
              "View Program",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ), ),
                ),
                ),
                SizedBox(width: 10.w),

                Expanded(
    child: ElevatedButton.icon(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.r),
    ),
    padding: EdgeInsets.symmetric(vertical: 10.h),
    elevation: 0,
    ),
    icon: const Icon(
    Icons.download_outlined,
    color: Colors.white,
    size: 15,
    ),
    label: Text(
    "Syllabus",
    style: TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
                  ),
                ),
                  ),
                )
              ],
            ),
          ),


          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have questions? ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(
                      Icons.wifi_calling_3_outlined,
                      color: Colors.yellow,
                      size: 16.sp,
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                         Get.back();
                    LearnerSupportController.makeCall("734 757 4707");
                      },
                      child: Text(
                        'Talk to expert',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.yellow,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _levelColor(String level) {
    switch (level) {
      case 'Beginner':
        return Colors.green.shade600;
      case 'Intermediate':
        return Colors.orange.shade700;
      case 'Advanced':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
