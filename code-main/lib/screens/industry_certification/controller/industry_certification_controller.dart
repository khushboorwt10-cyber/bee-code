import 'package:get/get.dart';
import '../model/industry_certification_model.dart';

class IndustryCertificationController extends GetxController {
  final selectedGoal = 'Industry Certification'.obs;

  // Sort
  final showSortSheet = false.obs;
  final selectedSort = 'Relevance'.obs;
  final sortOptions = [
    'Relevance',
    'Popularity',
    'Fees: Low to High',
    'Fees: High to Low',
    'Duration: Short to Long',
  ];

  void selectSort(String value) => selectedSort.value = value;

  // Filter
  final showFilterSheet = false.obs;
  final selectedFilterTab = 'Category'.obs;

  final filterTabs = ['Category', 'Duration', 'Level', 'Provider'];

  final Map<String, List<String>> filterOptions = {
    'Category': ['Management', 'Technology', 'Finance', 'Marketing', 'HR'],
    'Duration': ['< 3 months', '3–6 months', '6–12 months', '> 1 year'],
    'Level': ['Beginner', 'Intermediate', 'Advanced'],
    'Provider': ['PMI', 'Google', 'Microsoft', 'AWS', 'Salesforce'],
  };

  final RxMap<String, List<String>> selectedFilters =
      <String, List<String>>{}.obs;

  int get activeFilterCount =>
      selectedFilters.values.fold(0, (sum, list) => sum + list.length);

  List<String> optionsForTab(String tab) => filterOptions[tab] ?? [];

  bool isOptionSelected(String tab, String option) =>
      (selectedFilters[tab] ?? []).contains(option);

  int countForTab(String tab) => (selectedFilters[tab] ?? []).length;

  void toggleOption(String tab, String option) {
    final current = List<String>.from(selectedFilters[tab] ?? []);
    if (current.contains(option)) {
      current.remove(option);
    } else {
      current.add(option);
    }
    selectedFilters[tab] = current;
  }

  void clearAllFilters() => selectedFilters.clear();

  // Courses data
  final List<CertificationCourse> allCourses = const [
    CertificationCourse(
      universityLogo: 'PMI',
      university: 'PMI® | UpGrad KnowledgeHut',
      title: 'Project Management Professional (PMP)® Certification',
      badge: 'Guaranteed Exam Pass Study Plan',
      category: 'Management',
      programLevel: 'Certification',
      duration: '3 yrs',
      isLogoCircular: true,
    ),
    CertificationCourse(
      universityLogo: 'AWS',
      university: 'Amazon Web Services',
      title: 'AWS Certified Solutions Architect – Associate',
      badge: 'Top Rated Certification',
      category: 'Technology',
      programLevel: 'Certification',
      duration: '6 months',
    ),
    CertificationCourse(
      universityLogo: 'GCP',
      university: 'Google Cloud | Coursera',
      title: 'Google Cloud Professional Data Engineer',
      badge: 'Industry Recognised',
      category: 'Technology',
      programLevel: 'Certification',
      duration: '8 months',
    ),
    CertificationCourse(
      universityLogo: 'CFA',
      university: 'CFA Institute',
      title: 'Chartered Financial Analyst (CFA) Level I',
      badge: 'Gold Standard in Finance',
      category: 'Finance',
      programLevel: 'Certification',
      duration: '1 year',
    ),
    CertificationCourse(
      universityLogo: 'SFD',
      university: 'Salesforce | Trailhead',
      title: 'Salesforce Certified Administrator',
      badge: 'High Job Demand',
      category: 'Technology',
      programLevel: 'Certification',
      duration: '4 months',
    ),
  ];

  List<CertificationCourse> get filteredCourses {
    var result = allCourses;

    selectedFilters.forEach((tab, values) {
      if (values.isEmpty) return;
      if (tab == 'Category') {
        result =
            result.where((c) => values.contains(c.category)).toList();
      } else if (tab == 'Level') {
        result =
            result.where((c) => values.contains(c.programLevel)).toList();
      }
    });

    if (selectedSort.value == 'Duration: Short to Long') {
      result = List.from(result)
        ..sort((a, b) => a.duration.compareTo(b.duration));
    }

    return result;
  }
}