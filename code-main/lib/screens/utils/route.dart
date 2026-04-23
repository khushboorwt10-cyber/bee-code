import 'package:beecode/bottom_nav/screen/main_bottom.dart';
import 'package:beecode/screens/ai/binding/ai_binding.dart';
import 'package:beecode/screens/ai/screen/ai_screen.dart';
import 'package:beecode/screens/aiml/binding/aiml_binding.dart';
import 'package:beecode/screens/aiml/screen/aiml_screen.dart';
import 'package:beecode/screens/auth/screen/login.dart';
import 'package:beecode/screens/auth/screen/signup.dart';
import 'package:beecode/screens/beebites/screen/beebites_screen.dart';
import 'package:beecode/screens/courses/binding/courses_binding.dart';
import 'package:beecode/screens/courses/screen/courses_screen.dart';
import 'package:beecode/screens/data_science/screen/data_science_screen.dart';
import 'package:beecode/screens/doctorate/binding/doctorate_binding.dart';
import 'package:beecode/screens/doctorate/screen/doctorate_courses_screen.dart';
import 'package:beecode/screens/download/screen/download_screen.dart';
import 'package:beecode/screens/enrollment/screen/enroillment_screen.dart';
import 'package:beecode/screens/faqs/screen/faqs_screen.dart';
import 'package:beecode/screens/home/screen/details_screen.dart';
import 'package:beecode/screens/home/screen/course_detail_screen.dart';
import 'package:beecode/screens/home/screen/section_lessons_screen.dart';
import 'package:beecode/screens/industry_certification/screen/industry_certification_screen.dart';
import 'package:beecode/screens/mba/binding/mba_binding.dart';
import 'package:beecode/screens/mba/screen/mba_screen.dart';
import 'package:beecode/screens/my_programs/screen/my_programs_screen.dart';
import 'package:beecode/screens/profile/binding/privacy_policy_binding.dart';
import 'package:beecode/screens/profile/binding/profile_binding.dart';
import 'package:beecode/screens/profile/binding/terms_condition_binding.dart';
import 'package:beecode/screens/profile/screen/privacy_policy_screen.dart';
import 'package:beecode/screens/profile/screen/profile_screen.dart';
import 'package:beecode/screens/profile/screen/terms_condition_screen.dart';
import 'package:beecode/screens/refer/screen/refer_screen.dart';
import 'package:beecode/screens/search/screen/search_screen.dart';
import 'package:beecode/screens/promotion/screen/promotion_screen.dart';
import 'package:beecode/screens/setting/binding/edit_profile_binding.dart';
import 'package:beecode/screens/setting/binding/seting_binding.dart';
import 'package:beecode/screens/setting/screen/change_password_screen.dart';
import 'package:beecode/screens/setting/screen/edit_profile_screen.dart';
import 'package:beecode/screens/setting/screen/setting_screen.dart';
import 'package:beecode/screens/subscription/binding/subscription_binding.dart';
import 'package:beecode/screens/subscription/screen/subscription_screen.dart';
import 'package:beecode/screens/updates/screen/updates_screen.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../home/controller/details_controller.dart';

class Routes {
  Routes._();
  static const String home = '/';
  static const String search = '/search';
  static const String promotion = '/promotion';
  static const String industryCertification = '/industryCertification';
  static const String dataScienceScreen = '/dataScienceScreen';
  static const String doctorateScreen = '/doctorateScreen';
  static const String aiCoursesScreen = '/aiCoursesScreen';
  static const String mbaCoursesScreen = '/mbaCoursesScreen';
  static const String loginScreen = '/loginScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String detailsScreen = '/detailsScreen';
  static const String profileScreen = '/profileScreen';
  static const String faqSection = '/faqSection';
  static const String enrollmentScreen = '/enrollmentScreen';
  static const String notificationScreen = '/notificationScreen';
  static const String downloadScreen = '/downloadScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String editProfileScreen = '/editProfileScreen';
   static const String changePasswordScreen = '/changePasswordScreen';
   static const String courseDetailScreen = '/courseDetailScreen';
   static const String subscriptionScreen = '/subscriptionScreen';
   static const String myProgramsPage = '/myProgramsPage';
   static const String coursesScreen = '/coursesScreen';
   static const String sectionLessonsScreen = '/sectionLessonsScreen';
   static const String aiChatScreen = '/aiChatScreen';
   static const String beeBitesScreen = '/beeBitesScreen';
   static const String referScreen = '/referScreen';
   static const String privacyPolicyScreen = '/privacyPolicyScreen';
   static const String termsConditionScreen = '/termsConditionScreen';
   
}

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const MainScreen(),
    ),
    GetPage(
      name: Routes.search,
      page: () => SearchScreen(),
    ),
    GetPage(
      name: Routes.promotion,
      page: () => PromotionScreen(),
    ),
    GetPage(
      name: Routes.industryCertification,
      page: () => IndustryCertificationScreen(),
    ),
    GetPage(
      name: Routes.dataScienceScreen,
      page: () => DataScienceScreen(),
    ),
    GetPage(
      name: Routes.doctorateScreen,
      page: () => DoctorateScreen(),
      binding: DoctorateBinding(),
    ),
    GetPage(
      name: Routes.aiCoursesScreen,
      page: () => AiCoursesScreen(),
      binding: AiCoursesBinding(),
    ),
    GetPage(
      name: Routes.mbaCoursesScreen,
      page: () => MbaCoursesScreen(),
      binding: MbaCoursesBinding(),
    ),
     GetPage(
      name: Routes.loginScreen,
      page: () => LoginScreen(),
    ),
     GetPage(
      name: Routes.signUpScreen,
      page: () => SignupScreen(),
    ),
    GetPage(
      name: Routes.detailsScreen,
      page: () => const DetailsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DetailsController>(() => DetailsController());
      }),
    ),
      GetPage(
      name: Routes.profileScreen,
      page: () => ProfileScreen(),
       binding: ProfileBinding()
    ),
     GetPage(
      name: Routes.faqSection,
      page: () => FaqSection(),
    ),
     GetPage(
      name: Routes.enrollmentScreen,
      page: () => EnrollmentScreen(),
    ),
       GetPage(
      name: Routes.notificationScreen,
      page: () => NotificationScreen(),
    ),
    GetPage(
      name: Routes.downloadScreen,
      page: () => DownloadScreen(),
    ),
     GetPage(
      name: Routes.settingsScreen,
      page: () => SettingsScreen(),
      binding: SettingsBinding()
    ),
    GetPage(
      name: Routes.editProfileScreen,
      page: () => EditProfileScreen(),
      binding: EditProfileBinding()
    ),
      GetPage(
      name: Routes.changePasswordScreen,
      page: () => ChangePasswordScreen(),
      // binding: EditProfileBinding()
    ),
    GetPage(
      name: Routes.courseDetailScreen,
      page: () => CourseDetailScreen(),
      // binding: EditProfileBinding()
    ),
   GetPage(
  name: Routes.subscriptionScreen,
  page: () => const SubscriptionScreen(),
  binding:  SubscriptionBinding(),
),
GetPage(
      name: Routes.myProgramsPage,
      page: () => MyProgramsPage(),
      // binding: EditProfileBinding()
    ),
    GetPage(
  name: Routes.coursesScreen,
  page: () => CoursesScreen(),
   binding: CoursesBinding()
),
 GetPage(
  name: Routes.sectionLessonsScreen,
  page: () => SectionLessonsScreen(),
  //  binding: ()
),
 GetPage(
  name: Routes.aiChatScreen,
  page: () => AiChatScreen(),
   binding: AiChatBinding()
),
GetPage(
  name: Routes.beeBitesScreen,
  page: () => BeeBitesScreen(),
  //  binding: AiChatBinding()
),
GetPage(
  name: Routes.referScreen,
  page: () => ReferScreen(),
  //  binding: AiChatBinding()
),
GetPage(
  name: Routes.privacyPolicyScreen,
  page: () => const PrivacyPolicyScreen(),
  binding: PrivacyPolicyBinding(),
),
GetPage(
  name: Routes.termsConditionScreen,
  page: () => const TermsConditionScreen(),
  binding: TermsConditionBinding(),
),
  ];
}