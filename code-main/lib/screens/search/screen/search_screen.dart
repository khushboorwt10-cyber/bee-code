import 'package:beecode/screens/search/controller/search_controller.dart';
import 'package:beecode/screens/search/model/search_model.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchPageController());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: controller.goBack,
                      child: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() => TextField(
                      controller: controller.textController,
                      focusNode: controller.focusNode,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => controller.focusNode.unfocus(),
                      style: TextStyle(fontSize: 15.sp),
                      decoration: InputDecoration(
                        hintText: "Tell us what you're looking to learn",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.close,
                                    color: Colors.grey, size: 20.sp),
                                onPressed: controller.clearSearch,
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide:
                              BorderSide(color: Colors.grey[300]!, width: 1.5.w),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide:
                              BorderSide(color: Colors.grey[300]!, width: 1.5.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                              color:  AppColors.prime, width: 1.8.w),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 14.h),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    )),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: SizedBox(
                        width: 28.w,
                        height: 28.w,
                        child: const CircularProgressIndicator(
                          color: AppColors.prime,
                          strokeWidth: 2.5,
                        ),
                      ),
                    );
                  }
                  if (controller.searchQuery.value.isNotEmpty) {
                    return _SearchResults(controller: controller);
                  }
                  return _TrendingSearches(controller: controller);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendingSearches extends StatelessWidget {
  final SearchPageController controller;
  const _TrendingSearches({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Trending searches',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(height: 1.h, color: Colors.grey[300]),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 12.h,
            children: controller.trendingSearches.map((trend) {
              return _TrendingChip(
                label: trend,
                onTap: () => controller.onTrendingTap(trend),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TrendingChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TrendingChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.trending_up_rounded, size: 16.sp, color: Colors.grey[600]),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5.sp,
                color: Colors.grey[800],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final SearchPageController controller;
  const _SearchResults({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64.sp, color: Colors.grey[300]),
            SizedBox(height: 16.h),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try searching for something else',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(() => Text(
                '${controller.searchResults.length} results found',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              )),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            itemCount: controller.searchResults.length,
            separatorBuilder: (_, _) =>
                Divider(color: Colors.grey[100], height: 1.h),
            itemBuilder: (context, index) {
              final result = controller.searchResults[index];
              return _CourseCard(result: result);
            },
          ),
        ),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  final SearchResult result;
  const _CourseCard({required this.result});

  Color _categoryColor(String category) {
    final colors = {
      'AI & ML': const Color(0xFF6C63FF),
      'Tech': const Color(0xFF00897B),
      'Business':  AppColors.prime,
      'Marketing': const Color(0xFFFF7043),
      'Finance': const Color(0xFF1E88E5),
      'Design': const Color(0xFFEC407A),
      'Soft Skills': const Color(0xFF7CB342),
      'Education': const Color(0xFF8D6E63),
      'Programming': const Color(0xFF00ACC1),
    };
    return colors[category] ?? const Color(0xFF9E9E9E);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: _categoryColor(result.category).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Icon(
                Icons.play_circle_outline_rounded,
                color: _categoryColor(result.category),
                size: 28.sp,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.title,
                  style: TextStyle(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  result.subtitle,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: Colors.grey[500],
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 7.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color:
                            _categoryColor(result.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        result.category,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: _categoryColor(result.category),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.star_rounded,
                        size: 14.sp, color: Colors.amber[600]),
                    SizedBox(width: 2.w),
                    Text(
                      result.rating.toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '• ${result.students} students',
                      style:
                          TextStyle(fontSize: 12.sp, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: Colors.grey),
        ],
      ),
    );
  }
}