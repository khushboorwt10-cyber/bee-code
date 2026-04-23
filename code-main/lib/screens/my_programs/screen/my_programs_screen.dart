// lib/screens/my_programs/screen/my_programs_page.dart

import 'package:beecode/bottom_nav/controller/bottom_controller.dart';
import 'package:beecode/screens/call/screen/call_screen.dart';
import 'package:beecode/screens/home/controller/course_detail_controller.dart';
import 'package:beecode/screens/home/model/learning_model.dart';
import 'package:beecode/screens/home/screen/course_detail_screen.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/images.dart';
import 'package:beecode/widget/profile_icon.dart';
import 'package:beecode/widget/recent_courses_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyProgramsPage extends StatelessWidget {
  const MyProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.h,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        shadowColor: Colors.black.withValues(alpha: 0.15),
        elevation: 4,
        surfaceTintColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                AppImages.logoblack,
                height: 30.h,
                width: 80.w,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap:showSupportSheet,
                    child: HeaderIconButton(icon: Icons.call_outlined, isHome: false)),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () => Get.toNamed("/profileScreen"),
                    child: HeaderIconButton(
                        icon: Icons.person_outline_rounded, isHome: false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
            Expanded(child: _Body()),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final courses = RecentCoursesService.to.recentCourses;

      if (courses.isEmpty) {
        return _EmptyState();
      }

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        children: [
          // ── Header ──────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ongoing Program',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              Icon(Icons.search, size: 24.sp, color: Colors.black87),
            ],
          ),
          SizedBox(height: 14.h),

          // ── Course cards ────────────────────────────────────────────
          ...courses.map((course) => _ProgramCard(course: course)),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Program Card — upGrad style
// ─────────────────────────────────────────────────────────────────────────────
class _ProgramCard extends StatelessWidget {
  final CourseDetailModel course;
  const _ProgramCard({required this.course});

  void _navigate() {
    // Purana controller delete karo taaki fresh load ho
    if (Get.isRegistered<CourseDetailController>()) {
      Get.delete<CourseDetailController>();
    }
    Get.to(
      () => const CourseDetailScreen(),
      arguments: course, // agar tumhara controller Get.arguments use karta ho
    );
  }

  @override
  Widget build(BuildContext context) {
    // Total duration calculate karo sabhi lessons se
    final totalMins = course.sections
        .expand((s) => s.lessons)
        .fold<int>(0, (sum, l) => sum + _parseMins(l.duration));

    final durationLabel = totalMins > 0
        ? '${totalMins ~/ 60} hrs ${totalMins % 60} mins'
        : '${course.totalVideos} Videos';

    return GestureDetector(
      onTap: _navigate,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Thumbnail placeholder (logo style) ──────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                width: 72.w,
                height: 72.w,
                color: const Color(0xFFE8ECFF),
                child: Center(
                  child: Icon(
                    Icons.play_lesson_outlined,
                    size: 30.sp,
                    color: const Color(0xFF1A3BE8).withOpacity(0.5),
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),

            // ── Title + duration + CTA ───────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    course.title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),

                  // Duration
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 13.sp, color: Colors.black45),
                      SizedBox(width: 4.w),
                      Text(
                        durationLabel,
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.black45),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  // Continue button
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          course.progressPercent > 0
                              ? 'Continue'
                              : 'Get Started',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(Icons.chevron_right_rounded,
                            size: 18.sp, color: Colors.black54),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  int _parseMins(String duration) {
    final match = RegExp(r'(\d+)\s*Mins?').firstMatch(duration);
    return match != null ? int.tryParse(match.group(1) ?? '0') ?? 0 : 0;
  }
}
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 36.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, size: 100.sp, color: Colors.blueGrey.shade200),
            SizedBox(height: 24.h),
            Text(
              'No courses found',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Open a course from Home,\nit will automatically appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF888888),
                height: 1.6,
              ),
            ),
            SizedBox(height: 28.h),
            SizedBox(
              width: 190.w,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () =>
                    Get.find<BottomNavController>().changeTab(0),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Explore Now',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}