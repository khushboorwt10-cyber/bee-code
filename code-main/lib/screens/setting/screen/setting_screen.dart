import 'package:beecode/screens/call/screen/call_screen.dart';
import 'package:beecode/screens/setting/controller/setting_controller.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/widget/share_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  SettingsController get c {
    if (!Get.isRegistered<SettingsController>()) {
      return Get.put(SettingsController());
    }
    return Get.find<SettingsController>();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = c;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: _SettingsAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            _ProfileCard(ctrl: ctrl),
            SizedBox(height: 16.h),
            _SectionCard(
              title: 'Account',
              items: [
                _SettingsTile(
                  icon: Icons.lock_outline,
                  label: 'Change Password',
                  onTap: ctrl.changePassword,
                ),
                _SettingsTile(
                  icon: Icons.phone_outlined,
                  label: 'Update Phone Number',
                  trailing: Obx(() => Text(
                        ctrl.phone.value.isEmpty ? 'Not set' : ctrl.phone.value,
                        style: TextStyle(fontSize: 12.sp, color: Colors.black45),
                      )),
                  onTap: ctrl.showUpdatePhoneDialog,
                ),
                _SettingsTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  trailing: Obx(() => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(ctrl.email.value,
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black45)),
                          SizedBox(width: 4.w),
                          Icon(Icons.lock_outline,
                              size: 13.sp, color: Colors.black38),
                        ],
                      )),
                  showArrow: false,
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _SectionCard(
              title: 'Preferences',
              items: [
                // _SettingsToggleTile(
                //   icon: Icons.notifications_outlined,
                //   label: 'Push Notifications',
                //   value: ctrl.notificationsEnabled,
                //   onChanged: ctrl.toggleNotifications,
                // ),
                _SettingsToggleTile(
                  icon: Icons.wifi_outlined,
                  label: 'Download on Wi-Fi Only',
                  value: ctrl.downloadOnWifiOnly,
                  onChanged: ctrl.toggleWifiOnly,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _SectionCard(
              title: 'Support',
              items: [
                _SettingsTile(
                  icon: Icons.headset_mic_outlined,
                  label: 'Contact Support',
                  onTap: () => showSupportSheet(),
                ),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  label: 'Privacy Policy',
                  onTap: ctrl.openPrivacyPolicy,
                ),
                _SettingsTile(
                  icon: Icons.article_outlined,
                  label: 'Terms & Conditions',
                  onTap: ctrl.openTerms,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _SectionCard(
              title: 'App',
              items: [
                _SettingsTile(
                  icon: Icons.share_outlined,
                  label: 'Share App',
                  onTap: shareApp,
                ),
                _SettingsTile(
                  icon: Icons.info_outline,
                  label: 'App Version',
                  trailing: Text(ctrl.appVersion,
                      style:
                          TextStyle(fontSize: 12.sp, color: Colors.black45)),
                  showArrow: false,
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 20.h),
            _LogoutButton(ctrl: ctrl),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

class _SettingsAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      shadowColor: Colors.black12,
      leadingWidth: double.infinity,
      leading: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios,
                size: 20.sp, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
          Text('Settings',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
        ],
      ),
    );
  }
}
class _ProfileCard extends StatelessWidget {
  final SettingsController ctrl;
  const _ProfileCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [

              Stack(
                children: [
                  CircleAvatar(
                    radius: 28.r,
                    backgroundColor: AppColors.prime,
                    backgroundImage: ctrl.photoUrl.value.isNotEmpty
                        ? NetworkImage(ctrl.photoUrl.value)
                        : null,
                    child: ctrl.photoUrl.value.isEmpty
                        ? Text(
                            ctrl.avatarInitials.value,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : null,
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: ctrl.editProfile,
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: AppColors.prime,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Icon(Icons.camera_alt,
                            size: 11.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 14.w),

           
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ctrl.name.value,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      ctrl.email.value,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 12.sp, color: Colors.black45,),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: ctrl.editProfile,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.prime),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text('Edit',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.prime,
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _SectionCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
            child: Text(title.toUpperCase(),
                style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black38,
                    letterSpacing: 1.0)),
          ),
          ...List.generate(
            items.length,
            (i) => Column(children: [
              items[i],
              if (i < items.length - 1)
                Divider(height: 1, indent: 52.w, color: Colors.grey.shade100),
            ]),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}


class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool showArrow;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.prime.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: AppColors.prime, size: 18.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87))),
            if (trailing != null) ...[trailing!, SizedBox(width: 6.w)],
            if (showArrow)
              Icon(Icons.chevron_right, color: Colors.black26, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final RxBool value;
  final void Function(bool) onChanged;

  const _SettingsToggleTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.prime.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: AppColors.prime, size: 18.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87))),
          Obx(() => Switch.adaptive(
                value: value.value,
                onChanged: onChanged,
                activeColor: AppColors.prime,
              )),
        ],
      ),
    );
  }
}


class _LogoutButton extends StatelessWidget {
  final SettingsController ctrl;
  const _LogoutButton({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: ctrl.logout,
        child: Container(
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded,
                  color: Colors.red.shade600, size: 20.sp),
              SizedBox(width: 10.w),
              Text('Logout',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.red.shade600)),
            ],
          ),
        ),
      ),
    );
  }
}