import 'dart:async';

import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar({super.key});

  @override
  State<AnimatedSearchBar> createState() => AnimatedSearchBarState();
}

class AnimatedSearchBarState extends State<AnimatedSearchBar> {
  final List<String> _words = [
    'Flutter',
    'Python',
    'UI Design',
    'JavaScript',
    "AI/ML"
  ];

  int _wordIndex = 0;
  String _displayed = '';
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer?.cancel(); 
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      
      if (!mounted) {
        _timer?.cancel();
        return;
      }

      final target = _words[_wordIndex];

      if (!_isDeleting) {
        if (_displayed.length < target.length) {
          setState(() {
            _displayed = target.substring(0, _displayed.length + 1);
          });
        } else {
          
          _timer?.cancel();
          Future.delayed(const Duration(milliseconds: 1000), () {
          
            if (!mounted) return;
            setState(() => _isDeleting = true);
            _startTyping();
          });
        }
      } else {
        if (_displayed.isNotEmpty) {
          setState(() {
            _displayed = _displayed.substring(0, _displayed.length - 1);
          });
        } else {
          
          setState(() {
            _isDeleting = false;
            _wordIndex = (_wordIndex + 1) % _words.length;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 14.h),
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.search),
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.black, size: 20.sp),
              SizedBox(width: 10.w),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Search for ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 14.sp,
                      ),
                    ),
                    TextSpan(
                      text: _displayed,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.prime,
                        fontSize: 14.sp,
                      ),
                    ),
                    TextSpan(
                      text: '|',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}