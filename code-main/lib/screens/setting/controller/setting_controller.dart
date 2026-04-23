import 'package:beecode/screens/auth/controller/auth_controller.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/local_storage.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find();

  AuthController get _auth => Get.find<AuthController>();

  final RxString name           = ''.obs;
  final RxString email          = ''.obs;
  final RxString phone          = ''.obs;
  final RxString avatarInitials = ''.obs;
  final RxString photoUrl       = ''.obs;

  final RxBool notificationsEnabled = true.obs;
  final RxBool emailUpdatesEnabled  = false.obs;
  final RxBool downloadOnWifiOnly   = true.obs;

  final String appVersion = '1.0.0';

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    // Re-sync whenever Firebase auth state changes (Google login / signup)
    ever(_auth.user, (_) => _loadUserData());
  }

  /// Public method — call this from anywhere to force a refresh.
  /// e.g. after login, signup, or returning from EditProfileScreen.
  Future<void> refreshData() => _loadUserData();

  /// Try Firebase first, fall back to local storage (email/password users)
  Future<void> _loadUserData() async {
    final firebaseUser = _auth.user.value;
    if (firebaseUser != null) {
      _syncFromFirebase();
    } else {
      await _syncFromLocal();
    }
  }

  void _syncFromFirebase() {
    final user = _auth.user.value;
    if (user == null) return;
    email.value          = user.email ?? '';
    phone.value          = user.phoneNumber ?? '';
    photoUrl.value       = user.photoURL ?? '';
    final displayName    = user.displayName?.trim() ?? '';
    name.value           = displayName.isNotEmpty
        ? displayName
        : _nameFromEmail(user.email);
    avatarInitials.value = _initials(name.value);
  }

  Future<void> _syncFromLocal() async {
    final data           = await LocalUserService.instance.getUser();
    name.value           = data['name']?.isNotEmpty == true
        ? data['name']!
        : _nameFromEmail(data['email']);
    email.value          = data['email'] ?? '';
    phone.value          = data['phone'] ?? '';
    photoUrl.value       = data['photoUrl'] ?? '';
    avatarInitials.value = _initials(name.value);
  }

  void toggleNotifications(bool v) => notificationsEnabled.value = v;
  void toggleWifiOnly(bool v)      => downloadOnWifiOnly.value   = v;

  void editProfile() => Get.toNamed('/editProfileScreen')
      ?.then((_) => refreshData());

  void changePassword() => Get.toNamed('/changePasswordScreen');

  void applyLocalUpdate({
    String? newName,
    String? newEmail,
    String? newPhone,
    String? newPhotoUrl,
  }) {
    if (newName != null && newName.isNotEmpty) {
      name.value           = newName;
      avatarInitials.value = _initials(newName);
      LocalUserService.instance.updateName(newName);
    }
    if (newEmail != null && newEmail.isNotEmpty) {
      email.value = newEmail;
    }
    if (newPhone != null) {
      phone.value = newPhone;
      LocalUserService.instance.updatePhone(newPhone);
    }
    if (newPhotoUrl != null) {
      photoUrl.value = newPhotoUrl;
      LocalUserService.instance.updatePhotoUrl(newPhotoUrl);
    }
  }

  void showUpdatePhoneDialog() {
    final ctrl    = TextEditingController(text: phone.value);
    final formKey = GlobalKey<FormState>();

    Get.bottomSheet(
      Padding(
        padding: EdgeInsets.only(
          bottom: WidgetsBinding
              .instance.platformDispatcher.views.first.viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.prime.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.phone_outlined,
                          size: 20, color: AppColors.prime),
                    ),
                    const SizedBox(width: 12),
                    const Text('Update Phone Number',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: ctrl,
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone_outlined,
                        color: AppColors.prime, size: 20),
                    hintText: '+91 XXXXX XXXXX',
                    hintStyle: const TextStyle(color: Colors.black38),
                    counterText: '',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.prime, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Phone number cannot be empty';
                    }
                    if (v.trim().length < 10) return 'Enter a valid phone number';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            applyLocalUpdate(newPhone: ctrl.text.trim());
                            Get.back();
                            _success('Phone number updated');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Save',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }

  void openPrivacyPolicy() {
    Get.toNamed(Routes.privacyPolicyScreen);
  }
  void openTerms()         {
     Get.toNamed(Routes.termsConditionScreen);
    
  }

  // void shareApp() {
  //   SharePlus.instance.share(
  //     ShareParams(
  //       text:
  //           '🐝 Learn coding with BeeCode!\n\nDownload now:\nhttps://play.google.com/store/apps/details?id=com.beecode.app',
  //       subject: 'Check out BeeCode!',
  //     ),
  //   );
  // }
  void logout() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Logout',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,

      onConfirm: () async {
        Get.back(); // close dialog

        try {
          // 1. clear local storage (SharedPreferences / custom storage)
          await LocalUserService.instance.clear();

          // 2. firebase / backend logout (if used)
          await _auth.signOut();

          // 3. navigate to login screen and clear stack
          Get.offAllNamed(Routes.loginScreen);

        } catch (e) {
          Get.snackbar(
            "Error",
            "Logout failed",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }

  void _success(String msg) => Get.snackbar('Saved', msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16));

  String _initials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  String _nameFromEmail(String? email) {
    if (email == null || email.isEmpty) return 'User';
    return email
        .split('@')
        .first
        .replaceAll(RegExp(r'[._]'), ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}