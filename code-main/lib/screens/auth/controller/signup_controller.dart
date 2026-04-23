// lib/screens/auth/controller/signup_controller.dart

import 'package:beecode/core/network/auth_dio_service.dart';
import 'package:beecode/screens/setting/controller/setting_controller.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final nameController     = TextEditingController();
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController  = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmHidden  = true.obs;
  final isLoading        = false.obs;
  final agreedToTerms    = false.obs;

  final formKey = GlobalKey<FormState>();

  final _authService = AuthDioService.instance;

  void togglePassword()        => isPasswordHidden.toggle();
  void toggleConfirmPassword() => isConfirmHidden.toggle();
  void toggleTerms()           => agreedToTerms.toggle();

  // ── Sign Up ────────────────────────────────────────────────────────────────
  Future<void> signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formKey.currentState!.validate()) return;

    if (!agreedToTerms.value) {
      Get.snackbar(
        'Terms Required',
        'Please agree to the Terms & Privacy Policy',
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16.w),
        borderRadius: 10.r,
      );
      return;
    }

    isLoading.value = true;
    try {
      final result = await _authService.signUp(
  nameController.text.trim(),
  emailController.text.trim(),
  passwordController.text,
  confirmController.text, 
);

      if (Get.isRegistered<SettingsController>()) {
        SettingsController.to.applyLocalUpdate(
          newName:  result.user.name,
          newEmail: result.user.email,
        );
      }

      Get.offAllNamed(Routes.home);
    } catch (errorMessage) {
      Get.snackbar(
        'Sign Up Failed',
        errorMessage.toString(),
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16.w),
        borderRadius: 10.r,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ── Google Sign-Up ─────────────────────────────────────────────────────────
  Future<void> signUpWithGoogle() async {
    isLoading.value = true;
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null) {
        if (Get.isRegistered<SettingsController>()) {
          SettingsController.to.applyLocalUpdate(
            newName:  result.user.name,
            newEmail: result.user.email,
          );
        }
        Get.offAllNamed(Routes.home);
      }
    } catch (e) {
      Get.snackbar(
        'Google Sign-In Failed',
        e.toString(),
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16.w),
        borderRadius: 10.r,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}
