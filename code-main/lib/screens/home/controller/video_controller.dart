import 'package:beecode/screens/home/model/learning_model.dart';
import 'package:beecode/screens/home/model/video_model.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LessonPlayerController extends GetxController {
  late final List<LessonModel> lessons;
  late final int initialIndex;

  final currentIndex = 0.obs;
  final notes = <NoteModel>[].obs;
  final isAddingNote = false.obs;
  final noteText = ''.obs;
  final currentPosition = Duration.zero.obs;
  Duration resumePosition = Duration.zero;

  // ── Static: survives controller disposal ──
  // SectionLessonsController reads this after Get.to() returns
  static Duration lastSavedPosition = Duration.zero;
  static LessonModel? lastSavedLesson;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      lessons = (args['lessons'] as List)
          .map((e) => e as LessonModel)
          .toList();
      initialIndex = args['index'] as int;
      resumePosition = args['resumePosition'] as Duration? ?? Duration.zero;
    } else if (args is LessonModel) {
      lessons = [args];
      initialIndex = 0;
      resumePosition = Duration.zero;
    } else {
      lessons = [];
      initialIndex = 0;
      resumePosition = Duration.zero;
    }

    currentIndex.value = initialIndex;
    notes.clear();
    currentPosition.value = Duration.zero;
  }

  @override
  void onClose() {
    // ── Save position BEFORE controller is disposed ──
    // This is readable even after Get.to() returns and controller is gone
    lastSavedPosition = currentPosition.value;
    lastSavedLesson = lessons.isNotEmpty ? lessons[currentIndex.value] : null;
    super.onClose();
  }

  LessonModel get currentLesson {
    if (lessons.isEmpty) {
      throw Exception("❌ No lessons found");
    }
    return lessons[currentIndex.value];
  }
  bool get hasPrev => currentIndex.value > 0;
  bool get hasNext => currentIndex.value < lessons.length - 1;

  void goToPrev() {
    if (hasPrev) currentIndex.value--;
  }

  void goToNext() {
    if (hasNext) currentIndex.value++;
  }

  void openCourseDetails() => Get.back();

  void startAddingNote() => isAddingNote.value = true;

  void cancelNote() {
    isAddingNote.value = false;
    noteText.value = '';
  }

  void saveNote(String timestamp) {
    if (noteText.value.trim().isEmpty) return;
    notes.insert(
      0,
      NoteModel(
        text: noteText.value.trim(),
        timestamp: timestamp,
        createdAt: DateTime.now(),
      ),
    );
    isAddingNote.value = false;
    noteText.value = '';
  }

  void deleteNote(int index) => notes.removeAt(index);

  String formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }
}

// import 'package:beecode/screens/home/model/learning_model.dart';
// import 'package:beecode/screens/home/model/video_model.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// class LessonPlayerController extends GetxController {
//   late final List<LessonModel> lessons;
//   late final int initialIndex;

//   final currentIndex = 0.obs;
//   final notes = <NoteModel>[].obs;
//   final isAddingNote = false.obs;
//   final noteText = ''.obs;
//   final currentPosition = Duration.zero.obs;
//    Duration resumePosition = Duration.zero;

//    @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments;

//     if (args is Map<String, dynamic>) {
//       lessons = List<LessonModel>.from(args['lessons'] as List);
//       initialIndex = args['index'] as int;
//       // ── Read resume position if passed ──
//       resumePosition = args['resumePosition'] as Duration? ?? Duration.zero;
//     } else if (args is LessonModel) {
//       lessons = [args];
//       initialIndex = 0;
//       resumePosition = Duration.zero;
//     } else {
//       lessons = [];
//       initialIndex = 0;
//       resumePosition = Duration.zero;
//     }

//     currentIndex.value = initialIndex;
//     notes.clear();
//     currentPosition.value = Duration.zero;
//   }
//   LessonModel get currentLesson => lessons[currentIndex.value];
//   bool get hasPrev => currentIndex.value > 0;
//   bool get hasNext => currentIndex.value < lessons.length - 1;

//   void goToPrev() {
//     if (hasPrev) currentIndex.value--;
//   }

//   void goToNext() {
//     if (hasNext) currentIndex.value++;
//   }

//   void openCourseDetails() => Get.back();

//   void startAddingNote() => isAddingNote.value = true;

//   void cancelNote() {
//     isAddingNote.value = false;
//     noteText.value = '';
//   }

//   void saveNote(String timestamp) {
//     if (noteText.value.trim().isEmpty) return;
//     notes.insert(
//       0,
//       NoteModel(
//         text: noteText.value.trim(),
//         timestamp: timestamp,
//         createdAt: DateTime.now(),
//       ),
//     );
//     isAddingNote.value = false;
//     noteText.value = '';
//   }

//   void deleteNote(int index) => notes.removeAt(index);

//   String formatDuration(Duration d) {
//     String two(int n) => n.toString().padLeft(2, '0');
//     return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
//   }
// }
