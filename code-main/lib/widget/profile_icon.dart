import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderIconButton extends StatelessWidget {
   final IconData icon;
  final bool isHome;
  final VoidCallback? onTap;        // ← add this

  const HeaderIconButton({
    super.key,
    required this.icon,
    this.isHome = false,
    this.onTap,                     // ← add this
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: isHome
              ? Colors.white.withOpacity(0.2)   
              : Colors.grey.shade100,           
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isHome ? Colors.white : Colors.black87,  
          size: 18.sp,
        ),
      ),
    );
  }
}