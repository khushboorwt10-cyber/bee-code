// lib/screens/notifications/controller/notification_controller.dart

import 'package:beecode/screens/updates/model/update_model.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {

  final notifications     = <NotificationModel>[].obs;
  final selectedFilter    = 'All'.obs;
  final isLoading         = false.obs;

  final List<String> filters = [
    'All', 'Course', 'Payment', 'Alert', 'Update', 'Promo',
  ];


  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationModel> get filtered {
    if (selectedFilter.value == 'All') return notifications;
    final type = _filterToType(selectedFilter.value);
    return notifications.where((n) => n.type == type).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    notifications.assignAll(sampleNotifications);
    isLoading.value = false;
  }

  void selectFilter(String filter) => selectedFilter.value = filter;

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      notifications.refresh();
    }
  }

  void markAllRead() {
    notifications.assignAll(
      notifications.map((n) => n.copyWith(isRead: true)).toList(),
    );
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
  }

  void clearAll() => notifications.clear();

  NotificationType? _filterToType(String filter) {
    switch (filter) {
      case 'Course':  return NotificationType.course;
      case 'Payment': return NotificationType.payment;
      case 'Alert':   return NotificationType.alert;
      case 'Update':  return NotificationType.update;
      case 'Promo':   return NotificationType.promo;
      default:        return null;
    }
  }

  String timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60)  return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24)  return '${diff.inHours}h ago';
    if (diff.inDays    < 7)   return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}