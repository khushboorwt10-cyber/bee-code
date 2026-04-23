import 'package:beecode/screens/doctorate/controller/doctorate_courses_controller.dart';
import 'package:beecode/screens/doctorate/model/doctorate_courses_model.dart';
import 'package:beecode/screens/home/controller/details_controller.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DoctorateScreen extends GetView<DoctorateController> {
  const DoctorateScreen({super.key});

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

                leading: GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.arrow_back_ios, size: 20.sp, color: const Color(0xFF1A1A1A)),
                ),
                title: Text(
                  'Doctorate Courses',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),

      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeroBannerSection(),
                    SizedBox(height: 8.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Online DBA Course ',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                color:  AppColors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'from Top\nUniversities',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const _CourseFilterRow(),
                    SizedBox(height: 4.h),

                    const _CareerBannerWidget(),
                    SizedBox(height: 4.h),

                    const _CourseListSection(),
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HERO BANNER SECTION
// ─────────────────────────────────────────────

class _HeroBannerSection extends StatelessWidget {
  const _HeroBannerSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D1B2A),
            Color(0xFF1A2740),
            Color(0xFF0D2137),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.18,
              child: Container(
                width: 170.w,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.white24],
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Doctor of Business\nAdministration (DBA)',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFFFFFF),
                    height: 1.2,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 22.h),
                ..._featurePoints(),
                SizedBox(height: 22.h),
                const _StatsRow(),
                SizedBox(height: 22.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  AppColors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text(
                      'Explore Courses',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFFFFF),
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

  List<Widget> _featurePoints() {
    final points = [
      'DBA Course: A Ph.D. equivalent for leaders to showcase expertise',
      'Earn a "Dr." Title with Doctor of Business Administration (DBA Course)',
      'Pilot, prototype, and monetize innovative ideas during your DBA journey',
      'Become a boardroom consultant with PwC certification',
    ];
    return points.map((p) => _FeaturePoint(text: p)).toList();
  }
}

class _FeaturePoint extends StatelessWidget {
  final String text;
  const _FeaturePoint({required this.text});

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
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 1.5),
            ),
            child: Icon(Icons.check, color: Colors.white70, size: 12.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFFFFFFFF).withOpacity(0.88),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          _StatItem(value: '50+',   label: 'Successful...'),
          _StatDivider(),
          _StatItem(value: '5K+',   label: 'Doctoral...'),
          _StatDivider(),
          _StatItem(value: '2500+', label: 'Global CXOs'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.white54)),
          SizedBox(height: 4.h),
          Text(value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFFFFFFF),
              )),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(height: 36.h, width: 1, color: Colors.white24);
}

class _CourseFilterRow extends StatelessWidget {
  const _CourseFilterRow();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorateController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
            'Doctorate Courses (${controller.filteredCourses.length})',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          )),
          GestureDetector(
            onTap: _showFilterBottomSheet,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Icon(Icons.tune, size: 16.sp, color: const Color(0xFF1A1A1A)),
                  SizedBox(width: 6.w),
                  Text('Filter',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CareerBannerWidget extends StatelessWidget {
  const _CareerBannerWidget();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorateController>();
    return Obx(() {
      if (!controller.showCareerBanner.value) return const SizedBox.shrink();
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Want to know more about 1000+ career transitions?',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Get an exclusive career transition handbook',
                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Download Now →',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color:  AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: controller.dismissCareerBanner,
              child: Icon(Icons.close, size: 18.sp, color: const Color(0xFF6B7280)),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
// COURSE LIST
// ─────────────────────────────────────────────

class _CourseListSection extends StatelessWidget {
  const _CourseListSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorateController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: CircularProgressIndicator(
              color:  AppColors.black,
              strokeWidth: 2.5,
            ),
          ),
        );
      }

      final courses = controller.filteredCourses;
      if (courses.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: Column(
              children: [
                Icon(Icons.search_off, size: 48.sp, color: const Color(0xFF6B7280)),
                SizedBox(height: 12.h),
                Text('No courses found',
                    style: TextStyle(fontSize: 16.sp, color: const Color(0xFF6B7280))),
              ],
            ),
          ),
        );
      }

      return Column(
        children: courses.map((c) => _CourseCardWidget(course: c)).toList(),
      );
    });
  }
}

class _CourseCardWidget extends StatelessWidget {
  final DoctorateModel course;
  const _CourseCardWidget({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: Center(
                  child: _UniversityLogoWidget(logoAsset: course.logoAsset),
                ),
              ),
              if (course.isPopular)
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4891A),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text('Popular',
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course.universityName,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 6.h),
                Text(course.programTitle,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                      height: 1.3,
                    )),
                SizedBox(height: 10.h),

                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: course.tags.map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF4FF),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(tag,
                          style: TextStyle(
                            color: const Color(0xFF1D4ED8),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          )),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12.h),

                Row(
                  children: [
                    _meta(Icons.school_outlined, course.level),
                    SizedBox(width: 16.w),
                    _meta(Icons.calendar_today_outlined, course.duration),
                  ],
                ),
                SizedBox(height: 16.h),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.delete<DetailsController>();
                      //  Get.toNamed(Routes.detailsScreen, arguments: course.programTitle);
Get.toNamed(Routes.detailsScreen, arguments: {'title': course.programTitle});
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                        ),
                        child: Text('View Program',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            )),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.download_rounded,
                            size: 16.sp, color: const Color(0xFFFFFFFF)),
                        label: Text('Syllabus',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFFFFFF),
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  AppColors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 13.h),
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

  Widget _meta(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15.sp, color: const Color(0xFF6B7280)),
        SizedBox(width: 5.w),
        Text(text,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }
}

class _UniversityLogoWidget extends StatelessWidget {
  final String logoAsset;
  const _UniversityLogoWidget({required this.logoAsset});

  @override
  Widget build(BuildContext context) {
    switch (logoAsset) {
      case 'ssbm': return const _SSBMLogo();
      case 'ggu':  return const _GGULogo();
      default:
        return Container(
          width: 80.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(logoAsset.toUpperCase(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6B7280),
                )),
          ),
        );
    }
  }
}

class _SSBMLogo extends StatelessWidget {
  const _SSBMLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: const Color(0xFFCC0000),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Icon(Icons.add, color: const Color(0xFFFFFFFF), size: 18.sp),
              ),
            ),
            SizedBox(width: 6.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'S',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFCC0000),
                          letterSpacing: 1,
                        ),
                      ),
                      TextSpan(
                        text: 'SBM',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1A1A1A),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Text('GENEVA',
                    style: TextStyle(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                      letterSpacing: 3,
                    )),
              ],
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text('Swiss School of Business',
            style: TextStyle(
                fontSize: 9.sp,
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w500)),
        Text('& Management, Geneva.',
            style: TextStyle(
                fontSize: 9.sp,
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _GGULogo extends StatelessWidget {
  const _GGULogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: const Color(0xFF1A3D6B),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: Icon(Icons.account_balance,
                color: const Color(0xFFFFFFFF), size: 28.sp),
          ),
        ),
        SizedBox(height: 8.h),
        Text('GOLDEN GATE',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A3D6B),
              letterSpacing: 2,
            )),
        Text('UNIVERSITY',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1A3D6B),
              letterSpacing: 4,
            )),
        Divider(
            color: const Color(0xFF1A3D6B),
            thickness: 1,
            indent: 8.w,
            endIndent: 8.w),
        Text('SAN FRANCISCO',
            style: TextStyle(
                fontSize: 9.sp,
                color: const Color(0xFF1A3D6B),
                letterSpacing: 2)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// FILTER BOTTOM SHEET
// ─────────────────────────────────────────────

void _showFilterBottomSheet() {
  Get.bottomSheet(
    const _FilterBottomSheet(),
    backgroundColor: const Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    isScrollControlled: true,
  );
}

class _FilterBottomSheet extends StatelessWidget {
  const _FilterBottomSheet();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorateController>();
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text('Filter Courses',
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A))),
          SizedBox(height: 16.h),
          Text('Duration',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A))),
          SizedBox(height: 12.h),
          Obx(() => Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: controller.filterOptions.map((f) {
              final selected = controller.selectedFilter.value == f;
              return GestureDetector(
                onTap: () {
                  controller.setFilter(f);
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: selected
                        ?  AppColors.black
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: selected
                          ?  AppColors.black
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Text(f,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF1A1A1A),
                      )),
                ),
              );
            }).toList(),
          )),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
