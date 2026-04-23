import 'package:beecode/screens/download/controller/download_controller.dart';
import 'package:beecode/screens/download/model/download_model.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/widget/share_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DownloadScreen extends GetView<DownloadController> {
  const DownloadScreen({super.key});

  @override
  DownloadController get controller {
    if (!Get.isRegistered<DownloadController>()) {
      return Get.put(DownloadController());
    }
    return Get.find<DownloadController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: Obx(() => _AppBarWidget(
              title: 'My Downloads',
              onBack: () => Get.back(),
              trailing: controller.totalCompleted > 0
                  ? GestureDetector(
                      onTap: () => _confirmClear(controller),
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.red.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            )),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const _LoadingView();
        return Column(
          children: [
            _HeroSection(controller: controller),
            _FilterRow(controller: controller),
            Expanded(child: _DownloadList(controller: controller)),
          ],
        );
      }),
    );
  }

  void _confirmClear(DownloadController downloadController) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56.w, height: 56.w,
                decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                child: Icon(Icons.delete_outline, color: Colors.red, size: 28.sp),
              ),
              SizedBox(height: 16.h),
              Text('Clear completed?',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.black87)),
              SizedBox(height: 8.h),
              Text(
                'All completed downloads will be removed from this list.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: Colors.black45, height: 1.5),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Text('Cancel',
                              style: TextStyle(fontSize: 14.sp, color: Colors.black54, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () { downloadController.clearCompleted(); Get.back(); },
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: Text('Clear',
                              style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
//  APP BAR
// ════════════════════════════════════════════════════
class _AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;
  final Widget? trailing;
  const _AppBarWidget({required this.title, required this.onBack, this.trailing});

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      shadowColor: Colors.black12,
      leadingWidth: double.infinity,
      leading: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: Colors.black87),
            onPressed: onBack,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [?trailing],
    );
  }
}

// ════════════════════════════════════════════════════
//  HERO SECTION
// ════════════════════════════════════════════════════
class _HeroSection extends StatelessWidget {
  final DownloadController controller;
  const _HeroSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 1, 11, 43),
                Color.fromARGB(255, 6, 49, 130),
                Color.fromARGB(255, 1, 11, 43),
              ],
            ),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 26.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OFFLINE CONTENT',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.4,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Your ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25),
                            ),
                            TextSpan(
                              text: 'Downloads',
                              style: TextStyle(
                                  color: AppColors.prime,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25),
                            ),
                          ]),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          controller.activeCount > 0
                              ? '${controller.activeCount} download${controller.activeCount > 1 ? 's' : ''} in progress'
                              : 'Access your content offline anytime',
                          style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.storage_outlined, color: AppColors.prime, size: 22.sp),
                        SizedBox(height: 4.h),
                        Text(controller.storageLabel(),
                            style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w800)),
                        Text('Used', style: TextStyle(color: Colors.white38, fontSize: 9.sp)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    _InfoCell(label: 'Completed',  value: '${controller.totalCompleted}'),
                    _HeroDivider(),
                    _InfoCell(label: 'In Progress', value: '${controller.activeCount}'),
                    _HeroDivider(),
                    _InfoCell(label: 'Total Files', value: '${controller.downloads.length}'),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w800)),
          SizedBox(height: 2.h),
          Text(label,
              style: TextStyle(color: Colors.white54, fontSize: 10.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _HeroDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 36.h, color: Colors.white24);
}

// ════════════════════════════════════════════════════
//  FILTER ROW
// ════════════════════════════════════════════════════
class _FilterRow extends StatelessWidget {
  final DownloadController controller;
  const _FilterRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: controller.filters.map((f) {
                final active = controller.selectedFilter.value == f;
                return GestureDetector(
                  onTap: () => controller.selectFilter(f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: active ? AppColors.prime : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          color: active ? AppColors.prime : Colors.grey.shade300),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                        color: active ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ));
  }
}

// ════════════════════════════════════════════════════
//  DOWNLOAD LIST
// ════════════════════════════════════════════════════
class _DownloadList extends StatelessWidget {
  final DownloadController controller;
  const _DownloadList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.filtered;
      if (items.isEmpty) return const _EmptyView();
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (_, i) =>
            _DownloadTile(item: items[i], controller: controller),
      );
    });
  }
}

// ════════════════════════════════════════════════════
//  DOWNLOAD TILE
// ════════════════════════════════════════════════════
class _DownloadTile extends StatelessWidget {
  final DownloadModel item;
  final DownloadController controller;
  const _DownloadTile({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        controller.deleteDownload(item.id);
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(14.r)),
        child: Icon(Icons.delete_outline, color: Colors.red, size: 22.sp),
      ),
      child: GestureDetector(
        onTap: () {
          if (item.status == DownloadStatus.completed) {
            Get.to(() => DownloadDetailScreen(item: item));
          }
        },
        onLongPress: () => _showOptions(controller),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: _borderColor(), width: _isActive ? 1.5 : 1),
            boxShadow: _isActive
                ? [BoxShadow(
                    color: AppColors.prime.withOpacity(0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 3))]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44.w, height: 44.w,
                    decoration: BoxDecoration(
                      color: _typeColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(_typeIcon, color: _typeColor, size: 22.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                              height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        Text(item.subtitle,
                            style: TextStyle(fontSize: 11.sp, color: Colors.black38)),
                        SizedBox(height: 5.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: AppColors.prime.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            item.courseName,
                            style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.prime,
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _ActionBtn(item: item, controller: controller),
                ],
              ),

              // ── Progress bar (downloading / paused) ──
              if (item.status == DownloadStatus.downloading ||
                  item.status == DownloadStatus.paused) ...[
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.progressLabel,
                        style: TextStyle(fontSize: 11.sp, color: Colors.black45)),
                    Text(
                      '${(item.progress * 100).toInt()}%',
                      style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: item.status == DownloadStatus.paused
                              ? Colors.orange
                              : AppColors.prime),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: item.progress,
                    minHeight: 5.h,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        item.status == DownloadStatus.paused
                            ? Colors.orange
                            : AppColors.prime),
                  ),
                ),
              ],

              // ── Completed footer ──
              if (item.status == DownloadStatus.completed) ...[
                SizedBox(height: 10.h),
                Divider(height: 1, color: Colors.black12),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green, size: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Downloaded · ${item.sizeLabel}',
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      controller.timeAgo(item.completedAt),
                      style: TextStyle(fontSize: 11.sp, color: Colors.black38),
                    ),
                  ],
                ),
              ],

              // ── Failed footer ──
              if (item.status == DownloadStatus.failed) ...[
                SizedBox(height: 10.h),
                Divider(height: 1, color: Colors.black12),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade400, size: 14.sp),
                    SizedBox(width: 4.w),
                    Text('Download failed — tap retry',
                        style: TextStyle(fontSize: 11.sp, color: Colors.red.shade400)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Long-press bottom sheet ──
  void _showOptions(DownloadController downloadController) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w, height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              item.title,
              style: TextStyle(
                  fontSize: 13.sp, fontWeight: FontWeight.w700, color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(item.subtitle,
                style: TextStyle(fontSize: 11.sp, color: Colors.black38)),
            SizedBox(height: 20.h),
            Divider(height: 1, color: Colors.black12),
            SizedBox(height: 8.h),

            if (item.status == DownloadStatus.downloading ||
                item.status == DownloadStatus.paused) ...[
              _SheetOption(
                icon: Icons.cancel_outlined,
                label: 'Cancel download',
                color: Colors.orange.shade700,
                onTap: () { downloadController.cancelDownload(item.id); Get.back(); },
              ),
              SizedBox(height: 4.h),
            ],

            _SheetOption(
              icon: Icons.delete_outline,
              label: 'Delete from downloads',
              color: Colors.red,
              onTap: () { downloadController.deleteDownload(item.id); Get.back(); },
            ),
            SizedBox(height: 4.h),

            // Dismiss
            _SheetOption(
              icon: Icons.close,
              label: 'Cancel',
              color: Colors.black54,
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  bool get _isActive => item.status == DownloadStatus.downloading;

  Color _borderColor() {
    switch (item.status) {
      case DownloadStatus.downloading: return AppColors.prime.withOpacity(0.25);
      case DownloadStatus.paused:      return Colors.orange.withOpacity(0.25);
      case DownloadStatus.failed:      return Colors.red.shade100;
      default:                         return Colors.black12;
    }
  }

  IconData get _typeIcon {
    switch (item.type) {
      case DownloadFileType.video: return Icons.play_circle_outline;
      case DownloadFileType.pdf:   return Icons.picture_as_pdf_outlined;
      case DownloadFileType.zip:   return Icons.folder_zip_outlined;
      case DownloadFileType.audio: return Icons.headphones_outlined;
    }
  }

  Color get _typeColor {
    switch (item.type) {
      case DownloadFileType.video: return AppColors.prime;
      case DownloadFileType.pdf:   return const Color(0xFFE65100);
      case DownloadFileType.zip:   return const Color(0xFF6A1B9A);
      case DownloadFileType.audio: return const Color(0xFF1565C0);
    }
  }
}

// ════════════════════════════════════════════════════
//  ACTION BUTTON
// ════════════════════════════════════════════════════
class _ActionBtn extends StatelessWidget {
  final DownloadModel item;
  final DownloadController controller;
  const _ActionBtn({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    VoidCallback onTap;

    switch (item.status) {
      case DownloadStatus.notStarted:
        icon = Icons.download_outlined;
        color = AppColors.prime;
        onTap = () => controller.startDownload(item.id);
        break;
      case DownloadStatus.downloading:
        icon = Icons.pause;
        color = AppColors.prime;
        onTap = () => controller.pauseDownload(item.id);
        break;
      case DownloadStatus.paused:
        icon = Icons.play_arrow;
        color = Colors.orange;
        onTap = () => controller.resumeDownload(item.id);
        break;
      case DownloadStatus.completed:
        icon = Icons.open_in_new_rounded;
        color = Colors.green;
        onTap = () => controller.openFile(item);
        break;
      case DownloadStatus.failed:
        icon = Icons.refresh;
        color = Colors.red;
        onTap = () => controller.retryDownload(item.id);
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w, height: 36.w,
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Icon(icon, color: color, size: 18.sp),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
//  SHEET OPTION
// ════════════════════════════════════════════════════
class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20.sp),
            SizedBox(width: 14.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
//  DOWNLOAD DETAIL SCREEN
// ════════════════════════════════════════════════════
class DownloadDetailScreen extends StatelessWidget {
  final DownloadModel item;
  const DownloadDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final downloadController = Get.find<DownloadController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: _AppBarWidget(
          title: 'File Details',
          onBack: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // ── Hero ──
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 1, 11, 43),
                        Color.fromARGB(255, 6, 49, 130),
                        Color.fromARGB(255, 1, 11, 43),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52.w, height: 52.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Icon(_typeIcon(item.type),
                                color: Colors.white, size: 26.sp),
                          ),
                          SizedBox(width: 14.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                      color: Colors.green.withOpacity(0.35)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle_outline,
                                        color: Colors.greenAccent, size: 12.sp),
                                    SizedBox(width: 4.w),
                                    Text('Downloaded',
                                        style: TextStyle(
                                            color: Colors.greenAccent,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _typeLabel(item.type).toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.1),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        item.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                            letterSpacing: -0.3),
                      ),
                      SizedBox(height: 6.h),
                      Text(item.subtitle,
                          style: TextStyle(color: Colors.white54, fontSize: 13.sp)),
                    ],
                  ),
                ),

                // ── About section ──
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FILE INFORMATION',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2),
                      ),
                      SizedBox(height: 8.h),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'About This ',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800),
                          ),
                          TextSpan(
                            text: 'File',
                            style: TextStyle(
                                color: AppColors.prime,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800),
                          ),
                        ]),
                      ),
                      SizedBox(height: 20.h),
                      Container(width: 50.w, height: 3.h, color: AppColors.prime),
                      SizedBox(height: 24.h),
                      _DetailRow(
                          icon: Icons.folder_outlined,
                          label: 'Course',
                          value: item.courseName),
                      SizedBox(height: 16.h),
                      _DetailRow(
                          icon: Icons.data_usage_outlined,
                          label: 'File Size',
                          value: item.sizeLabel),
                      SizedBox(height: 16.h),
                      _DetailRow(
                          icon: _typeIcon(item.type),
                          label: 'File Type',
                          value: _typeLabel(item.type)),
                      SizedBox(height: 16.h),
                      _DetailRow(
                          icon: Icons.schedule_outlined,
                          label: 'Downloaded',
                          value: downloadController.timeAgo(item.completedAt)),
                      if (item.localPath != null) ...[
                        SizedBox(height: 16.h),
                        _DetailRow(
                            icon: Icons.save_alt_outlined,
                            label: 'Saved at',
                            value: item.localPath!),
                      ],
                    ],
                  ),
                ),

                // ── Share card ──
                Container(
                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Want to share this file?',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800)),
                      SizedBox(height: 8.h),
                      Text(
                        'Share this downloaded file with classmates or save it to cloud storage.',
                        style: TextStyle(
                            color: Colors.black54, fontSize: 13.sp, height: 1.5),
                      ),
                      SizedBox(height: 18.h),
                      _CTAButton(
                        label: 'Share File',
                        icon: Icons.share_outlined,
                        isLoading: false,
                        onTap: () =>shareApp()
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 90.h),
              ],
            ),
          ),

          // ── Sticky Open button ──
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -4))
                ],
              ),
              child: _CTAButton(
                label: 'Open File',
                icon: Icons.open_in_new_rounded,
                isLoading: false,
                onTap: () => downloadController.openFile(item),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _typeIcon(DownloadFileType t) {
    switch (t) {
      case DownloadFileType.video: return Icons.play_circle_outline;
      case DownloadFileType.pdf:   return Icons.picture_as_pdf_outlined;
      case DownloadFileType.zip:   return Icons.folder_zip_outlined;
      case DownloadFileType.audio: return Icons.headphones_outlined;
    }
  }

  String _typeLabel(DownloadFileType t) {
    switch (t) {
      case DownloadFileType.video: return 'Video';
      case DownloadFileType.pdf:   return 'PDF Document';
      case DownloadFileType.zip:   return 'ZIP Archive';
      case DownloadFileType.audio: return 'Audio';
    }
  }
}

// ════════════════════════════════════════════════════
//  DETAIL ROW
// ════════════════════════════════════════════════════
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w, height: 40.w,
          decoration: BoxDecoration(
              color: AppColors.prime.withOpacity(0.08),
              shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.prime, size: 18.sp),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 2.h),
              Text(value,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════
//  CTA BUTTON
// ════════════════════════════════════════════════════
class _CTAButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;
  final VoidCallback onTap;
  const _CTAButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22.w, height: 22.h,
                  child: const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: Colors.white, size: 18.sp),
                      SizedBox(width: 8.w),
                    ],
                    Text(label,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3)),
                  ],
                ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
//  EMPTY & LOADING
// ════════════════════════════════════════════════════
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.w, height: 72.w,
            decoration: BoxDecoration(
                color: AppColors.prime.withOpacity(0.08),
                shape: BoxShape.circle),
            child: Icon(Icons.download_outlined, color: AppColors.prime, size: 34.sp),
          ),
          SizedBox(height: 16.h),
          Text('No downloads here',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
          SizedBox(height: 6.h),
          Text('Nothing in this category yet.',
              style: TextStyle(fontSize: 13.sp, color: Colors.black38)),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 24.w, height: 24.w,
        child: CircularProgressIndicator(color: AppColors.prime, strokeWidth: 2.5),
      ),
    );
  }
}