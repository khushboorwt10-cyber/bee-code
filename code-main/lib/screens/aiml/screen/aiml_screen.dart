import 'package:beecode/screens/aiml/controller/aiml_controller.dart';
import 'package:beecode/screens/aiml/model/aiml_model.dart';
import 'package:beecode/screens/home/controller/details_controller.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AiCoursesScreen extends GetView<AiCoursesController> {
  const AiCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero Banner ──
                const _HeroBanner(),
                SizedBox(height: 24.h),

                // ── Section Heading ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Artificial Intelligence Course ',
                          style: TextStyle(
                            color:  AppColors.black,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'From\nTop Universities',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),
                Divider(color: Colors.grey.shade200, height: 1.h),
                SizedBox(height: 14.h),

                // ── Filter Row ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Artificial Intelligence Courses ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: '(11)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.onFilterTap,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.tune,
                                  size: 15.sp, color: Colors.black87),
                              SizedBox(width: 5.w),
                              Text(
                                'Filter',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // ── Course List ──
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: controller.courses.length,
                  separatorBuilder: (_, _) => SizedBox(height: 12.h),
                  itemBuilder: (_, i) =>
                      _CourseCard(course: controller.courses[i]),
                ),

                SizedBox(height: 100.h),
              ],
            ),
          ),

          // ── FAB overlay ──
         
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Icon(Icons.arrow_back, color: Colors.black, size: 22.sp),
      title: Text(
        'Artificial Intelligence Courses',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: Divider(height: 1.h, color: Colors.grey.shade200),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HERO BANNER
// ─────────────────────────────────────────────

class _HeroBanner extends GetView<AiCoursesController> {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF090918), Color(0xFF0D1B2A), Color(0xFF0A1628)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _CircuitPainter()),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 28.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Artificial Intelligence - AI\nCourses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 20.h),

                // Feature list from controller
                ...controller.heroFeatures
                    .map((f) => _FeatureItem(text: f['text']!)),

                SizedBox(height: 24.h),
                const _StatsRow(),
                SizedBox(height: 24.h),

                // Explore button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.onExploreCourses,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  AppColors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Explore Courses',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
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
}

// ─────────────────────────────────────────────
// FEATURE ITEM
// ─────────────────────────────────────────────

class _FeatureItem extends StatelessWidget {
  final String text;
  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white54, width: 1.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: Colors.white, size: 12.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STATS ROW
// ─────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: const IntrinsicHeight(
        child: Row(
          children: [
            _StatItem(label: 'Learner count', value: '6K+'),
            _StatDivider(),
            _StatItem(label: 'Avg. pay hike', value: '64%'),
            _StatDivider(),
            _StatItem(label: 'Top pay hike', value: '500%'),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white60, fontSize: 11.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      color: Colors.white24,
    );
  }
}

// ─────────────────────────────────────────────
// COURSE CARD — typed with AiModel
// ─────────────────────────────────────────────

class _CourseCard extends GetView<AiCoursesController> {
  final AiModel course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo + Badge ──
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 110.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12.r)),
                ),
                child: Center(
                  child: _UniversityLogo(name: course.university),
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: course.badgeColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    course.badge,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Card Body ──
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // University
                Text(
                  course.university,
                  style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
                ),
                SizedBox(height: 6.h),

                // Title
                Text(
                  course.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 10.h),

                // Features
                ...course.features.map((f) => _FeatureTag(label: f)),
                SizedBox(height: 14.h),

                // ── Action Buttons ──
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.delete<DetailsController>();
                      // Get.toNamed(Routes.detailsScreen, arguments: course.title);
                      Get.toNamed(Routes.detailsScreen, arguments: {'title': course.title});
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'View Program',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.download_outlined,
                            size: 15.sp, color: Colors.white),
                        label: Text(
                          'Syllabus',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  AppColors.black,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
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

// ─────────────────────────────────────────────
// FEATURE TAG
// ─────────────────────────────────────────────

class _FeatureTag extends StatelessWidget {
  final String label;
  const _FeatureTag({required this.label});

  @override
  Widget build(BuildContext context) {
    final icon = label.toLowerCase().contains('certif')
        ? Icons.card_membership_outlined
        : Icons.star_outline;
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(icon, size: 15.sp, color: Colors.grey.shade600),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// UNIVERSITY LOGO
// ─────────────────────────────────────────────

class _UniversityLogo extends StatelessWidget {
  final String name;
  const _UniversityLogo({required this.name});

  String get _short {
    if (name.contains('IIM')) return 'iim';
    if (name.contains('IIT R')) return 'iit-r';
    if (name.contains('IIT B')) return 'iit-b';
    return 'iiit-b';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomPaint(
              size: Size(28.w, 28.w),
              painter: _GridPainter(),
            ),
            SizedBox(width: 4.w),
            Text(
              _short,
              style: TextStyle(
                color: const Color(0xFF1A3C7A),
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Text(
          'ज्ञानमुत्तमम्',
          style: TextStyle(color: const Color(0xFF1A3C7A), fontSize: 9.sp),
        ),
      ],
    );
  }
}

class _CircuitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final x = size.width * (i / 8);
      canvas.drawLine(Offset(x, 0), Offset(x + 40, size.height), p);
    }
    for (int i = 0; i < 6; i++) {
      final y = size.height * (i / 6);
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 20), p);
    }

    final dot = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 8; j++) {
        canvas.drawCircle(
          Offset(size.width * (i / 4), size.height * (j / 7)),
          2.0,
          dot,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF607D8B)
      ..style = PaintingStyle.fill;
    final cell = (size.width - 4) / 3;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(c * (cell + 2), r * (cell + 2), cell, cell),
            const Radius.circular(2),
          ),
          p,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}