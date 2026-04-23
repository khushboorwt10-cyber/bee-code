import 'package:beecode/screens/data_science/controller/data_science_controller.dart';
import 'package:beecode/screens/data_science/model/data_science_model.dart';
import 'package:beecode/screens/home/controller/details_controller.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DataScienceScreen extends StatelessWidget {
  const DataScienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DataSciencePromotionController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(),
            _buildThankYouCard(),
            _buildCoursesSection(controller.courses),
            _buildStartLearningSection(controller.freeCourses),
            _buildViewAllButton(),
            _buildGenerativeAISection(controller.genAiCourses),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
      ),
      title: Text(
        'Data Science Courses',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: Divider(height: 1.h, color: Colors.grey.shade200),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // HERO BANNER
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildHeroBanner() {
    return Stack(
      children: [
        Image.asset(
          'assets/images/data_science_bg.png',
          width: double.infinity,
          height: 480.h,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            height: 480.h,
            color: const Color(0xFF0D0D1A),
          ),
        ),
        Container(
          height: 480.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xDD0D0D1A),
                Color(0xCC111122),
                Color(0xBB16213E),
              ],
            ),
          ),
        ),
        Positioned(
          right: -20.w,
          top: 30.h,
          child: SizedBox(
            width: 200.w,
            height: 200.h,
            child: CustomPaint(painter: _ArcPainter()),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 36.h, 20.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Science Courses',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 22.h),
              _bullet('Data Science courses that help you turn data into real-world insights'),
              SizedBox(height: 14.h),
              _bullet('Learn statistics, machine learning and data-driven decision-making'),
              SizedBox(height: 14.h),
              _bullet('Earn a certificate in data science course with GenAI curriculum'),
              SizedBox(height: 14.h),
              _bullet('Learn from top faculty at IIIT Bangalore and LJMU'),
              SizedBox(height: 28.h),
              _buildStatsBox(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2.h),
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white54, width: 1.5),
          ),
          child: Center(child: Icon(Icons.check, color: Colors.white, size: 11.sp)),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(text,
              style: TextStyle(color: Colors.white, fontSize: 14.sp, height: 1.45)),
        ),
      ],
    );
  }

  Widget _buildStatsBox() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _stat('Learner count', '20K+'),
          Container(height: 36.h, width: 1, color: Colors.white24),
          _stat('Avg. pay hike', '64%'),
          Container(height: 36.h, width: 1, color: Colors.white24),
          _stat('Top pay hike', '500%'),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white60, fontSize: 10.sp)),
        SizedBox(height: 4.h),
        Text(value,
            style: TextStyle(
                color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w800)),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // THANK YOU CARD
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildThankYouCard() {
    return Container(
      color: const Color(0xFF0D0D1A),
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thank you!',
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                  SizedBox(height: 6.h),
                  Text(
                    'Our career expert will get in touch with\nyou shortly',
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54, height: 1.5),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Image.asset(
                  'assets/images/person_laptop.png',
                  height: 100.h,
                  width: 150.w,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => SizedBox(
                    width: 150.w,
                    height: 100.h,
                    child: CustomPaint(painter: _PersonPainter()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // PAID COURSES — 2-column GRID
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildCoursesSection(List<CourseModel> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(18.w, 24.h, 18.w, 10.h),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Data Science Course\n',
                  style: TextStyle(
                      color:  AppColors.black,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.3),
                ),
                TextSpan(
                  text: 'From Top Universities',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1.h, color: Colors.grey.shade200),
        SizedBox(height: 14.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Data Science Courses ',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: '(9)',
                      style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tune, size: 15.sp, color: Colors.black87),
                    SizedBox(width: 5.w),
                    Text('Filter',
                        style: TextStyle(fontSize: 13.sp, color: Colors.black87)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: courses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.60,
            ),
            itemBuilder: (_, i) => _buildCourseCard(courses[i]),
          ),
        ),
        SizedBox(height: 28.h),
      ],
    );
  }

  Widget _buildStartLearningSection(List<FreeCourseModel> freeCourses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 6.h),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Start Learning ',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800),
                ),
                TextSpan(
                  text: 'For Free',
                  style: TextStyle(
                      color:  AppColors.black,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Text(
            'Begin your journey with our free courses, a perfect starting point before the full data science programs.',
            style: TextStyle(fontSize: 13.sp, color: Colors.black54, height: 1.5),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 310.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            itemCount: freeCourses.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (_, i) => _buildFreeCourseCard(freeCourses[i]),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildFreeCourseCard(FreeCourseModel course) {
  return Container(
    width: 160.w,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Image + FREE CERTIFICATE banner ──
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                topRight: Radius.circular(14.r),
              ),
              child: Image.asset(
                course.imageAsset,
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.r),
                      topRight: Radius.circular(14.r),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.code,
                      size: 36.sp,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),

            // Green FREE CERTIFICATE badge
            Positioned(
              top: 12.h,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6.r),
                    bottomRight: Radius.circular(6.r),
                  ),
                ),
                child: Text(
                  'FREE CERTIFICATE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),

        // ── Info ──
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                course.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 12.sp,
                    color: Colors.black45,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    course.duration,
                    style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Spacer(),

        // ── Enroll for Free button ──
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
          child: SizedBox(
            width: double.infinity,
            height: 34.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor:  AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'Enroll for Free',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildViewAllButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
            elevation: 0,
          ),
          child: Text(
            'View All Data Science Free Courses',
            style: TextStyle(
                fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildGenerativeAISection(List<GenAiCourseModel> genAiCourses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(18.w, 28.h, 18.w, 6.h),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Master Generative AI\nwith ',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.3),
                ),
                TextSpan(
                  text: 'Microsoft',
                  style: TextStyle(
                      color:  AppColors.black,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 360.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            itemCount: genAiCourses.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (_, i) => _buildGenAiCard(genAiCourses[i]),
          ),
        ),
        SizedBox(height: 28.h),
      ],
    );
  }

  Widget _buildGenAiCard(GenAiCourseModel course) {
  return Container(
    width: 178.w,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Thumbnail + Bestseller ──
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                topRight: Radius.circular(14.r),
              ),
              child: Image.asset(
                course.imageAsset,
                height: 110.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 110.h,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: Icon(
                      Icons.smart_toy_outlined,
                      size: 36.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ),
            if (course.isBestseller)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A148C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Bestseller',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),

        // ── Info ──
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.provider,
                style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade500),
              ),
              SizedBox(height: 3.h),
              Text(
                course.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 8.h),

              // Blue highlight chip
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F0FF),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  course.highlight,
                  style: TextStyle(
                    color: const Color(0xFF1A73E8),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Divider(height: 1.h, color: Colors.grey.shade200),
              SizedBox(height: 7.h),

              // Credential type
              Row(
                children: [
                  Icon(Icons.workspace_premium_outlined,
                      size: 13.sp, color: Colors.black45),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      course.credentialType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),

              // Duration
              Row(
                children: [
                  Icon(Icons.calendar_month_outlined,
                      size: 13.sp, color: Colors.black45),
                  SizedBox(width: 4.w),
                  Text(
                    course.duration,
                    style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Spacer(),

        // ── Buttons ──
        Padding(
          padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 10.h),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 32.h,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.delete<DetailsController>();
                        // Get.toNamed(Routes.detailsScreen, arguments: course.title);
                        Get.toNamed(Routes.detailsScreen, arguments: {'title': course.title});
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    child: Text(
                      'View Program',
                      style: TextStyle(fontSize: 9.sp, color: Colors.black87),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              SizedBox(
                height: 32.h,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  AppColors.black,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Syllabus',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildCourseCard(CourseModel course) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 6.h),
                child: Container(
                  height: 56.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Image.asset(
                      course.logoAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(Icons.school_outlined,
                            size: 26.sp, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
              ),
              if (course.isBestseller)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A148C),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        bottomRight: Radius.circular(8.r),
                      ),
                    ),
                    child: Text('Bestseller',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course.institution,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 9.sp, color: Colors.grey.shade500)),
                SizedBox(height: 3.h),
                Text(course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.3)),
                SizedBox(height: 7.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
                  decoration: BoxDecoration(
                      color: course.badgeColor,
                      borderRadius: BorderRadius.circular(4.r)),
                  child: Text(course.badge,
                      style: TextStyle(
                          color: course.badgeTextColor,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500)),
                ),
                SizedBox(height: 8.h),
                Divider(height: 1.h, color: Colors.grey.shade200),
                SizedBox(height: 7.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.workspace_premium_outlined,
                        size: 13.sp, color: Colors.black45),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(course.credentialType,
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black54,
                              height: 1.3)),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined,
                        size: 13.sp, color: Colors.black45),
                    SizedBox(width: 4.w),
                    Text(course.duration,
                        style:
                            TextStyle(fontSize: 10.sp, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 10.h),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 32.h,
                    child: OutlinedButton(
                      onPressed: () {
                          Get.delete<DetailsController>();
                        // Get.toNamed(Routes.detailsScreen, arguments: course.title);
                        Get.toNamed(Routes.detailsScreen, arguments: {'title': course.title});
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r)),
                      ),
                      child: Text('View Program',
                          style:
                              TextStyle(fontSize: 9.sp, color: Colors.black87)),
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                SizedBox(
                  height: 32.h,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  AppColors.black,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r)),
                      elevation: 0,
                    ),
                    child: Text('Syllabus',
                        style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAINTERS
// ─────────────────────────────────────────────────────────────────────────────

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 6; i++) {
      paint.color = const Color(0xFF26C6DA).withOpacity(0.18 - i * 0.025);
      final radius = size.width * (0.28 + i * 0.13);
      canvas.drawCircle(
          Offset(size.width, size.height * 0.3), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _PersonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = const Color(0xFFBDBDBD);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.08, size.height * 0.70,
                size.width * 0.82, size.height * 0.08),
            const Radius.circular(4)),
        p);
    p.color = const Color(0xFF9E9E9E);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.14, size.height * 0.40,
                size.width * 0.70, size.height * 0.31),
            const Radius.circular(5)),
        p);
    p.color = const Color(0xFFEEEEEE);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.18, size.height * 0.43,
                size.width * 0.62, size.height * 0.24),
            const Radius.circular(3)),
        p);
    p.color = const Color(0xFFF48C72);
    canvas.drawOval(
        Rect.fromLTWH(size.width * 0.15, size.height * 0.50,
            size.width * 0.68, size.height * 0.26),
        p);
    p.color = const Color(0xFFFFCCBC);
    canvas.drawOval(
        Rect.fromLTWH(size.width * 0.33, size.height * 0.08,
            size.width * 0.33, size.height * 0.30),
        p);
    p.color = const Color(0xFF3E2723);
    final hair = Path()
      ..moveTo(size.width * 0.33, size.height * 0.21)
      ..quadraticBezierTo(size.width * 0.27, size.height * 0.03,
          size.width * 0.50, size.height * 0.05)
      ..quadraticBezierTo(size.width * 0.73, size.height * 0.03,
          size.width * 0.67, size.height * 0.21)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.35,
          size.width * 0.70, size.height * 0.40)
      ..lineTo(size.width * 0.33, size.height * 0.21)
      ..close();
    canvas.drawPath(hair, p);
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(size.width * 0.50, size.height * 0.26),
          width: size.width * 0.12,
          height: size.height * 0.06),
      0,
      3.14,
      false,
      Paint()
        ..color = const Color(0xFFBF360C)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}