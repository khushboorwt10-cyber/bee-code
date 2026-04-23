import 'package:beecode/screens/search/model/search_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final RxString searchQuery = ''.obs;

  final RxList<SearchResult> searchResults = <SearchResult>[].obs;

  final RxBool isLoading = false.obs;

  final RxBool isSearchActive = false.obs;

  final List<String> trendingSearches = [
    'microsoft gen ai program',
    'study abroad',
    'mba course',
    'data science',
    'digital marketing',
  ];

  final List<SearchResult> _allCourses = [
    SearchResult(title: 'Microsoft Gen AI Program', subtitle: 'Master AI with Microsoft tools', category: 'AI & ML', rating: 4.8, students: '12K'),
    SearchResult(title: 'Study Abroad Guide 2024', subtitle: 'Complete guide to studying internationally', category: 'Education', rating: 4.7, students: '8K'),
    SearchResult(title: 'MBA Course - Business Fundamentals', subtitle: 'Top-rated MBA preparation', category: 'Business', rating: 4.9, students: '25K'),
    SearchResult(title: 'Data Science Bootcamp', subtitle: 'Python, ML, and Data Analysis', category: 'Tech', rating: 4.8, students: '30K'),
    SearchResult(title: 'Digital Marketing Mastery', subtitle: 'SEO, SEM, Social Media & more', category: 'Marketing', rating: 4.6, students: '18K'),
    SearchResult(title: 'Python for Beginners', subtitle: 'Learn Python from scratch', category: 'Programming', rating: 4.7, students: '45K'),
    SearchResult(title: 'Machine Learning A-Z', subtitle: 'Complete ML course with hands-on projects', category: 'AI & ML', rating: 4.9, students: '60K'),
    SearchResult(title: 'Web Development Bootcamp', subtitle: 'HTML, CSS, JavaScript, React & Node', category: 'Tech', rating: 4.8, students: '55K'),
    SearchResult(title: 'Financial Modeling & Valuation', subtitle: 'Excel-based financial modeling', category: 'Finance', rating: 4.7, students: '20K'),
    SearchResult(title: 'UX/UI Design Fundamentals', subtitle: 'Figma, prototyping, and design thinking', category: 'Design', rating: 4.6, students: '15K'),
    SearchResult(title: 'Public Speaking & Communication', subtitle: 'Build confidence and speak like a pro', category: 'Soft Skills', rating: 4.5, students: '10K'),
    SearchResult(title: 'Artificial Intelligence Fundamentals', subtitle: 'Introduction to AI concepts', category: 'AI & ML', rating: 4.7, students: '22K'),
  ];

  @override
  void onInit() {
    super.onInit();
    textController.addListener(_onTextChanged);
    focusNode.addListener(() {
      isSearchActive.value = focusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    searchQuery.value = textController.text;
    if (textController.text.isEmpty) {
      searchResults.clear();
      isLoading.value = false;
    } else {
      _performSearch(textController.text);
    }
  }

  void _performSearch(String query) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (textController.text.isEmpty) {
      searchResults.clear();
      isLoading.value = false;
      return;
    }

    final results = _allCourses.where((course) {
      final q = query.toLowerCase();
      return course.title.toLowerCase().contains(q) ||
          course.subtitle.toLowerCase().contains(q) ||
          course.category.toLowerCase().contains(q);
    }).toList();

    searchResults.assignAll(results);
    isLoading.value = false;
  }

  void onTrendingTap(String trend) {
    textController.text = trend;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: trend.length),
    );
    focusNode.requestFocus();
    _performSearch(trend);
  }

  void clearSearch() {
    textController.clear();
    searchResults.clear();
    searchQuery.value = '';
  }

  void goBack() {
    if (isSearchActive.value) {
      focusNode.unfocus();
    } else {
      Get.back();
    }
  }

  @override
  void onClose() {
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
