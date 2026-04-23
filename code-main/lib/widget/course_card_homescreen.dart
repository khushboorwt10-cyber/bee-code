import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:beecode/screens/home/model/coures_model.dart';

class CourseCard extends StatefulWidget {
  final CourseCategoryCard category;
  final int index;
  final RxInt selectedIndex;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.category,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected =
          widget.selectedIndex.value == widget.index;
          
      return GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: EdgeInsets.zero, 
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
          transform: Matrix4.identity()
            ..scale(_isPressed ? 0.97 : 1.0),
          decoration: BoxDecoration(
            color: isSelected
                ? widget.category.gradient.first.withOpacity(0.08)
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? widget.category.gradient.first.withOpacity(0.5)
                  : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isPressed
                    ? widget.category.gradient.first.withOpacity(0.15)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isPressed ? 10 : 16,
                offset: Offset(0, _isPressed ? 3 : 6),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.category.gradient,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.category.icon,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),

              SizedBox(width: 10.w),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Text(
                      widget.category.courses,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      'Explore →',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 11.sp,
                        color: isSelected
                            ? widget.category.gradient.first
                            : widget.category.gradient.first
                                .withOpacity(0.7),
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
