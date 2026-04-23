import 'package:beecode/bottom_nav/controller/bottom_controller.dart';
import 'package:beecode/screens/auth/controller/auth_controller.dart';
import 'package:beecode/screens/auth/firebase/firebase_service.dart';
import 'package:beecode/core/service/auth_service.dart';
import 'package:beecode/screens/home/controller/home_controller.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:beecode/widget/recent_courses_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

final RxString _currentRoute = ''.obs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.instance.initialize();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  Get.put(AuthController(), permanent: true);
  Get.put(HomeController(), permanent: true);
  Get.put(BottomNavController(), permanent: true);
  await Get.putAsync(() async => RecentCoursesService());

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  ));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AuthService.instance.isLoggedIn;
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BeeCode',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
            ),
          ),
          initialRoute: isLoggedIn ? Routes.home : Routes.loginScreen,
          getPages: AppPages.routes,
          routingCallback: (routing) {
            if (routing?.current != null) {
              _currentRoute.value = routing!.current;
            }
          },
        );
      },
    );
  }
}

// ignore: unused_element
class _GlobalFabWrapper extends StatelessWidget {
  final Widget child;
  const _GlobalFabWrapper({required this.child});
static const _hiddenRoutes = {
  Routes.loginScreen,
  Routes.signUpScreen,
  Routes.subscriptionScreen,
  Routes.aiChatScreen,
  Routes.beeBitesScreen,
};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        Obx(() {
         final hidden = _hiddenRoutes.contains(_currentRoute.value)
    || _currentRoute.value.isEmpty;

if (hidden) return const SizedBox.shrink();

          return Positioned(
            bottom: 90.h,
            right: 16.w,
            child: const _GlobalFab(),
          );
        }),
      ],
    );
  }
}

class _GlobalFab extends StatelessWidget {
  const _GlobalFab();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.aiChatScreen),
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:  Colors.white.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          Icons.auto_awesome,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }
}