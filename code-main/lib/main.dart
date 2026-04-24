import 'package:beecode/bottom_nav/controller/bottom_controller.dart';
import 'package:beecode/screens/auth/controller/auth_controller.dart';
import 'package:beecode/screens/auth/firebase/firebase_service.dart';
import 'package:beecode/screens/auth/screen/Local_Storage.dart';
import 'package:beecode/screens/home/controller/home_controller.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:beecode/widget/recent_courses_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorage.init();
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

    // ✅ SAFE LOGIN CHECK (SharedPreferences based)
    final token = LocalStorage.getString('token');
    final isLoggedIn = token != null && token.isNotEmpty;

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

          // 🔥 AUTH ROUTING FIXED
          initialRoute: isLoggedIn
              ? Routes.home
              : Routes.loginScreen,

          getPages: AppPages.routes,
        );
      },
    );
  }
}
class _GlobalFabWrapper extends StatelessWidget {
  final Widget child;
  const _GlobalFabWrapper({required this.child});

  static const Set<String> _hiddenRoutes = {
    Routes.loginScreen,
    Routes.signUpScreen,
    Routes.subscriptionScreen,
    Routes.aiChatScreen,
    Routes.beeBitesScreen,
  };

  @override
  Widget build(BuildContext context) {
    final route = Get.currentRoute;

    final hidden = _hiddenRoutes.contains(route) || route.isEmpty;

    return Stack(
      children: [
        child,

        if (!hidden)
          Positioned(
            bottom: 90.h,
            right: 16.w,
            child: const _GlobalFab(),
          ),
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
              color: Colors.black.withOpacity(0.15),
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