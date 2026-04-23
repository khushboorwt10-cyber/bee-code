import 'package:beecode/screens/faqs/controller/faqs_controller.dart';
import 'package:beecode/screens/faqs/model/faqs_model.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaqSection extends StatefulWidget {
  const FaqSection({super.key});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FaqCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return faqCategories;
    return faqCategories
        .map((cat) {
          final filteredItems = cat.questions
              .where((faq) =>
                  faq.question
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ||
                  faq.answer
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()))
              .toList();
          return filteredItems.isEmpty
              ? null
              : FaqCategory(title: cat.title, questions: filteredItems);
        })
        .whereType<FaqCategory>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'FAQs',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Search Bar ──
          // Container(
          //   color: Colors.white,
          //   padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: const Color(0xFFF5F7FA),
          //       borderRadius: BorderRadius.circular(12.r),
          //     ),
          //     child: TextField(
          //       controller: _searchController,
          //       onChanged: (val) => setState(() => _searchQuery = val),
          //       style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          //       decoration: InputDecoration(
          //         hintText: 'Search questions...',
          //         hintStyle:
          //             TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
          //         prefixIcon: Icon(Icons.search,
          //             size: 20.sp, color: Colors.grey.shade400),
          //         suffixIcon: _searchQuery.isNotEmpty
          //             ? IconButton(
          //                 icon: Icon(Icons.close,
          //                     size: 18.sp, color: Colors.grey.shade400),
          //                 onPressed: () {
          //                   _searchController.clear();
          //                   setState(() => _searchQuery = '');
          //                 },
          //               )
          //             : null,
          //         border: InputBorder.none,
          //         contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          //       ),
          //     ),
          //   ),
          // ),

          Expanded(
            child: _filteredCategories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 48.sp, color: Colors.grey.shade300),
                        SizedBox(height: 12.h),
                        Text(
                          'No results found',
                          style: TextStyle(
                              fontSize: 15.sp, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    itemCount: _filteredCategories.length,
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemBuilder: (_, i) => FaqCategoryTile(
                      category: _filteredCategories[i],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Category Tile ────────────────────────────────────────────────────────────

class FaqCategoryTile extends StatefulWidget {
  final FaqCategory category;
  const FaqCategoryTile({super.key, required this.category});

  @override
  State<FaqCategoryTile> createState() => _FaqCategoryTileState();
}

class _FaqCategoryTileState extends State<FaqCategoryTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          // ── Header ──
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(14.r),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.prime.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.help_outline,
                        size: 18.sp, color: AppColors.prime),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      widget.category.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(Icons.keyboard_arrow_down,
                          size: 18.sp, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expandable Items ──
          SizeTransition(
            sizeFactor: _animation,
            child: Column(
              children: [
                Divider(height: 1, color: Colors.grey.shade100),
                ...widget.category.questions.map(
                  (faq) => _FaqItemTile(faq: faq),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── FAQ Item Tile ─────────────────────────────────────────────────────────────

class _FaqItemTile extends StatefulWidget {
  final FaqItem faq;
  const _FaqItemTile({required this.faq});

  @override
  State<_FaqItemTile> createState() => _FaqItemTileState();
}

class _FaqItemTileState extends State<_FaqItemTile>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isOpen = !_isOpen;
              _isOpen ? _controller.forward() : _controller.reverse();
            });
          },
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Icon(Icons.circle,
                      size: 6.sp, color: AppColors.prime),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    widget.faq.question,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(Icons.keyboard_arrow_down,
                      size: 18.sp, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          child: Container(
            margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.prime.withOpacity(0.04),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.prime.withOpacity(0.08)),
            ),
            child: Text(
              widget.faq.answer,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13.sp,
                height: 1.6,
              ),
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}
