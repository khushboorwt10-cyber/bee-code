import 'package:beecode/screens/call/controller/call_controller.dart';
import 'package:beecode/screens/call/screen/call_screen.dart';
import 'package:beecode/screens/home/controller/details_controller.dart';
import 'package:beecode/screens/home/controller/home_controller.dart';
import 'package:beecode/screens/home/model/home_model.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/images.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:beecode/screens/utils/shimmer.dart';
import 'package:beecode/widget/profile_icon.dart';
import 'package:beecode/widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Obx(() {
              final loading = controller.isLoading.value;
              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    loading ? _carouselShimmer() : _carousel(),
                    SizedBox(height: 20.h),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20.0),
                    //   child: Text(
                    //     "TRENDING COURSES",
                    //     style: TextStyle(
                    //       fontSize: 14.sp,
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 16.h),
                    // loading
                    //     ? _horizontalCardShimmer(
                    //         height: 310.h,
                    //         cardWidth: 300.w,
                    //       )
                    //     : _trendingCoursesListFromApi(),
                    // SizedBox(height: 20.h),
                    // Replace the existing "EXPLORE BY DOMAIN" section with:
// Padding(
//   padding: const EdgeInsets.only(left: 20.0),
//   child: Text(
//     "EXPLORE BY DOMAIN",
//     style: TextStyle(
//       fontSize: 14.sp,
//       color: Colors.grey,
//       fontWeight: FontWeight.w500,
//     ),
//   ),
// ),
// SizedBox(height: 5.h),
// Padding(
//   padding: const EdgeInsets.only(left: 20.0),
//   child: RichText(
//     text: TextSpan(
//       style: TextStyle(
//         fontSize: 18.sp,
//         color: Colors.black,
//         fontWeight: FontWeight.w700,
//       ),
//       children: [
//         const TextSpan(text: "Choose your "),
//         TextSpan(
//           text: "area of interest",
//           style: TextStyle(
//             color: AppColors.prime,
//             fontWeight: FontWeight.bold,
//             fontSize: 18.sp,
//           ),
//         ),
//       ],
//     ),
//   ),
// ),
// SizedBox(height: 20.h),
loading ? _courseGridShimmer() : _courseGrid(), // This now uses sections API
                    // SizedBox(height: 20.h),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20.0),
                    //   child: RichText(
                    //     text: TextSpan(
                    //       children: [
                    //         TextSpan(
                    //           text: "Master Generative AI and ",
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 22.sp,
                    //           ),
                    //         ),
                    //         TextSpan(
                    //           text: "get certified with Microsoft",
                    //           style: TextStyle(
                    //             color: AppColors.prime,
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 22.sp,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                   // SizedBox(height: 16.h),
                    // loading
                    //     ? _horizontalCardShimmer(
                    //         height: 310.h,
                    //         cardWidth: 300.w,
                    //       )
                    //     : _trendingCoursesListFromApi(),
                    // SizedBox(height: 30.h),
                    // loading
                    //     ? _sectionShimmer(cardHeight: 340.h, cardWidth: 280.w)
                    //     : _freeCoursesSect
                    SizedBox(height: 30.h),
                    loading
                        ? _sectionShimmer(cardHeight: 390.h, cardWidth: 320.w)
                        : _freeMasterclassesSection(),
                    SizedBox(height: 30.h),
                    loading
                        ? _testimonialShimmer()
                        : _learnerTestimonialsSection(),
                    SizedBox(height: 120.h),
                  ],
                ),
              );
            }),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _StickyHeader(
                controller: controller,
                scrollController: _scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _carouselShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ShimmerBox(width: double.infinity, height: 270.h, radius: 8),
    );
  }

  Widget _courseGridShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: GridView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (_, _) => ShimmerBox(
          width: double.infinity,
          height: double.infinity,
          radius: 14,
        ),
      ),
    );
  }

  Widget _horizontalCardShimmer({
    required double height,
    required double cardWidth,
  }) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 3,
        separatorBuilder: (_, _) => SizedBox(width: 14.w),
        itemBuilder: (_, _) =>
            ShimmerBox(width: cardWidth, height: height, radius: 16),
      ),
    );
  }

  Widget _sectionShimmer({
    required double cardHeight,
    required double cardWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ShimmerBox(width: 140.w, height: 14.h, radius: 4),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ShimmerBox(width: 220.w, height: 26.h, radius: 6),
        ),
        SizedBox(height: 20.h),
        _horizontalCardShimmer(height: cardHeight, cardWidth: cardWidth),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ShimmerBox(width: double.infinity, height: 52.h, radius: 30),
        ),
      ],
    );
  }

  Widget _testimonialShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ShimmerBox(width: 180.w, height: 14.h, radius: 4),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ShimmerBox(width: 240.w, height: 56.h, radius: 6),
        ),
        SizedBox(height: 20.h),
        _horizontalCardShimmer(height: 430.h, cardWidth: 300.w),
      ],
    );
  }

  Widget _carousel() {
    return Column(
      children: [
        SizedBox(
          height: 280.h,
          width: double.infinity,
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.carouselItems.length,
            itemBuilder: (context, index) {
              final realIndex = index % controller.carouselItems.length;
              final item = controller.carouselItems[realIndex];

              return ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
                child: item.imageUrl != null
                    ? Image.asset(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox(),
                      )
                    : const SizedBox(),
              );
            },
          ),
        ),
      ],
    );
  }
  Widget _courseGrid() {
    if (controller.sectionsWithCourses.isEmpty) {
      return const SizedBox();
    }

    // ✅ FILTER: only sections with courses
    final validSections = controller.sectionsWithCourses
        .where((s) => s.courses.isNotEmpty)
        .toList();

    if (validSections.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: validSections.map((sectionWithCourses) {
        final sectionCourses = sectionWithCourses.courses;

        debugPrint('📚 Section: ${sectionWithCourses.section.title}');
        debugPrint('📚 Courses count: ${sectionCourses.length}');
        debugPrint("SECTION TITLE: ${sectionWithCourses.section.title}");
        debugPrint("COURSES: ${sectionCourses.map((e) => e.title)}");

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                sectionWithCourses.section.title.isNotEmpty
                    ? sectionWithCourses.section.title
                    : sectionCourses.first.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            SizedBox(
              height: 400.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: sectionCourses.length,
                separatorBuilder: (_, _) => SizedBox(width: 14.w),
                itemBuilder: (context, index) {
                  return _trendingCourseCardFromData(
                    sectionCourses[index],
                  );
                },
              ),
            ),

            SizedBox(height: 24.h),
          ],
        );
      }).toList(),
    );
  }



Widget _trendingCoursesListFromApi() {
  debugPrint('🔍 Building trending courses list, count: ${controller.apiTrendingCourses.length}');

  if (controller.isLoading.value) {
    debugPrint('⏳ Still loading, showing shimmer');
    return _horizontalCardShimmer(height: 310.h, cardWidth: 300.w);
  }

  if (controller.apiTrendingCourses.isEmpty) {
    debugPrint('⚠️ No trending courses to display');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.trending_down,
                size: 48.sp,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 12.h),
              Text(
                'No trending courses available',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () => controller.refreshData(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  return SizedBox(
    height: 400.h,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: controller.apiTrendingCourses.length,
      separatorBuilder: (_, _) => SizedBox(width: 14.w),
      itemBuilder: (context, index) {
        final course = controller.apiTrendingCourses[index];
        debugPrint('🎨 Building card for: ${course.title}');
        return _trendingCourseCardFromData(course);
      },
    ),
  );
}
Widget _trendingCourseCardFromData(CourseData course) {
  return Container(
    width: 300.w,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: course.thumbnail.url.isNotEmpty
              ? Image.network(
                  course.thumbnail.url,
                  width: double.infinity,
                  height: 130.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.school_rounded,
                    color: Colors.grey.shade400,
                    size: 28,
                  ),
                )
              : Icon(
                  Icons.school_rounded,
                  color: Colors.grey.shade400,
                  size: 28,
                ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.instituteName,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                course.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Text(
                  course.level,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: 15,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: 5.w),
                  Flexible(
                    child: Text(
                      course.isFree ? "Free Course" : "Paid Course",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "${course.duration} Months",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Divider(color: Colors.grey.shade200, height: 1),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 5.h),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.toNamed(
                      Routes.detailsScreen,
                      arguments: {
                        "courseId": course.id.toString(),
                        "title": course.title.toString(),
                        "course": course,
                      },
                    );

                    debugPrint("course id: ${course.id}");
                    debugPrint("course title: ${course.title}");
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
                    ),
                  ),
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
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.r),
              bottomRight: Radius.circular(16.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
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
      ],
    ),
  );
}

  Widget _freeMasterclassesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "FREE MASTERCLASSES",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.3,
              ),
              children: const [
                TextSpan(text: "Attend "),
                TextSpan(
                  text: "free masterclasses",
                  style: TextStyle(color: AppColors.prime),
                ),
                TextSpan(text: " by industry experts"),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 400.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: controller.masterclasses.length,
            separatorBuilder: (_, _) => SizedBox(width: 14.w),
            itemBuilder: (context, index) =>
                _masterclassCard(controller.masterclasses[index]),
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "View All Masterclasses",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _masterclassCard(Map<String, dynamic> masterclass) {
    return Container(
      width: 340.w,
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
          _masterclassBanner(masterclass),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${masterclass["date"]} • ${masterclass["time"]}",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.prime,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  masterclass["title"],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.record_voice_over_outlined,
                            size: 22,
                            color: Colors.grey.shade700,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "By ${masterclass["speakerName"]}",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  masterclass["speakerRole"],
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _beeCodeLogo(),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          "View Masterclass",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          elevation: 0,
                        ),
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _masterclassBanner(Map<String, dynamic> masterclass) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Stack(
        children: [
          Image.network(
            masterclass["bannerImage"],
            height: 160.h,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 160.h,
              color: Colors.grey.shade200,
              child: Icon(
                Icons.image_outlined,
                color: Colors.grey.shade400,
                size: 40,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12.h,
            left: 12.w,
            child: Row(
              children: [
                _beeCodeLogo(dark: false),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.prime,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.open_in_new,
                        color: Colors.white,
                        size: 10,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "FREE MASTERCLASS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.h,
            left: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 12,
                    color: Colors.grey.shade700,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    masterclass["date"],
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.access_time_outlined,
                    size: 12,
                    color: Colors.grey.shade700,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    masterclass["time"],
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(double.infinity, 22.h),
              painter: _RedWavePainter(),
            ),
          ),
        ],
      ),
    );
  }
  Widget _beeCodeLogo({bool dark = true}) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        children: [
          TextSpan(
            text: "Bee",
            style: TextStyle(color: dark ? Colors.black : Colors.white),
          ),
          const TextSpan(
            text: "Code",
            style: TextStyle(color: AppColors.prime),
          ),
        ],
      ),
    );
  }
  Widget _learnerTestimonialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "LEARNER TESTIMONIALS",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.3,
              ),
              children: const [
                TextSpan(text: "Hear from "),
                TextSpan(
                  text: "our graduates first-hand",
                  style: TextStyle(color: AppColors.prime),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 450.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: controller.testimonials.length,
            separatorBuilder: (_, _) => SizedBox(width: 14.w),
            itemBuilder: (context, index) =>
                _testimonialCard(controller.testimonials[index]),
          ),
        ),
      ],
    );
  }

  Widget _testimonialCard(Map<String, dynamic> testimonial) {
    return Container(
      width: 300.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200, width: 1),
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
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: Stack(
              children: [
                Image.network(
                  testimonial["image"],
                  height: 260.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 260.h,
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.grey.shade400,
                      size: 50,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.45),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16.h,
                  left: 14.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 13.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Watch my story",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  testimonial["quote"],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  testimonial["name"],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  testimonial["role"],
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
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
class _StickyHeader extends StatefulWidget {
  final HomeController controller;
  final ScrollController scrollController;

  const _StickyHeader({
    required this.controller,
    required this.scrollController,
  });

  @override
  State<_StickyHeader> createState() => _StickyHeaderState();
}

class _StickyHeaderState extends State<_StickyHeader> {
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = widget.scrollController.offset > 10;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isScrolled
            ? Brightness.light
            : Brightness.light,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _isScrolled
              ? Colors.black.withOpacity(0.9)
              : Colors.transparent,
          boxShadow: _isScrolled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            AppImages.logoapp,
                            height: 30.h,
                            width: 80.w,
                          ),
                        ],
                      ),
                    ),
                    HeaderIconButton(
                      icon: Icons.call_outlined,
                      isHome: true,
                      onTap: () => showSupportSheet(),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => Get.toNamed("/profileScreen"),
                      child: HeaderIconButton(
                        icon: Icons.person_outline_rounded,
                        isHome: true,
                        onTap: () => Get.toNamed("/profileScreen"),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSearchBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RedWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.prime;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.4)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.1,
        size.width * 0.55,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height,
        size.width,
        size.height * 0.3,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// import 'package:beecode/screens/call/controller/call_controller.dart';
// import 'package:beecode/screens/call/screen/call_screen.dart';
// import 'package:beecode/screens/home/controller/details_controller.dart';
// import 'package:beecode/screens/home/controller/home_controller.dart';
// import 'package:beecode/screens/utils/colors.dart';
// import 'package:beecode/screens/utils/images.dart';
// import 'package:beecode/screens/utils/route.dart';
// import 'package:beecode/screens/utils/shimmer.dart';
// import 'package:beecode/widget/course_card_homescreen.dart';
// import 'package:beecode/widget/profile_icon.dart';
// import 'package:beecode/widget/search_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// class HomeScreen extends GetView<HomeController> {
//   HomeScreen({super.key});
//   final ScrollController _scrollController = ScrollController();
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         resizeToAvoidBottomInset: true,
//         body: Stack(
//           children: [
//             Obx(() {
//               final loading = controller.isLoading.value;
//               return SingleChildScrollView(
//                 controller: _scrollController,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     loading ? _carouselShimmer() : _carousel(),
//                     SizedBox(height: 20.h),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20.0),
//                       child: Text(
//                         "TRENDING COURSES",
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//                     loading
//                         ? _horizontalCardShimmer(
//                             height: 310.h,
//                             cardWidth: 300.w,
//                           )
//                         : _trendingCoursesList(),
//                     SizedBox(height: 20.h),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20.0),
//                       child: Text(
//                         "EXPLORE BY DOMAIN",
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 5.h),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20.0),
//                       child: RichText(
//                         text: TextSpan(
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w700,
//                           ),
//                           children: [
//                             const TextSpan(text: "Choose your "),
//                             TextSpan(
//                               text: "area of interest",
//                               style: TextStyle(
//                                 color: AppColors.prime,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18.sp,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20.h),
//                     loading ? _courseGridShimmer() : _courseGrid(),
//                     SizedBox(height: 20.h),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20.0),
//                       child: RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: "Master Generative AI and ",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 22.sp,
//                               ),
//                             ),
//                             TextSpan(
//                               text: "get certified with Microsoft",
//                               style: TextStyle(
//                                 color: AppColors.prime,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 22.sp,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//                     loading
//                         ? _horizontalCardShimmer(
//                             height: 310.h,
//                             cardWidth: 300.w,
//                           )
//                         : _trendingCoursesList(),
//                     SizedBox(height: 30.h),
//                     loading
//                         ? _sectionShimmer(cardHeight: 340.h, cardWidth: 280.w)
//                         : _freeCoursesSection(),
//                     SizedBox(height: 30.h),
//                     loading
//                         ? _sectionShimmer(cardHeight: 390.h, cardWidth: 320.w)
//                         : _freeMasterclassesSection(),
//                     SizedBox(height: 30.h),
//                     loading
//                         ? _testimonialShimmer()
//                         : _learnerTestimonialsSection(),
//                     SizedBox(height: 120.h),
//                   ],
//                 ),
//               );
//             }),
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: _StickyHeader(
//                 controller: controller,
//                 scrollController: _scrollController,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _carouselShimmer() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: ShimmerBox(width: double.infinity, height: 270.h, radius: 8),
//     );
//   }

//   Widget _courseGridShimmer() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//       child: GridView.builder(
//         itemCount: 4,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 12.w,
//           mainAxisSpacing: 12.h,
//           childAspectRatio: 1.3,
//         ),
//         itemBuilder: (_, _) => ShimmerBox(
//           width: double.infinity,
//           height: double.infinity,
//           radius: 14,
//         ),
//       ),
//     );
//   }

//   Widget _horizontalCardShimmer({
//     required double height,
//     required double cardWidth,
//   }) {
//     return SizedBox(
//       height: height,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         itemCount: 3,
//         separatorBuilder: (_, _) => SizedBox(width: 14.w),
//         itemBuilder: (_, _) =>
//             ShimmerBox(width: cardWidth, height: height, radius: 16),
//       ),
//     );
//   }

//   Widget _sectionShimmer({
//     required double cardHeight,
//     required double cardWidth,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: ShimmerBox(width: 140.w, height: 14.h, radius: 4),
//         ),
//         SizedBox(height: 10.h),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: ShimmerBox(width: 220.w, height: 26.h, radius: 6),
//         ),
//         SizedBox(height: 20.h),
//         _horizontalCardShimmer(height: cardHeight, cardWidth: cardWidth),
//         SizedBox(height: 20.h),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: ShimmerBox(width: double.infinity, height: 52.h, radius: 30),
//         ),
//       ],
//     );
//   }

//   Widget _testimonialShimmer() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: ShimmerBox(width: 180.w, height: 14.h, radius: 4),
//         ),
//         SizedBox(height: 10.h),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: ShimmerBox(width: 240.w, height: 56.h, radius: 6),
//         ),
//         SizedBox(height: 20.h),
//         _horizontalCardShimmer(height: 430.h, cardWidth: 300.w),
//       ],
//     );
//   }

//   Widget _carousel() {
//     return Column(
//       children: [
//         SizedBox(
//           height: 280.h,
//           width: double.infinity,
//           child: PageView.builder(
//             physics: const NeverScrollableScrollPhysics(),
//             // controller: controller.pageController,
//             itemCount: 10000,
//             // onPageChanged: controller.updatePage,
//             itemBuilder: (context, index) {
//               final realIndex = index % controller.carouselItems.length;
//               final item = controller.carouselItems[realIndex];

//               return ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(16.r),
//                   bottomRight: Radius.circular(16.r),
//                 ),
//                 child: item.imageUrl != null
//                     ? Image.asset(
//                         item.imageUrl!,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, _, _) => const SizedBox(),
//                       )
//                     : const SizedBox(),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//   Widget _courseGrid() {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 16.w),
//     child: GridView.builder(
//        padding: EdgeInsets.zero,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: controller.courseCategoryCards.length,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12.w,
//         mainAxisSpacing: 12.h,
//         childAspectRatio: 2,
//       ),
//       itemBuilder: (context, index) {
//         return CourseCard(
//           category: controller.courseCategoryCards[index],
//           index: index,
//           selectedIndex: controller.selectedCourseIndex,
//           onTap: () => controller.selectCourseCard(index),
//         );
//       },
//     ),
//   );
// }
//   Widget _trendingCoursesList() {
//     return SizedBox(
//       height: 400.h,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         itemCount: controller.trendingCourses.length,
//         separatorBuilder: (_, _) => SizedBox(width: 14.w),
//         itemBuilder: (context, index) =>
//             _trendingCourseCard(controller.trendingCourses[index]),
//       ),
//     );
//   }

//   Widget _trendingCourseCard(Map<String, dynamic> course) {
//     return Container(
//       width: 300.w,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: Colors.grey.shade200, width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8.r),
//             child: Image.asset(
//               course["logo"],
//               width: double.infinity,
//               height: 130.h,
//               fit: BoxFit.cover,
//               errorBuilder: (_, _, _) => Icon(
//                 Icons.school_rounded,
//                 color: Colors.grey.shade400,
//                 size: 28,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   course["institute"],
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     color: Colors.grey.shade600,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   course["title"],
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 10.w,
//                     vertical: 4.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(20.r),
//                     border: Border.all(color: Colors.blue.shade100),
//                   ),
//                   child: Text(
//                     course["tag"],
//                     style: TextStyle(
//                       fontSize: 11.sp,
//                       color: Colors.blue.shade700,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 12.h),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.verified_outlined,
//                       size: 15,
//                       color: Colors.grey.shade600,
//                     ),
//                     SizedBox(width: 5.w),
//                     Flexible(
//                       child: Text(
//                         course["type"],
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: 11.sp,
//                           color: Colors.grey.shade700,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 12.w),
//                     Icon(
//                       Icons.calendar_today_outlined,
//                       size: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                     SizedBox(width: 5.w),
//                     Text(
//                       course["duration"],
//                       style: TextStyle(
//                         fontSize: 11.sp,
//                         color: Colors.grey.shade700,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 12.h),
//             child: Divider(color: Colors.grey.shade200, height: 1),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 5.h),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       Get.delete<DetailsController>();
//                       Get.toNamed(Routes.detailsScreen, arguments: course);
//                     },
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: Colors.grey.shade400),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 10.h),
//                     ),
//                     child: Text(
//                       "View Program",
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 10.h),
//                       elevation: 0,
//                     ),
//                     icon: const Icon(
//                       Icons.download_outlined,
//                       color: Colors.white,
//                       size: 15,
//                     ),
//                     label: Text(
//                       "Syllabus",
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Spacer(),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(16.r),
//                 bottomRight: Radius.circular(16.r),
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Have questions? ',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: Colors.white, 
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   Icon(
//                     Icons.wifi_calling_3_outlined,
//                     color: Colors.yellow,
//                     size: 16.sp,
//                   ),
//                   SizedBox(width: 5.w),
//                   GestureDetector(
//                     onTap: () {
//                       // showSupportSheet();
//                        Get.back();
//                     LearnerSupportController.makeCall("734 757 4707");
//                     },
//                     child: Text(
//                       'Talk to expert',
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Colors.yellow,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _freeCoursesSection() {
//     final tabs = controller.freeCourses.keys.toList();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 20.0),
//           child: Text(
//             "FREE COURSES",
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Colors.grey,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.8,
//             ),
//           ),
//         ),
//         SizedBox(height: 8.h),
//         Padding(
//           padding: const EdgeInsets.only(left: 20.0),
//           child: RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: "Get started with a ",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 22.sp,
//                   ),
//                 ),
//                 TextSpan(
//                   text: "free course",
//                   style: TextStyle(
//                     color: AppColors.prime,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 22.sp,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 16.h),
//         Obx(
//           () => SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Row(
//               children: List.generate(tabs.length, (i) {
//                 final isSelected = controller.selectedFreeTab.value == i;
//                 return GestureDetector(
//                   onTap: () => controller.selectedFreeTab.value = i,
//                   child: Container(
//                     margin: EdgeInsets.only(right: 20.w),
//                     decoration: BoxDecoration(
//                       border: Border(
//                         bottom: BorderSide(
//                           color: isSelected
//                               ? AppColors.prime
//                               : Colors.transparent,
//                           width: 2.5,
//                         ),
//                       ),
//                     ),
//                     child: Text(
//                       tabs[i],
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: isSelected
//                             ? FontWeight.w700
//                             : FontWeight.w500,
//                         color: isSelected ? Colors.black : Colors.grey,
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ),
//         SizedBox(height: 4.h),
//         Divider(color: Colors.grey.shade200, height: 1),
//         SizedBox(height: 16.h),
//         Obx(() {
//           final courses =
//               controller.freeCourses[tabs[controller.selectedFreeTab.value]]!;
//           return SizedBox(
//             height: 380.h,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               itemCount: courses.length,
//               separatorBuilder: (_, _) => SizedBox(width: 14.w),
//               itemBuilder: (context, index) => _freeCourseCard(courses[index]),
//             ),
//           );
//         }),
//         SizedBox(height: 20.h),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.r),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 16.h),
//                 elevation: 0,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Explore All Free Courses",
//                     style: TextStyle(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   const Icon(
//                     Icons.arrow_forward,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _freeCourseCard(Map<String, dynamic> course) {
//     return Container(
//       width: 280.w,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: Colors.grey.shade200, width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16.r),
//               topRight: Radius.circular(16.r),
//             ),
//             child: Image.network(
//               course["image"],
//               height: 150.h,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (_, _, _) => Container(
//                 height: 150.h,
//                 color: Colors.grey.shade200,
//                 child: Icon(
//                   Icons.image_outlined,
//                   color: Colors.grey.shade400,
//                   size: 40,
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   course["title"],
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.people_outline,
//                       size: 15,
//                       color: Colors.grey.shade600,
//                     ),
//                     SizedBox(width: 5.w),
//                     Text(
//                       "${course["learners"]} learners",
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         color: Colors.grey.shade600,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 6.h),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.timer_outlined,
//                       size: 15,
//                       color: Colors.grey.shade600,
//                     ),
//                     SizedBox(width: 5.w),
//                     Text(
//                       "${course["hours"]} hrs of learning",
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         color: Colors.grey.shade600,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 10.h),
//             child: Divider(color: Colors.grey.shade200, height: 1),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 14.w),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       Get.delete<DetailsController>();
//                       Get.toNamed(Routes.detailsScreen, arguments: course);
//                     },
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: Colors.grey.shade400),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 10.h),
//                     ),
//                     child: Text(
//                       "View Program",
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 10.h),
//                       elevation: 0,
//                     ),
//                     child: Text(
//                       "Enroll Now",
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Spacer(),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(16.r),
//                 bottomRight: Radius.circular(16.r),
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Have questions? ',
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   Icon(
//                     Icons.wifi_calling_3_outlined,
//                     color: Colors.yellow,
//                     size: 16.sp,
//                   ),
//                   SizedBox(width: 5.w),
//                   GestureDetector(
//                     onTap: () {
//                        Get.back();
//                     LearnerSupportController.makeCall("734 757 4707");
//                     },
//                     child: Text(
//                       'Talk to expert',
//                       style: TextStyle(
//                         fontSize: 13.sp,
//                         color: Colors.yellow,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _freeMasterclassesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Text(
//             "FREE MASTERCLASSES",
//             style: TextStyle(
//               fontSize: 12.sp,
//               color: Colors.grey.shade600,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.8,
//             ),
//           ),
//         ),
//         SizedBox(height: 8.h),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: RichText(
//             text: TextSpan(
//               style: TextStyle(
//                 fontSize: 24.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 height: 1.3,
//               ),
//               children: const [
//                 TextSpan(text: "Attend "),
//                 TextSpan(
//                   text: "free masterclasses",
//                   style: TextStyle(color: AppColors.prime),
//                 ),
//                 TextSpan(text: " by industry experts"),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 20.h),
//         SizedBox(
//           height: 400.h,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             itemCount: controller.masterclasses.length,
//             separatorBuilder: (_, _) => SizedBox(width: 14.w),
//             itemBuilder: (context, index) =>
//                 _masterclassCard(controller.masterclasses[index]),
//           ),
//         ),
//         SizedBox(height: 20.h),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.r),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 16.h),
//                 elevation: 0,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "View All Masterclasses",
//                     style: TextStyle(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   const Icon(
//                     Icons.arrow_forward,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//   Widget _masterclassCard(Map<String, dynamic> masterclass) {
//     return Container(
//       width: 320.w,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: Colors.grey.shade200, width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _masterclassBanner(masterclass),
//           Padding(
//             padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "${masterclass["date"]} • ${masterclass["time"]}",
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     color: AppColors.prime,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   masterclass["title"],
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                     height: 1.4,
//                   ),
//                 ),
//                 SizedBox(height: 14.h),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Icon(
//                             Icons.record_voice_over_outlined,
//                             size: 22,
//                             color: Colors.grey.shade700,
//                           ),
//                           SizedBox(width: 8.w),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "By ${masterclass["speakerName"]}",
//                                   style: TextStyle(
//                                     fontSize: 13.sp,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 SizedBox(height: 2.h),
//                                 Text(
//                                   masterclass["speakerRole"],
//                                   style: TextStyle(
//                                     fontSize: 11.sp,
//                                     color: Colors.grey.shade600,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     _beeCodeLogo(),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {},
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: Colors.grey.shade400),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 12.h),
//                         ),
//                         child: Text(
//                           "View Masterclass",
//                           style: TextStyle(
//                             fontSize: 13.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10.w),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 12.h),
//                           elevation: 0,
//                         ),
//                         child: Text(
//                           "Register Now",
//                           style: TextStyle(
//                             fontSize: 13.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _masterclassBanner(Map<String, dynamic> masterclass) {
//     return ClipRRect(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(16.r),
//         topRight: Radius.circular(16.r),
//       ),
//       child: Stack(
//         children: [
//           Image.network(
//             masterclass["bannerImage"],
//             height: 160.h,
//             width: double.infinity,
//             fit: BoxFit.cover,
//             errorBuilder: (_, _, _) => Container(
//               height: 160.h,
//               color: Colors.grey.shade200,
//               child: Icon(
//                 Icons.image_outlined,
//                 color: Colors.grey.shade400,
//                 size: 40,
//               ),
//             ),
//           ),
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.black.withOpacity(0.5), Colors.transparent],
//                   begin: Alignment.bottomLeft,
//                   end: Alignment.topRight,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 12.h,
//             left: 12.w,
//             child: Row(
//               children: [
//                 _beeCodeLogo(dark: false),
//                 SizedBox(width: 8.w),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                   decoration: BoxDecoration(
//                     color: AppColors.prime,
//                     borderRadius: BorderRadius.circular(4.r),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.open_in_new,
//                         color: Colors.white,
//                         size: 10,
//                       ),
//                       SizedBox(width: 4.w),
//                       Text(
//                         "FREE MASTERCLASS",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 9.sp,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 16.h,
//             left: 12.w,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.calendar_today_outlined,
//                     size: 12,
//                     color: Colors.grey.shade700,
//                   ),
//                   SizedBox(width: 5.w),
//                   Text(
//                     masterclass["date"],
//                     style: TextStyle(
//                       fontSize: 11.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   Icon(
//                     Icons.access_time_outlined,
//                     size: 12,
//                     color: Colors.grey.shade700,
//                   ),
//                   SizedBox(width: 5.w),
//                   Text(
//                     masterclass["time"],
//                     style: TextStyle(
//                       fontSize: 11.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: CustomPaint(
//               size: Size(double.infinity, 22.h),
//               painter: _RedWavePainter(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _beeCodeLogo({bool dark = true}) {
//     return RichText(
//       text: TextSpan(
//         style: TextStyle(
//           fontSize: 18.sp,
//           fontWeight: FontWeight.bold,
//           letterSpacing: -0.5,
//         ),
//         children: [
//           TextSpan(
//             text: "Bee",
//             style: TextStyle(color: dark ? Colors.black : Colors.white),
//           ),
//           const TextSpan(
//             text: "Code",
//             style: TextStyle(color: AppColors.prime),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _learnerTestimonialsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Text(
//             "LEARNER TESTIMONIALS",
//             style: TextStyle(
//               fontSize: 12.sp,
//               color: Colors.grey.shade700,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.6,
//             ),
//           ),
//         ),
//         SizedBox(height: 8.h),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: RichText(
//             text: TextSpan(
//               style: TextStyle(
//                 fontSize: 26.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 height: 1.3,
//               ),
//               children: const [
//                 TextSpan(text: "Hear from "),
//                 TextSpan(
//                   text: "our graduates first-hand",
//                   style: TextStyle(color: AppColors.prime),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 20.h),
//         SizedBox(
//           height: 450.h,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             itemCount: controller.testimonials.length,
//             separatorBuilder: (_, _) => SizedBox(width: 14.w),
//             itemBuilder: (context, index) =>
//                 _testimonialCard(controller.testimonials[index]),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _testimonialCard(Map<String, dynamic> testimonial) {
//     return Container(
//       width: 300.w,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: Colors.grey.shade200, width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16.r),
//               topRight: Radius.circular(16.r),
//             ),
//             child: Stack(
//               children: [
//                 Image.network(
//                   testimonial["image"],
//                   height: 260.h,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, _, _) => Container(
//                     height: 260.h,
//                     color: Colors.grey.shade200,
//                     child: Icon(
//                       Icons.person_outline,
//                       color: Colors.grey.shade400,
//                       size: 50,
//                     ),
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.black.withOpacity(0.45),
//                           Colors.transparent,
//                         ],
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 16.h,
//                   left: 14.w,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 14.w,
//                       vertical: 8.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(30.r),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           width: 20.w,
//                           height: 20.w,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 1.5),
//                           ),
//                           child: Icon(
//                             Icons.play_arrow_rounded,
//                             color: Colors.white,
//                             size: 13.sp,
//                           ),
//                         ),
//                         SizedBox(width: 8.w),
//                         Text(
//                           "Watch my story",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 13.sp,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   testimonial["quote"],
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                     height: 1.4,
//                   ),
//                 ),
//                 SizedBox(height: 12.h),
//                 Text(
//                   testimonial["name"],
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 3.h),
//                 Text(
//                   testimonial["role"],
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     color: Colors.grey.shade600,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class _StickyHeader extends StatefulWidget {
//   final HomeController controller;
//   final ScrollController scrollController;

//   const _StickyHeader({
//     required this.controller,
//     required this.scrollController,
//   });

//   @override
//   State<_StickyHeader> createState() => _StickyHeaderState();
// }

// class _StickyHeaderState extends State<_StickyHeader> {
//   bool _isScrolled = false;

//   @override
//   void initState() {
//     super.initState();
//     widget.scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     final scrolled = widget.scrollController.offset > 10;
//     if (scrolled != _isScrolled) {
//       setState(() => _isScrolled = scrolled);
//     }
//   }

//   @override
//   void dispose() {
//     widget.scrollController.removeListener(_onScroll);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: _isScrolled
//             ? Brightness.light
//             : Brightness.light,
//       ),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeInOut,
//         decoration: BoxDecoration(
//           color: _isScrolled
//               ? Colors.black.withOpacity(0.9)
//               : Colors.transparent,
//           boxShadow: _isScrolled
//               ? [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.15),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ]
//               : [],
//         ),
//         child: Padding(
//           padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Image.asset(
//                             AppImages.logoapp,
//                             height: 30.h,
//                             width: 80.w,
//                           ),
//                         ],
//                       ),
//                     ),
//                     HeaderIconButton(
//                       icon: Icons.call_outlined,
//                       isHome: true,
//                       onTap: () => showSupportSheet(),
//                     ),
//                     SizedBox(width: 8.w),
//                     GestureDetector(
//                       onTap: () => Get.toNamed("/profileScreen"),
//                       child: HeaderIconButton(
//                         icon: Icons.person_outline_rounded,
//                         isHome: true,
//                         onTap: () => Get.toNamed("/profileScreen"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               AnimatedSearchBar(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _RedWavePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = AppColors.prime;
//     final path = Path()
//       ..moveTo(0, size.height)
//       ..lineTo(0, size.height * 0.4)
//       ..quadraticBezierTo(
//         size.width * 0.25,
//         size.height * 0.1,
//         size.width * 0.55,
//         size.height * 0.6,
//       )
//       ..quadraticBezierTo(
//         size.width * 0.75,
//         size.height,
//         size.width,
//         size.height * 0.3,
//       )
//       ..lineTo(size.width, size.height)
//       ..close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
