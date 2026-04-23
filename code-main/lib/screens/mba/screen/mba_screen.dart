import 'package:beecode/screens/home/controller/details_controller.dart';
import 'package:beecode/screens/mba/controller/mba_controller.dart';
import 'package:beecode/screens/mba/model/mba_model.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MbaCoursesScreen extends StatelessWidget {
  const MbaCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MbaCoursesController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: 18.sp, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'MBA Courses',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: ListView(
        children: [
          _HeroBanner(controller: controller),

          SizedBox(height: 20.h),

  
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                children: const [
                  TextSpan(text: 'Online MBA Course from '),
                  TextSpan(
                    text: 'Top\nUniversities',
                    style: TextStyle(color: AppColors.black),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 12.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 15.sp, color: Colors.black87),
                        children: [
                          const TextSpan(
                              text: 'MBA Courses ',
                              style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: '(${controller.courses.length})',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    )),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.tune, size: 16.sp, color: Colors.black87),
                  label: Text('Filter',
                      style:
                          TextStyle(fontSize: 14.sp, color: Colors.black87)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black26),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 8.h),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),

         
          Obx(() => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.courses.length,
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (_, i) =>
                    _CourseCard(course: controller.courses[i]),
              )),

          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.controller});
  final MbaCoursesController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D1B2A), Color(0xFF1B3A4B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Online MBA Courses',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          SizedBox(height: 18.h),
          ...[
            'Master business, leadership & strategy skills with MBA courses',
            'Learn at your pace with globally recognized online MBA degree',
            'Gain expertise in finance, marketing, operations & analytics skills',
            'Get up to 58% average salary hike across online MBA courses',
          ].map((text) => _BulletPoint(text: text)),

          SizedBox(height: 18.h),

         
          Container(
            padding:
                EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                    label: 'Learner count',
                    value: controller.learnerCount),
                _Divider(),
                _StatItem(
                    label: 'Avg. pay hike',
                    value: controller.avgPayHike),
                _Divider(),
                _StatItem(
                    label: 'Top pay hike',
                    value: controller.topPayHike),
              ],
            ),
          ),

          SizedBox(height: 18.h),

         
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor:  AppColors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                elevation: 0,
              ),
              child: Text(
                'Explore Courses',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline,
              color: Colors.tealAccent, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 13.5.sp,
                  color: Colors.white70,
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 11.sp, color: Colors.white60)),
        SizedBox(height: 4.h),
        Text(value,
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 36.h, width: 1, color: Colors.white24);
  }
}
class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});
  final MbaCourse course;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
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
          // Logo + Badge
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: 24.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.r),
                    topRight: Radius.circular(14.r),
                  ),
                ),
                child: Center(
                  child: Image.network(
                    course.universityLogo,
                    height: 60.h,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.account_balance,
                      size: 48.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              if (course.badge != null)
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: course.badgeColor ?? Colors.purple,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      course.badge!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.universityName,
                  style: TextStyle(
                      fontSize: 12.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 4.h),
                Text(
                  course.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (course.tag != null) ...[
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      course.tag!,
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF1565C0),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(Icons.school_outlined,
                        size: 16.sp, color: Colors.grey),
                    SizedBox(width: 6.w),
                    Text(course.degreeType,
                        style: TextStyle(
                            fontSize: 13.sp, color: Colors.black54)),
                    SizedBox(width: 20.w),
                    Icon(Icons.calendar_today_outlined,
                        size: 16.sp, color: Colors.grey),
                    SizedBox(width: 6.w),
                    Text(course.duration,
                        style: TextStyle(
                            fontSize: 13.sp, color: Colors.black54)),
                  ],
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.delete<DetailsController>();
                    Get.toNamed(Routes.detailsScreen, arguments: {'title': course.title});
                      // Get.toNamed(Routes.detailsScreen, arguments: course);
                        },
                        style: OutlinedButton.styleFrom(
                          side:
                              const BorderSide(color: Colors.black26),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          'View Program',
                          style: TextStyle(
                              fontSize: 13.sp, color: Colors.black87),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.download_outlined,
                            size: 16.sp, color: Colors.white),
                        label: Text(
                          'Syllabus',
                          style: TextStyle(
                              fontSize: 13.sp, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  AppColors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}