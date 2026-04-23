
import 'package:beecode/screens/updates/controller/update_controller.dart';
import 'package:beecode/screens/updates/model/update_model.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  NotificationController get controller {
    if (!Get.isRegistered<NotificationController>()) {
      return Get.put(NotificationController());
    }
    return Get.find<NotificationController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: _NotifAppBar(controller: controller),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return _LoadingView();
        return Column(
          children: [
            _HeroHeader(controller: controller),
            _FilterChips(controller: controller),
            Expanded(child: _NotificationList(controller: controller)),
          ],
        );
      }),
    );
  }
}
class _NotifAppBar extends StatelessWidget implements PreferredSizeWidget {
  final NotificationController controller;
  const _NotifAppBar({required this.controller});

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
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        Obx(() => controller.unreadCount > 0
            ? TextButton(
                onPressed: controller.markAllRead,
                child: Text(
                  'Mark all read',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.prime,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : const SizedBox()),
        SizedBox(width: 4.w),
      ],
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final NotificationController controller;
  const _HeroHeader({required this.controller});

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
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
          child: Row(
            children: [
              // Left: text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACTIVITY CENTER',
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
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.25),
                        ),
                        TextSpan(
                          text: 'Notifications',
                          style: TextStyle(
                              color: AppColors.prime,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.25),
                        ),
                      ]),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      controller.unreadCount > 0
                          ? '${controller.unreadCount} unread message${controller.unreadCount > 1 ? 's' : ''}'
                          : 'You\'re all caught up!',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
           
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${controller.unreadCount}',
                      style: TextStyle(
                        color: controller.unreadCount > 0
                            ? AppColors.prime
                            : Colors.white38,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Unread',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class _FilterChips extends StatelessWidget {
  final NotificationController controller;
  const _FilterChips({required this.controller});

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
                final isSelected = controller.selectedFilter.value == f;
                return GestureDetector(
                  onTap: () => controller.selectFilter(f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.prime : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected ? AppColors.prime : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected ? Colors.white : Colors.black54,
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
class _NotificationList extends StatelessWidget {
  final NotificationController controller;
  const _NotificationList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.filtered;
      if (items.isEmpty) return _EmptyView();
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (_, i) => _NotificationTile(
          item: items[i],
          controller: controller,
        ),
      );
    });
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel item;
  final NotificationController controller;
  const _NotificationTile({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.deleteNotification(item.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(Icons.delete_outline, color: Colors.red, size: 22.sp),
      ),
      child: GestureDetector(
        onTap: () {
          controller.markAsRead(item.id);
          Get.to(() => NotificationDetailScreen(item: item));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: item.isRead ? Colors.white : AppColors.prime.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: item.isRead ? Colors.grey.shade100 : AppColors.prime.withOpacity(0.2),
              width: item.isRead ? 1 : 1.5,
            ),
            boxShadow: item.isRead
                ? []
                : [BoxShadow(color: AppColors.prime.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon box
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: _typeColor(item.type).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(_typeIcon(item.type), color: _typeColor(item.type), size: 20.sp),
              ),
              SizedBox(width: 12.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w700,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            margin: EdgeInsets.only(left: 6.w, top: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.prime,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.body,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black45,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        // Type badge
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: _typeColor(item.type).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            _typeLabel(item.type),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: _typeColor(item.type),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          controller.timeAgo(item.time),
                          style: TextStyle(fontSize: 11.sp, color: Colors.black38),
                        ),
                      ],
                    ),
                    if (item.actionLabel != null) ...[
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () => controller.markAsRead(item.id),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            item.actionLabel!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(NotificationType t) {
    switch (t) {
      case NotificationType.course:  return Icons.play_circle_outline;
      case NotificationType.payment: return Icons.receipt_long_outlined;
      case NotificationType.alert:   return Icons.warning_amber_rounded;
      case NotificationType.update:  return Icons.system_update_outlined;
      case NotificationType.promo:   return Icons.local_offer_outlined;
    }
  }

  Color _typeColor(NotificationType t) {
    switch (t) {
      case NotificationType.course:  return AppColors.prime;
      case NotificationType.payment: return const Color(0xFF2E7D32);
      case NotificationType.alert:   return const Color(0xFFE65100);
      case NotificationType.update:  return const Color(0xFF1565C0);
      case NotificationType.promo:   return const Color(0xFF6A1B9A);
    }
  }

  String _typeLabel(NotificationType t) {
    switch (t) {
      case NotificationType.course:  return 'Course';
      case NotificationType.payment: return 'Payment';
      case NotificationType.alert:   return 'Alert';
      case NotificationType.update:  return 'Update';
      case NotificationType.promo:   return 'Promo';
    }
  }
}

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel item;
  const NotificationDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          shadowColor: Colors.black12,
          leadingWidth: double.infinity,
          leading: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: Colors.black87),
                onPressed: () => Get.back(),
              ),
              Expanded(
                child: Text(
                  'Notification Detail',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                
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
                      Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Icon(_icon(item.type), color: Colors.white, size: 26.sp),
                      ),
                      SizedBox(height: 16.h),
                      // Type pill
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(
                          _label(item.type).toUpperCase(),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        item.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        ctrl.timeAgo(item.time),
                        style: TextStyle(color: Colors.white38, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),

                
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Text(
                        'MESSAGE',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Full ',
                            style: TextStyle(color: Colors.black87, fontSize: 20.sp, fontWeight: FontWeight.w800),
                          ),
                          TextSpan(
                            text: 'Details',
                            style: TextStyle(color: AppColors.prime, fontSize: 20.sp, fontWeight: FontWeight.w800),
                          ),
                        ]),
                      ),
                      SizedBox(height: 6.h),
                      Container(width: 40.w, height: 3.h, color: AppColors.prime),
                      SizedBox(height: 20.h),

                      
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          item.body,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black54,
                            height: 1.7,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Meta row
                      _MetaRow(
                        icon: Icons.access_time_outlined,
                        label: 'Received',
                        value: ctrl.timeAgo(item.time),
                      ),
                      SizedBox(height: 12.h),
                      _MetaRow(
                        icon: Icons.label_outline,
                        label: 'Category',
                        value: _label(item.type),
                      ),
                      SizedBox(height: 12.h),
                      _MetaRow(
                        icon: item.isRead ? Icons.mark_email_read_outlined : Icons.mark_email_unread_outlined,
                        label: 'Status',
                        value: item.isRead ? 'Read' : 'Unread',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 90.h),
              ],
            ),
          ),

          
          if (item.actionLabel != null)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
                ),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: double.infinity,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Text(
                        item.actionLabel!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _icon(NotificationType t) {
    switch (t) {
      case NotificationType.course:  return Icons.play_circle_outline;
      case NotificationType.payment: return Icons.receipt_long_outlined;
      case NotificationType.alert:   return Icons.warning_amber_rounded;
      case NotificationType.update:  return Icons.system_update_outlined;
      case NotificationType.promo:   return Icons.local_offer_outlined;
    }
  }

  String _label(NotificationType t) {
    switch (t) {
      case NotificationType.course:  return 'Course';
      case NotificationType.payment: return 'Payment';
      case NotificationType.alert:   return 'Alert';
      case NotificationType.update:  return 'Update';
      case NotificationType.promo:   return 'Promo';
    }
  }
}


class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetaRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.prime.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.prime, size: 18.sp),
        ),
        SizedBox(width: 14.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.black38, fontWeight: FontWeight.w500)),
            SizedBox(height: 1.h),
            Text(value, style: TextStyle(fontSize: 13.sp, color: Colors.black87, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: AppColors.prime.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_none_outlined, color: AppColors.prime, size: 34.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            'No notifications here',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          SizedBox(height: 6.h),
          Text(
            'You\'re all caught up for this category.',
            style: TextStyle(fontSize: 13.sp, color: Colors.black38),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 24.w,
        height: 24.w,
        child: CircularProgressIndicator(color: AppColors.prime, strokeWidth: 2.5),
      ),
    );
  }
}