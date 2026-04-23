import 'package:beecode/screens/home/controller/details_controller.dart';
import 'package:beecode/screens/promotion/controller/promotion_controller.dart';
import 'package:beecode/screens/promotion/model/promotion_model.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PromotionController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0.5,
                pinned: true,
                toolbarHeight: 56.h,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Get.back(),
                ),
                title: Obx(() => Text(
                      c.selectedGoal.value,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroBanner(),
                    SizedBox(height: 16.h),
                    _FeaturesRow(),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DISCOVER COURSES TO HELP YOU GET A PROMOTION",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54,
                              letterSpacing: 0.4,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                              children: const [
                                TextSpan(text: "Find the "),
                                TextSpan(
                                  text: "right course for your\ngoals.",
                                  style: TextStyle(color: AppColors.prime),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Obx(() {
                      final courses = c.filteredCourses;
                      if (courses.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(40.r),
                          child: Center(
                            child: Text(
                              "No courses match your filters.",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 14.sp),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: courses
                            .map((course) => _CourseCard(course: course))
                            .toList(),
                      );
                    }),
                    SizedBox(height: 72.h),
                  ],
                ),
              ),
            ],
          ),
          Obx(() => c.showSortSheet.value
              ? _BottomOverlay(onTap: () => c.showSortSheet.value = false)
              : const SizedBox.shrink()),
          Obx(() => AnimatedSlide(
                offset: c.showSortSheet.value
                    ? Offset.zero
                    : const Offset(0, 1),
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _SortSheet(controller: c),
                ),
              )),
          Obx(() => c.showFilterSheet.value
              ? _BottomOverlay(onTap: () => c.showFilterSheet.value = false)
              : const SizedBox.shrink()),
          Obx(() => AnimatedSlide(
                offset: c.showFilterSheet.value
                    ? Offset.zero
                    : const Offset(0, 1),
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _FilterSheet(controller: c),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: _BottomBar(controller: c),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(16.r),
      ),
      height: 260.h,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: const LinearGradient(
                colors: [Color(0xFFE0E0E0), Color(0xFFF5F5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 120.w,
              height: 160.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.person, size: 80.sp, color: Colors.grey),
            ),
          ),
          Positioned(
            top: 20.h,
            left: 16.w,
            child: const _StatCard(label: "No. of promotion", value: "7,174"),
          ),
          Positioned(
            top: 90.h,
            right: 16.w,
            child: const _StatCard(label: "Avg. salary hike", value: "39%"),
          ),
          Positioned(
            bottom: 24.h,
            left: 16.w,
            child: const _StatCard(
                label: "Career transitions", value: "27,132"),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 11.sp, color: Colors.black54)),
          SizedBox(height: 2.h),
          Text(value,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black)),
        ],
      ),
    );
  }
}

// ── Replace the existing _FeaturesRow build() body with this ──

class _FeaturesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black),
                    children: const [
                      TextSpan(text: "Get a Promotion with\n"),
                      TextSpan(
                        text: "Career-Boosting Courses",
                        style: TextStyle(color: AppColors.prime),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Stay ahead in your career by mastering the skills that matter. "
                  "Gain industry-recognised expertise and step up to leadership roles.",
                  style: TextStyle(
                      fontSize: 13.sp, color: Colors.black54, height: 1.5),
                ),
                SizedBox(height: 12.h),
                ...[
                  "Learn from top global faculty & industry leaders",
                  "Get real-world case studies & hands-on projects",
                  "Boost your career with certifications from top universities",
                  "Join a powerful alumni network for career growth",
                ].map((item) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline,
                              color:  AppColors.prime, size: 20.sp),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(item,
                                style: TextStyle(
                                    fontSize: 13.5.sp,
                                    color: Colors.black87,
                                    height: 1.4)),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 16.h),

                // ── NEW: Explore Courses button ──
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  AppColors.prime,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      elevation: 0,
                    ),
                    child: Text(
                      "Explore Courses",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                SizedBox(height: 14.h),

                // ── NEW: Enquiry call row ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone_outlined,
                        size: 15.sp, color: Colors.black54),
                    SizedBox(width: 6.w),
                    Text(
                      "For enquiries call: ",
                      style:
                          TextStyle(fontSize: 13.sp, color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
                        // launch tel:18002102020
                      },
                      child: Text(
                        "1800 210 2020",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color:  AppColors.prime,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: Row(
              children: [
                _FeatureIcon(
                    icon: Icons.location_on, label: "On-campus\nimmersion"),
                _VerticalDivider(),
                _FeatureIcon(
                    icon: Icons.work_outline, label: "Exclusive\nJob Portal"),
                _VerticalDivider(),
                _FeatureIcon(
                    icon: Icons.currency_rupee,
                    label: "EMI Options\nAvailable"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: const BoxDecoration(
              color: Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color:  AppColors.prime, size: 22.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11.5.sp, color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1.w, height: 60.h, color: Colors.grey.shade200);
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  const _CourseCard({required this.course});

  static const _red = AppColors.prime;

  Color _logoColor(String logo) {
    const map = {
      'iiitb': Color(0xFF1565C0),
      'iimk': Color(0xFF4A148C),
      'iitm': Color(0xFFB71C1C),
      'lbs': Color(0xFF1B5E20),
      'msu': Color(0xFF004B8D),
      'deakin': Color(0xFF006747),
    };
    return map[logo] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: _logoColor(course.universityLogo).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                      color:
                          _logoColor(course.universityLogo).withOpacity(0.2)),
                ),
                child: Center(
                  child: Text(
                    course.universityLogo.toUpperCase(),
                    style: TextStyle(
                      color: _logoColor(course.universityLogo),
                      fontWeight: FontWeight.w900,
                      fontSize: 13.sp,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  course.category,
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(course.university,
              style: TextStyle(fontSize: 12.5.sp, color: Colors.black54)),
          SizedBox(height: 4.h),
          Text(
            course.title,
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                height: 1.3),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              course.badge,
              style: TextStyle(
                  fontSize: 11.5.sp,
                  color: const Color(0xFF1565C0),
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.laptop_mac_outlined, size: 15.sp, color: Colors.black45),
              SizedBox(width: 5.w),
              Text(course.programLevel,
                  style: TextStyle(fontSize: 12.5.sp, color: Colors.black54)),
              SizedBox(width: 14.w),
              Icon(Icons.calendar_today_outlined,
                  size: 14.sp, color: Colors.black45),
              SizedBox(width: 5.w),
              Text(course.duration,
                  style: TextStyle(fontSize: 12.5.sp, color: Colors.black54)),
            ],
          ),
          SizedBox(height: 14.h),
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
                    side: const BorderSide(color: Colors.black87, width: 1.2),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text("View Program",
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.download_outlined, size: 16.sp),
                  label: Text("Syllabus",
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final PromotionController controller;
  const _BottomBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () {
                controller.showFilterSheet.value = false;
                controller.showSortSheet.value = true;
              },
              icon: Icon(Icons.swap_vert,
                  color:  AppColors.prime, size: 20.sp),
              label: Text("Sort",
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp)),
            ),
          ),
          Container(width: 1.w, height: 32.h, color: Colors.grey.shade300),
          Expanded(
            child: Obx(() => TextButton.icon(
                  onPressed: () {
                    controller.showSortSheet.value = false;
                    controller.showFilterSheet.value = true;
                  },
                  icon: Icon(Icons.tune,
                      color:  AppColors.prime, size: 20.sp),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Filter",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp)),
                      if (controller.activeFilterCount > 0) ...[
                        SizedBox(width: 4.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color:  AppColors.prime,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            "${controller.activeFilterCount}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class _BottomOverlay extends StatelessWidget {
  final VoidCallback onTap;
  const _BottomOverlay({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(color: Colors.black.withOpacity(0.4)),
    );
  }
}

class _SortSheet extends StatelessWidget {
  final PromotionController controller;
  const _SortSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sort by",
                  style: TextStyle(
                      fontSize: 18.sp, fontWeight: FontWeight.w700)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => controller.showSortSheet.value = false,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Obx(() => Column(
                children: controller.sortOptions
                    .map((opt) => RadioListTile<String>(
                          title: Text(opt,
                              style: TextStyle(fontSize: 15.sp)),
                          value: opt,
                          groupValue: controller.selectedSort.value,
                          activeColor:  AppColors.prime,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (v) {
                            if (v != null) {
                              controller.selectSort(v);
                              controller.showSortSheet.value = false;
                            }
                          },
                        ))
                    .toList(),
              )),
        ],
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  final PromotionController controller;
  const _FilterSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return Container(
      height: screenH * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 8.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Filter",
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.w700)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => controller.showFilterSheet.value = false,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Obx(() => Row(
                  children: [
                    Container(
                      width: 130.w,
                      color: const Color(0xFFF5F5F5),
                      child: ListView(
                        children: controller.filterTabs.map((tab) {
                          final selected =
                              controller.selectedFilterTab.value == tab;
                          final count = controller.countForTab(tab);
                          return GestureDetector(
                            onTap: () =>
                                controller.selectedFilterTab.value = tab,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14.h, horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white
                                    : Colors.transparent,
                                border: selected
                                    ? const Border(
                                        left: BorderSide(
                                            color: AppColors.prime,
                                            width: 3))
                                    : null,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                  children: [
                                    TextSpan(text: tab),
                                    if (count > 0)
                                      TextSpan(
                                        text: " ($count)",
                                        style: const TextStyle(
                                            color: AppColors.prime,
                                            fontWeight: FontWeight.w700),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        children: controller
                            .optionsForTab(
                                controller.selectedFilterTab.value)
                            .map((opt) {
                          final checked = controller.isOptionSelected(
                              controller.selectedFilterTab.value, opt);
                          return CheckboxListTile(
                            title: Text(opt,
                                style: TextStyle(fontSize: 13.5.sp)),
                            value: checked,
                            activeColor:  AppColors.prime,
                            checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r)),
                            controlAffinity:
                                ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w),
                            dense: true,
                            onChanged: (_) => controller.toggleOption(
                                controller.selectedFilterTab.value, opt),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.clearAllFilters();
                      controller.showFilterSheet.value = false;
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black26),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: Text("Clear All",
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () =>
                        controller.showFilterSheet.value = false,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  AppColors.prime,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      elevation: 0,
                    ),
                    child: Text("Apply Filter",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w600)),
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