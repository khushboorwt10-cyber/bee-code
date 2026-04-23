import 'package:beecode/screens/download/screen/download_screen.dart';
import 'package:beecode/screens/home/controller/section_lessons_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:beecode/screens/home/model/learning_model.dart';

class SectionLessonsScreen extends GetView<SectionLessonsController> {
  const SectionLessonsScreen({super.key});

  @override
  SectionLessonsController get controller {
    if (!Get.isRegistered<SectionLessonsController>()) {
      return Get.put(SectionLessonsController());
    }
    return Get.find<SectionLessonsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      body: Column(
        children: [
          _SectionAppBar(controller: controller),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              itemCount: controller.section.lessons.length,
              separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final lesson = controller.section.lessons[index];

                  return _LessonCard(
                    lesson: lesson,
                    controller: controller,
                    index: index, // ✅ ADD THIS
                    onTap: () => controller.onLessonTap(lesson),
                    onDownload: () => controller.onDownloadTap(lesson),
                  );

              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionAppBar extends StatelessWidget {
  final SectionLessonsController controller;
  const _SectionAppBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A3BE8),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56.h,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
                onPressed: controller.goBack,
              ),
              Expanded(
                child: Text(
                  controller.section.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // ── Go to Download screen with badge ──
              Obx(() {
                final count = controller.downloadedLessons.length;
                return GestureDetector(
                  onTap: () => Get.to(() => const DownloadScreen()),
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.download_for_offline_outlined,
                          color: Colors.white,
                          size: 26.sp,
                        ),
                        if (count > 0)
                          Positioned(
                            top: -6,
                            right: -6,
                            child: Container(
                              width: 16.w,
                              height: 16.w,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$count',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final int index;
  final SectionLessonsController controller;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const _LessonCard({
    required this.lesson,
    required this.controller,
    required this.onTap,
    required this.onDownload,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.play_circle_outline_rounded,
              color: Colors.black87,
              size: 28.sp,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Lesson ${index + 1}', // ✅ API based numbering
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            
            Obx(() {
              final isDownloaded =
                  controller.downloadedLessons.contains(lesson.id);
              return GestureDetector(
                onTap: onDownload,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: isDownloaded
                        ? Icon(
                            Icons.delete_outline_rounded,
                            key: const ValueKey('delete'),
                            color: Colors.redAccent,
                            size: 22.sp,
                          )
                        : Icon(
                            Icons.download_outlined,
                            key: const ValueKey('download'),
                            color: Colors.black87,
                            size: 22.sp,
                          ),
                  ),
                ),
              );
            }),

            SizedBox(width: 4.w),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFF1A3BE8),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
