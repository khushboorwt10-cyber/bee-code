import 'package:beecode/bottom_nav/controller/bottom_controller.dart';
import 'package:beecode/bottom_nav/screen/bottom_screen.dart';
import 'package:beecode/screens/courses/screen/courses_screen.dart';
import 'package:beecode/screens/home/screen/home_screen.dart';
import 'package:beecode/screens/my_programs/screen/my_programs_screen.dart';
import 'package:beecode/screens/beebites/screen/beebites_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final List<Widget> _pages = [
    HomeScreen(),
    MyProgramsPage(),
    CoursesScreen(),
    BeeBitesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (controller.selectedIndex.value == 0) {
          SystemNavigator.pop();
        } else {
          controller.changeTab(0);
        }
      },
      child: Scaffold(
          extendBody: true,
        body: Obx(() => _pages[controller.selectedIndex.value]),
        bottomNavigationBar: const AppBottomNavBar(),
      ),
    );
  }
}