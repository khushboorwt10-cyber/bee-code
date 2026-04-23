// import 'package:beecode/screens/promotion/model/promotion_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';




// class PromotionController extends GetxController {
//   // Goals / chips
//   final List<String> goals = [
//     "Get a promotion",
//     "Industry Certification",
//     "Data Science",
//     "Free Course",
//     "Study Abroad",
//     "Prepare for your first job",
//   ];

//   late final RxString selectedGoal;

// @override
// void onInit() {
//   super.onInit();
//   final arg = Get.arguments as String?;
//   selectedGoal = (arg ?? goals.first).obs;
// }

//   final RxString selectedSort = "Relevance".obs;
//   final List<String> sortOptions = [
//     "Relevance",
//     "Duration - low to high",
//     "Duration - high to low",
//   ];
//   final RxString selectedFilterTab = "Area of interest".obs;
//   final List<String> filterTabs = [
//     "Area of interest",
//     "Program Type",
//     "University",
//     "Duration",
//   ];

//   // Area of interest options
//   final List<String> areaOptions = [
//     "All",
//     "Artificial Intelligence Courses",
//     "Data Science Courses",
//     "Doctorate Courses",
//     "For College Students",
//     "Law Courses",
//     "Management",
//     "Management Courses",
//     "Marketing",
//     "Marketing Courses",
//     "MBA Courses",
//     "Software & Tech Courses",
//   ];

//   final RxSet<String> selectedAreas = <String>{}.obs;

//   // Program Type options
//   final List<String> programTypeOptions = [
//     "Executive PG Program",
//     "Professional Certificate",
//     "Masters",
//     "Bachelors",
//     "Doctorate",
//     "Free Courses",
//   ];
//   final RxSet<String> selectedProgramTypes = <String>{}.obs;

//   // University options
//   final List<String> universityOptions = [
//     "IIIT Bangalore",
//     "IIM Kozhikode",
//     "IIT Madras",
//     "Liverpool Business School",
//     "Deakin University",
//     "Michigan State University",
//   ];
//   final RxSet<String> selectedUniversities = <String>{}.obs;

//   // Duration options
//   final List<String> durationOptions = [
//     "Less than 6 months",
//     "6 - 12 months",
//     "1 - 2 years",
//     "More than 2 years",
//   ];
//   final RxSet<String> selectedDurations = <String>{}.obs;

//   // Bottom sheet visibility
//   final RxBool showSortSheet = false.obs;
//   final RxBool showFilterSheet = false.obs;

//   // All courses mock data
//   final List<Course> _allCourses = [
//     Course(
//       university: "IIIT Bangalore",
//       universityLogo: "iiitb",
//       title: "Executive Diploma in Machine Learning and AI",
//       badge: "360° Career Support",
//       programType: "Executive PG Program",
//       duration: "1 yr",
//       category: "Artificial Intelligence Courses",
//       programLevel: "Executive PG Program",
//     ),
//     Course(
//       university: "IIM Kozhikode",
//       universityLogo: "iimk",
//       title: "Professional Certificate Program in Leadership & Management",
//       badge: "Top Rated",
//       programType: "Professional Certificate",
//       duration: "6 months",
//       category: "Management Courses",
//       programLevel: "Professional Certificate",
//     ),
//     Course(
//       university: "IIT Madras",
//       universityLogo: "iitm",
//       title: "Executive MBA - Data Science & AI",
//       badge: "360° Career Support",
//       programType: "Masters",
//       duration: "2 yrs",
//       category: "Data Science Courses",
//       programLevel: "Masters",
//     ),
//     Course(
//       university: "Liverpool Business School",
//       universityLogo: "lbs",
//       title: "Global MBA with Specialization in Marketing",
//       badge: "Industry Recognised",
//       programType: "Masters",
//       duration: "18 months",
//       category: "MBA Courses",
//       programLevel: "Masters",
//     ),
//     Course(
//       university: "Michigan State University",
//       universityLogo: "msu",
//       title: "MS in Software Engineering",
//       badge: "Top Rated",
//       programType: "Masters",
//       duration: "2 yrs",
//       category: "Software & Tech Courses",
//       programLevel: "Masters",
//     ),
//     Course(
//       university: "IIIT Bangalore",
//       universityLogo: "iiitb",
//       title: "PG Diploma in Data Science",
//       badge: "360° Career Support",
//       programType: "Executive PG Program",
//       duration: "11 months",
//       category: "Data Science Courses",
//       programLevel: "Executive PG Program",
//     ),
//     Course(
//       university: "IIM Kozhikode",
//       universityLogo: "iimk",
//       title: "Senior Management Programme",
//       badge: "IIM Certified",
//       programType: "Professional Certificate",
//       duration: "9 months",
//       category: "Management",
//       programLevel: "Professional Certificate",
//     ),
//     Course(
//       university: "Deakin University",
//       universityLogo: "deakin",
//       title: "Master of Business Administration",
//       badge: "Globally Recognised",
//       programType: "Masters",
//       duration: "2 yrs",
//       category: "MBA Courses",
//       programLevel: "Masters",
//     ),
//   ];

//   RxList<Course> get filteredCourses {
//     List<Course> result = List.from(_allCourses);

//     // Filter by area
//     if (selectedAreas.isNotEmpty && !selectedAreas.contains("All")) {
//       result = result.where((c) => selectedAreas.contains(c.category)).toList();
//     }
//     // Filter by program type
//     if (selectedProgramTypes.isNotEmpty) {
//       result = result.where((c) => selectedProgramTypes.contains(c.programType)).toList();
//     }
//     // Filter by university
//     if (selectedUniversities.isNotEmpty) {
//       result = result.where((c) => selectedUniversities.contains(c.university)).toList();
//     }
//     // Filter by duration
//     if (selectedDurations.isNotEmpty) {
//       result = result.where((c) {
//         for (final d in selectedDurations) {
//           if (d == "Less than 6 months" && _monthsFromDuration(c.duration) < 6) return true;
//           if (d == "6 - 12 months") {
//             final m = _monthsFromDuration(c.duration);
//             if (m >= 6 && m <= 12) return true;
//           }
//           if (d == "1 - 2 years") {
//             final m = _monthsFromDuration(c.duration);
//             if (m > 12 && m <= 24) return true;
//           }
//           if (d == "More than 2 years" && _monthsFromDuration(c.duration) > 24) return true;
//         }
//         return false;
//       }).toList();
//     }

//     // Sort
//     if (selectedSort.value == "Duration - low to high") {
//       result.sort((a, b) => _monthsFromDuration(a.duration).compareTo(_monthsFromDuration(b.duration)));
//     } else if (selectedSort.value == "Duration - high to low") {
//       result.sort((a, b) => _monthsFromDuration(b.duration).compareTo(_monthsFromDuration(a.duration)));
//     }

//     return result.obs;
//   }

//   int _monthsFromDuration(String dur) {
//     dur = dur.toLowerCase().trim();
//     if (dur.contains("yr") || dur.contains("year")) {
//       final n = double.tryParse(dur.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 1;
//       return (n * 12).toInt();
//     }
//     if (dur.contains("month")) {
//       return int.tryParse(dur.replaceAll(RegExp(r'[^0-9]'), '')) ?? 6;
//     }
//     return 12;
//   }

//   // Computed filter count badge
//   int get activeFilterCount =>
//       selectedAreas.length + selectedProgramTypes.length + selectedUniversities.length + selectedDurations.length;

//   // ── Actions ────────────────────────────────────────────────────────────────

//   void selectGoal(String goal) => selectedGoal.value = goal;
//   void selectSort(String sort) => selectedSort.value = sort;

//   void toggleAreaOption(String option) {
//     if (option == "All") {
//       if (selectedAreas.contains("All")) {
//         selectedAreas.clear();
//       } else {
//         selectedAreas.assignAll(areaOptions.toSet());
//       }
//     } else {
//       if (selectedAreas.contains(option)) {
//         selectedAreas.remove(option);
//         selectedAreas.remove("All");
//       } else {
//         selectedAreas.add(option);
//         if (selectedAreas.length == areaOptions.length - 1) {
//           selectedAreas.add("All");
//         }
//       }
//     }
//   }

//   void toggleProgramType(String option) {
//     if (selectedProgramTypes.contains(option)) {
//       selectedProgramTypes.remove(option);
//     } else {
//       selectedProgramTypes.add(option);
//     }
//   }

//   void toggleUniversity(String option) {
//     if (selectedUniversities.contains(option)) {
//       selectedUniversities.remove(option);
//     } else {
//       selectedUniversities.add(option);
//     }
//   }

//   void toggleDuration(String option) {
//     if (selectedDurations.contains(option)) {
//       selectedDurations.remove(option);
//     } else {
//       selectedDurations.add(option);
//     }
//   }

//   void clearAllFilters() {
//     selectedAreas.clear();
//     selectedProgramTypes.clear();
//     selectedUniversities.clear();
//     selectedDurations.clear();
//   }

//   bool isOptionSelected(String tab, String option) {
//     switch (tab) {
//       case "Area of interest": return selectedAreas.contains(option);
//       case "Program Type": return selectedProgramTypes.contains(option);
//       case "University": return selectedUniversities.contains(option);
//       case "Duration": return selectedDurations.contains(option);
//       default: return false;
//     }
//   }

//   List<String> optionsForTab(String tab) {
//     switch (tab) {
//       case "Area of interest": return areaOptions;
//       case "Program Type": return programTypeOptions;
//       case "University": return universityOptions;
//       case "Duration": return durationOptions;
//       default: return [];
//     }
//   }

//   void toggleOption(String tab, String option) {
//     switch (tab) {
//       case "Area of interest": toggleAreaOption(option); break;
//       case "Program Type": toggleProgramType(option); break;
//       case "University": toggleUniversity(option); break;
//       case "Duration": toggleDuration(option); break;
//     }
//   }

//   int countForTab(String tab) {
//     switch (tab) {
//       case "Area of interest": return selectedAreas.length;
//       case "Program Type": return selectedProgramTypes.length;
//       case "University": return selectedUniversities.length;
//       case "Duration": return selectedDurations.length;
//       default: return 0;
//     }
//   }
// }