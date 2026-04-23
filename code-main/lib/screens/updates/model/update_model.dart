enum NotificationType { course, payment, alert, update, promo }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime time;
  final bool isRead;
  final String? actionLabel;
  final String? actionRoute;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.time,
    this.isRead = false,
    this.actionLabel,
    this.actionRoute,
  });

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        title: title,
        body: body,
        type: type,
        time: time,
        isRead: isRead ?? this.isRead,
        actionLabel: actionLabel,
        actionRoute: actionRoute,
      );
}
final List<NotificationModel> sampleNotifications = [
  NotificationModel(
    id: '1',
    title: 'New Lecture Available',
    body: 'Module 3: Neural Networks is now live. Tap to start learning.',
    type: NotificationType.course,
    time: DateTime.now().subtract(const Duration(minutes: 10)),
    actionLabel: 'View Lecture',
  ),
  NotificationModel(
    id: '2',
    title: 'Payment Successful',
    body: 'Your EMI of ₹4,200 for Executive Diploma in ML & AI has been processed.',
    type: NotificationType.payment,
    time: DateTime.now().subtract(const Duration(hours: 2)),
    isRead: true,
    actionLabel: 'View Receipt',
  ),
  NotificationModel(
    id: '3',
    title: 'Assignment Deadline',
    body: 'Your Capstone Project submission is due in 48 hours.',
    type: NotificationType.alert,
    time: DateTime.now().subtract(const Duration(hours: 5)),
    actionLabel: 'Submit Now',
  ),
  NotificationModel(
    id: '4',
    title: 'App Updated to v2.4',
    body: "We've fixed bugs and improved performance. Enjoy a smoother experience!",
    type: NotificationType.update,
    time: DateTime.now().subtract(const Duration(days: 1)),
    isRead: true,
  ),
  NotificationModel(
    id: '5',
    title: '🎉 Limited Offer – 20% Off',
    body: 'Enroll in any PG Program before March 31 and save ₹12,000. Use code SKILL20.',
    type: NotificationType.promo,
    time: DateTime.now().subtract(const Duration(days: 2)),
    actionLabel: 'Explore Courses',
  ),
  NotificationModel(
    id: '6',
    title: 'Live Session Tonight',
    body: 'Dr. Anita Sharma will host a live Q&A on Deep Learning at 8:00 PM IST.',
    type: NotificationType.course,
    time: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    isRead: true,
    actionLabel: 'Set Reminder',
  ),
  NotificationModel(
    id: '7',
    title: 'Certificate Ready',
    body: 'Your certificate for Python Essentials is ready to download.',
    type: NotificationType.update,
    time: DateTime.now().subtract(const Duration(days: 3)),
    actionLabel: 'Download',
  ),
  NotificationModel(
    id: '8',
    title: 'Upcoming EMI Reminder',
    body: 'Your next EMI of ₹4,200 is due on April 5. Ensure sufficient balance.',
    type: NotificationType.payment,
    time: DateTime.now().subtract(const Duration(days: 4)),
    isRead: true,
  ),
];