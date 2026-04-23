import 'package:beecode/bottom_nav/controller/bottom_controller.dart';
import 'package:beecode/screens/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:beecode/screens/utils/route.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  static final double _fabSize = 80.sp; 
  static final double _barHeight = 70.h;
  static final double _notchMargin = 3.sp;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    final bottomInset = MediaQuery.of(context).padding.bottom;
    final totalHeight = (_fabSize / 2) + _barHeight + bottomInset;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: _barHeight + bottomInset,
            child: CustomPaint(
              painter: _NotchedBarPainter(
                fabSize: _fabSize,
                notchMargin: _notchMargin,
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Row(
                  children: [
                    _NavItem(
                        index: 0,
                        label: 'Explore',
                        icon: Icons.explore,
                        controller: controller),
                    _NavItem(
                        index: 1,
                        label: 'My Programs',
                        icon: Icons.library_books_outlined,
                        controller: controller),
                    SizedBox(width: _fabSize),

                    _NavItem(
                        index: 2,
                        label: 'Courses',
                        icon: Icons.menu_book_outlined,
                        controller: controller),
                    _NavItem(
                        index: 3,
                        label: 'BeeBites',
                        icon: Icons.calendar_view_month_outlined,
                        controller: controller),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: 10,
            // bottom: (_barHeight / 2) + bottomInset - (_fabSize / 2),
            child: Center(
              child: GestureDetector(
                onTap: () => Get.toNamed(Routes.aiChatScreen),
                child: Container(
                  height: _fabSize,
                  width: _fabSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black.withOpacity(0.25),
                    //     blurRadius: 15,
                    //     offset: const Offset(0, 6),
                    //   ),
                    // ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_fabSize),
                    child: Image.asset(
                      AppImages.beebitesicon,
                      fit: BoxFit.cover,
                    ),
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

class _NotchedBarPainter extends CustomPainter {
  const _NotchedBarPainter({
    required this.fabSize,
    required this.notchMargin,
  });

  final double fabSize;
  final double notchMargin;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final fabR = (fabSize / 2.6) + notchMargin;

    const cornerR = 8.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(cx - fabR - cornerR, 0)
      ..quadraticBezierTo(cx - fabR, 0, cx - fabR, cornerR)
      ..arcToPoint(
        Offset(cx + fabR, cornerR),
        radius: Radius.circular(fabR),
        clockwise: false,
      )
      ..quadraticBezierTo(cx + fabR, 0, cx + fabR + cornerR, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    final borderPath = Path()
      ..moveTo(0, 0)
      ..lineTo(cx - fabR - cornerR, 0)
      ..quadraticBezierTo(cx - fabR, 0, cx - fabR, cornerR)
      ..arcToPoint(
        Offset(cx + fabR, cornerR),
        radius: Radius.circular(fabR),
        clockwise: false,
      )
      ..quadraticBezierTo(cx + fabR, 0, cx + fabR + cornerR, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(
      borderPath,
      Paint()
        ..color = Colors.grey.shade300
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.controller,
  });

  final int index;
  final String label;
  final IconData icon;
  final BottomNavController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedIndex.value == index;

        return GestureDetector(
          onTap: () => controller.changeTab(index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24.sp,
                color: isSelected ? Colors.black : Colors.grey.shade500,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color:
                      isSelected ? Colors.black : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
