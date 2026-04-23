import 'package:beecode/screens/profile/model/profile_model.dart';
import 'package:beecode/screens/profile/viewmodel/profile_viewmodel.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  ProfileViewModel get vm => Get.find<ProfileViewModel>();

  static const _bg = Color(0xFFF0F4F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Profile & settings',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Obx(() {
        if (vm.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(vm.error.value,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.prime)),
                SizedBox(height: 12.h),
                ElevatedButton(
                    onPressed: vm.loadProfile, child: const Text('Retry')),
              ],
            ),
          );
        }

        final p = vm.profile.value!;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _card([_userHeader(p)]),
              SizedBox(height: 12.h),

              _card([
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My library',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      SizedBox(height: 14.h),
                      _libraryGrid(),
                    ],
                  ),
                ),
              ]),
              SizedBox(height: 12.h),

              _referralCard(),
              SizedBox(height: 12.h),

              SizedBox(height: 12.h),
              _card([_statsSection(p.stats)]),

              SizedBox(height: 20.h),
              Center(
                child: Text(
                  p.appVersion,
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _userHeader(ProfileModel p) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundColor: Colors.grey.shade400,
                backgroundImage:
                    p.photoUrl != null ? NetworkImage(p.photoUrl!) : null,
                child: p.photoUrl == null
                    ? Icon(Icons.person, size: 32.sp, color: Colors.white)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.auto_awesome,
                      size: 14.sp, color: Colors.amber),
                ),
              ),
            ],
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name,
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                SizedBox(height: 2.h),
                Text(p.email,
                    style: TextStyle(
                        fontSize: 13.sp, color: Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _libraryGrid() {
    final items = [
      _LibraryItem(Icons.play_circle_outline, 'Enrollments', Colors.teal,
          onTap: () => Get.toNamed('/enrollmentScreen')),
      _LibraryItem(Icons.download_outlined, 'Downloads', Colors.purple,
          onTap: () => Get.toNamed('/downloadScreen')),
      _LibraryItem(Icons.notifications_outlined, 'Updates', Colors.green,
          onTap: () => Get.toNamed('/notificationScreen')),
      _LibraryItem(Icons.help_outline, 'FAQs', Colors.lightBlue,
          onTap: () => Get.toNamed(Routes.faqSection)),
      // ✅ Refresh profile when returning from Settings
      _LibraryItem(Icons.settings_outlined, 'Settings', Colors.grey,
          onTap: () => Get.toNamed('/settingsScreen')
              ?.then((_) => vm.loadProfile())),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10.h,
      crossAxisSpacing: 10.w,
      childAspectRatio: 2.8,
      children: [
        ...items.map((item) => GestureDetector(
              onTap: item.onTap,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Icon(item.icon, size: 20.sp, color: item.color),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(item.label,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87)),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _referralCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Refer friends to win vouchers and Plus Subscription',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5D3A00),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'For every successful referral win up to ₹2,500. Also get 1 month plus subscription once',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.referScreen);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D2000),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Refer a friend',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.card_giftcard,
                size: 40.sp, color: const Color(0xFFF59E0B)),
          ),
        ],
      ),
    );
  }

  Widget _statsSection(StatsModel stats) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Stats',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Text('ALL TIME',
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5)),
            ],
          ),
          SizedBox(height: 12.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 2.2,
            children: [
              _statTile('TOTAL WATCH MINS', stats.totalWatchMins,
                  Icons.play_lesson, Colors.blue.shade100, Colors.blue),
              _statTile('LESSONS COMPLETED', stats.lessonsCompleted,
                  Icons.play_arrow, Colors.grey.shade200, Colors.grey),
              _statTile('QUESTIONS ATTEMPTED', stats.questionsAttempted,
                  Icons.help_outline, Colors.green.shade100, Colors.green),
              _statTile('TESTS ATTEMPTED', stats.testsAttempted,
                  Icons.check_circle_outline,
                  Colors.lightBlue.shade100, Colors.lightBlue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statTile(String label, int value, IconData icon,
      Color bgColor, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, size: 18.sp, color: iconColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      clipBehavior: Clip.hardEdge,
      child: Column(children: children),
    );
  }
}

class _LibraryItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _LibraryItem(this.icon, this.label, this.color, {required this.onTap});
}