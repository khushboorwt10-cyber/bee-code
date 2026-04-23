import 'package:beecode/screens/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class TabSwitcher extends StatelessWidget {
  final bool isLogin;
  const TabSwitcher({super.key, this.isLogin = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Log In tab
          Expanded(
            child: GestureDetector(
              onTap: isLogin ? null : () => Get.offNamed(Routes.loginScreen),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isLogin ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9.r),
                  boxShadow: isLogin
                      ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isLogin ? FontWeight.w700 : FontWeight.w500,
                    color: isLogin ? const Color(0xFF111111) : const Color(0xFF999999),
                  ),
                ),
              ),
            ),
          ),
          // Sign Up tab
          Expanded(
            child: GestureDetector(
              onTap: isLogin ? () => Get.offNamed(Routes.signUpScreen) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: !isLogin ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9.r),
                  boxShadow: !isLogin
                      ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: !isLogin ? FontWeight.w700 : FontWeight.w500,
                    color: !isLogin ? const Color(0xFF111111) : const Color(0xFF999999),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}