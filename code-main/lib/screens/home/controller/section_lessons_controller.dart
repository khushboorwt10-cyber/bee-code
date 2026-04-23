import 'package:beecode/screens/download/controller/download_controller.dart';
import 'package:beecode/screens/download/model/download_model.dart';
import 'package:beecode/screens/home/controller/course_detail_controller.dart';
import 'package:beecode/screens/home/controller/video_controller.dart';
import 'package:beecode/screens/home/model/learning_model.dart';
import 'package:beecode/screens/home/screen/video_screen.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SectionLessonsController extends GetxController {
  late final CourseSectionModel section;

  final downloadedLessons = <String>{}.obs;
  final RxInt apiLessonCount = 0.obs;
  DownloadController get _downCtrl {
    if (!Get.isRegistered<DownloadController>()) {
      return Get.put(DownloadController(), permanent: true);
    }
    return Get.find<DownloadController>();
  }
  @override
  void onInit() {
    super.onInit();

    section = Get.arguments as CourseSectionModel;

    // ✅ API se lesson count set karo
    apiLessonCount.value = section.lessons.length;
    print("📚 Total lessons: ${section.lessons.length}");
    if (section.lessons.isNotEmpty) {
      print("🎥 First video: ${section.lessons.first.videoUrl}");
    }

    _syncFromDownloadController();

    ever(_downCtrl.downloads, (_) {
      _syncFromDownloadController();
    });
  }
  void _syncFromDownloadController() {
    final ctrl = _downCtrl;
    final lessonIds = section.lessons.map((l) => l.id).toSet();
    final downloadedIds = ctrl.downloads
        .map((d) => d.id)
        .where((id) => lessonIds.contains(id))
        .toSet();
    // ignore: invalid_use_of_protected_member
    downloadedLessons.value = downloadedIds;
  }

  void goBack() => Get.back();

  void onLessonTap(LessonModel lesson) async {
    final lessons = section.lessons;
    final index = lessons.indexOf(lesson);
    if (lesson.videoUrl.isEmpty) {
      Get.snackbar("Error", "Video not available");
      return;
    }
    if (lessons.isEmpty) {
      print("❌ No lessons found");
      return;
    }
    await Get.to(
      () => const VideoScreen(),
      arguments: {
        'lessons': section.lessons,
        'index': index,
        'resumePosition': Duration.zero,
      },
    );

    // ── Controller is already disposed here, use static variable ──
    final savedPos = LessonPlayerController.lastSavedPosition;
    final savedLesson = LessonPlayerController.lastSavedLesson ?? lesson;

    // Notify CourseDetailController so resume bar appears
    if (Get.isRegistered<CourseDetailController>()) {
      final timeLeft = savedPos.inSeconds > 0
          ? _formatTimeLeft(savedPos)
          : savedLesson.duration;

      Get.find<CourseDetailController>()
          .updateLastWatched(savedLesson, timeLeft, savedPos);
    }
  }

  String _formatTimeLeft(Duration pos) {
    final mins = pos.inMinutes;
    final secs = pos.inSeconds.remainder(60);
    if (mins > 0) return '$mins Mins $secs Secs Left';
    return '$secs Secs Left';
  }

  void onDownloadTap(LessonModel lesson) {
    final ctrl = _downCtrl;

    if (downloadedLessons.contains(lesson.id)) {
      ctrl.deleteDownload(lesson.id);
    } else {
      ctrl.addAndStart(DownloadModel(
        id: lesson.id,
        title: lesson.title,
        subtitle: lesson.duration,
        courseName: section.title,
        type: DownloadFileType.video,
        totalSizeMB: 120.0,
        status: DownloadStatus.notStarted,
      ));
    }
  }
}
