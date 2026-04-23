
import 'package:beecode/screens/my_programs/model/my_program_model.dart';
import 'package:get/get.dart';

class MyProgramsController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<EnrolledCourseModel> enrolledCourses =
      <EnrolledCourseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEnrolledCourses();
  }

  Future<void> fetchEnrolledCourses() async {
    isLoading.value = true;
    try {
      // ── Replace this block with your real API call ──────────────────
      // final response = await ApiService.getEnrolledCourses();
      // enrolledCourses.value = (response['data'] as List)
      //     .map((e) => EnrolledCourseModel.fromJson(e))
      //     .toList();
      //
      // ── Dummy data (remove once API is wired) ───────────────────────
      await Future.delayed(const Duration(milliseconds: 600));
      enrolledCourses.value = [
        const EnrolledCourseModel(
          id: '1',
          title: 'Flutter Development Bootcamp',
          instructor: 'Rahul Sharma',
          totalDuration: '5 hrs 34 mins',
          progressPercent: 0.65,
        ),
        const EnrolledCourseModel(
          id: '2',
          title: 'Dart Programming Fundamentals',
          instructor: 'Priya Mehta',
          totalDuration: '3 hrs 20 mins',
          progressPercent: 1.0,
        ),
        const EnrolledCourseModel(
          id: '3',
          title: 'UI/UX Design Masterclass',
          instructor: 'Arjun Singh',
          totalDuration: '8 hrs 10 mins',
          progressPercent: 0.0,
        ),
      ];
      // ────────────────────────────────────────────────────────────────
    } catch (e) {
      enrolledCourses.clear();
    } finally {
      isLoading.value = false;
    }
  }
}