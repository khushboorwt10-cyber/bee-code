import 'package:beecode/screens/doctorate/model/doctorate_courses_model.dart';
import 'package:get/get.dart';

class DoctorateController extends GetxController {
  final RxList<DoctorateModel> courses = <DoctorateModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'All'.obs;
  final RxBool showCareerBanner = true.obs;

  final List<String> filterOptions = [
    'All',
    'Popular',
    '12 Months',
    '24 Months',
    '36 Months',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadCourses();
  }

  void _loadCourses() {
    isLoading.value = true;
    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      courses.assignAll([
        DoctorateModel(
          id: '1',
          universityName: 'Swiss School Of Business And Management',
          programTitle: 'Global Doctor of Business Administration from SSBM',
          logoAsset: 'ssbm',
          duration: '36 Months',
          level: 'Doctorate',
          tags: ['1:1 Thesis Supervision'],
          isPopular: true,
        ),
        DoctorateModel(
          id: '2',
          universityName: 'Golden Gate University',
          programTitle: 'Doctor of Business Administration',
          logoAsset: 'ggu',
          duration: '36 Months',
          level: 'Doctorate',
          tags: ['Industry Mentorship'],
          isPopular: false,
        ),
        DoctorateModel(
          id: '3',
          universityName: 'University of Atlanta',
          programTitle: 'Doctor of Business Administration',
          logoAsset: 'atlanta',
          duration: '24 Months',
          level: 'Doctorate',
          tags: ['Live Sessions'],
          isPopular: false,
        ),
        DoctorateModel(
          id: '4',
          universityName: 'Westcliff University',
          programTitle: 'Doctor of Business Administration',
          logoAsset: 'westcliff',
          duration: '36 Months',
          level: 'Doctorate',
          tags: ['Research Focused'],
          isPopular: true,
        ),
      ]);
      isLoading.value = false;
    });
  }

  List<DoctorateModel> get filteredCourses {
    if (selectedFilter.value == 'All') return courses;
    if (selectedFilter.value == 'Popular') {
      return courses.where((c) => c.isPopular).toList();
    }
    return courses.where((c) => c.duration == selectedFilter.value).toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void dismissCareerBanner() {
    showCareerBanner.value = false;
  }
}