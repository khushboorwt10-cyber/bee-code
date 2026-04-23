import 'package:beecode/screens/home/screen/section_lessons_screen.dart';
import 'package:beecode/widget/share_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:beecode/screens/home/controller/course_detail_controller.dart';
import 'package:beecode/screens/home/model/learning_model.dart';


const double _kTabBarHeight = 49.0;

class CourseDetailScreen extends GetView<CourseDetailController> {
  const CourseDetailScreen({super.key});

  @override
  CourseDetailController get controller {
    if (!Get.isRegistered<CourseDetailController>()) {
      return Get.put(CourseDetailController());
    }
    return Get.find<CourseDetailController>();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    bottomNavigationBar: Obx(() {
      final lesson = controller.lastWatchedLesson.value;
      if (lesson == null) return const SizedBox.shrink();
      return _ResumeBar(
        lessonTitle: lesson.title,
        timeLeft: controller.lastWatchedTimeLeft.value,
        onResume: controller.resumeLastWatched,
        onRemove: () => controller.clearLastWatched(),
      );
    }),
    backgroundColor: const Color(0xFFF0F2F8),
    body: Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (controller.hasError.value) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(controller.errorMessage.value),
              const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: controller.fetchCourse,
              //   child: const Text('Retry'),
              // ),
            ],
          ),
        );
      }
      final course = controller.course;
      final List<dynamic> items = [];
      items.addAll(course.sections);

      return Column(
        children: [
          _HeroHeader(controller: controller),
          const _LearningTabBar(),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 8.h, bottom: 40.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                if (item is CourseSectionModel) {
                  return _SectionTile(
                    key: ValueKey(item.id),
                    section: item,
                    onLockedTap: () => controller.onSectionTap(item),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      );
    }),
  );
}
}
class _LearningTabBar extends StatelessWidget {
  const _LearningTabBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kTabBarHeight,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFF1A3BE8),
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Learning',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A3BE8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final CourseDetailController controller;
  const _HeroHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    final course = controller.course;
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A3BE8),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white, size: 22.sp),
                    onPressed: controller.goBack,
                  ),
                  Expanded(
                    child: Text(
                      course.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.share_outlined,
                        color: Colors.white, size: 22.sp),
                    onPressed: shareApp,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.progressLabel,
                    style:
                        TextStyle(color: Colors.white70, fontSize: 12.sp),
                  ),
                  SizedBox(height: 8.h),
                  _ProgressBar(
                    percent: course.progressPercent,
                    label: controller.progressPercent,
                  ),
                  SizedBox(height: 16.h),
                  Obx(() => _CertificateCard(
                        offer: course.certificateOffer,
                        isLoading: controller.isLoadingCertificate.value,
                        onTap: controller.getCertificate,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double percent;
  final String label;
  const _ProgressBar({required this.percent, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.white24,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 5.h,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final CertificateOfferModel offer;
  final bool isLoading;
  final VoidCallback onTap;
  const _CertificateCard({
    required this.offer,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90.w,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Bee',
                      style: TextStyle(
                        color: const Color(0xFF1A3BE8),
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(
                      text: 'Code',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 4.h),
                Text(
                  'CERTIFICATE OF COMPLETION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 4.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'This is to certify that',
                  style: TextStyle(color: Colors.black45, fontSize: 4.sp),
                ),
                SizedBox(height: 4.h),
                Container(height: 0.5, color: Colors.black12),
                SizedBox(height: 4.h),
                Text(
                  'has successfully completed',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45, fontSize: 4.sp),
                ),
                SizedBox(height: 3.h),
                Text(
                  offer.description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 4.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(height: 0.5, color: Colors.black12),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '12 Mar, 2026',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 3.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Issued on',
                          style: TextStyle(
                              color: Colors.black45, fontSize: 3.sp),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '~ Director',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 3.5.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'Rahul Sharma',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 3.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Container(height: 0.5, color: Colors.black12),
                SizedBox(height: 3.h),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'AI Education Pvt. Ltd.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black38, fontSize: 3.sp),
                    ),
                    Transform.rotate(
                      angle: -0.4,
                      child: Text(
                        'SAMPLE',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black.withOpacity(0.07),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: double.infinity,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A3BE8),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: isLoading
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: const CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock_open_outlined,
                                    size: 16.sp, color: Colors.white),
                                SizedBox(width: 6.w),
                                Text(
                                  'Pro to Unlock',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
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

class _SectionTile extends StatelessWidget {
  final CourseSectionModel section;
  final VoidCallback onLockedTap;

  const _SectionTile({
    super.key,
    required this.section,
    required this.onLockedTap,
  });

  void _handleTap() {
    if (section.isLocked) {
      onLockedTap();
      return;
    }
  
    Get.to(
      () => const SectionLessonsScreen(),
      arguments: section,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: section.isLocked
                          ? Colors.black38
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '${section.totalVideos} Videos',
                    style: TextStyle(
                        fontSize: 13.sp, color: Colors.black45),
                  ),
                ],
              ),
            ),
           
            section.isLocked
                ? Icon(Icons.lock_outline_rounded,
                    color: Colors.black26, size: 22.sp)
                : Icon(Icons.chevron_right_rounded,
                    color: const Color(0xFF1A3BE8), size: 24.sp),
          ],
        ),
      ),
    );
  }
}

class _AssessmentTile extends StatelessWidget {
  final AssessmentModel assessment;
  const _AssessmentTile({super.key, required this.assessment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assessment.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: assessment.isLocked
                        ? Colors.black38
                        : Colors.black87,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  '${assessment.totalItems} Assessment',
                  style: TextStyle(
                      fontSize: 13.sp, color: Colors.black38),
                ),
              ],
            ),
          ),
          if (assessment.isLocked)
            Icon(Icons.lock_outline_rounded,
                color: const Color(0xFF1A3BE8), size: 22.sp),
        ],
      ),
    );
  }
}
class _ResumeBar extends StatelessWidget {
  final String lessonTitle;
  final String timeLeft;
  final VoidCallback onResume;
  final VoidCallback onRemove; // ── NEW ──

  const _ResumeBar({
    required this.lessonTitle,
    required this.timeLeft,
    required this.onResume,
    required this.onRemove, // ── NEW ──
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // ── Play icon circle ──
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black87, width: 1.5),
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.black87,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 10.w),

          // ── Title + time left ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lessonTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                if (timeLeft.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    timeLeft,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),

          // ── Remove button ──
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(
                Icons.close_rounded,
                color: Colors.black45,
                size: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // ── Resume button ──
          GestureDetector(
            onTap: onResume,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 22.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1A3BE8),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Resume',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}