// lib/screens/auth/controller/login_controller.dart

import 'package:beecode/core/network/auth_dio_service.dart';
import 'package:beecode/screens/setting/controller/setting_controller.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isLoading        = false.obs;
  final formKey          = GlobalKey<FormState>();

  final _authService = AuthDioService.instance;

  void togglePassword() => isPasswordHidden.toggle();

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final result = await _authService.login(
        emailController.text.trim(),
        passwordController.text,
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
        'Login Failed',
        errorMessage.toString(),
        backgroundColor: AppColors.prime,
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

  Future<void> loginWithGoogle() async {
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
        backgroundColor: AppColors.prime,
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

  Future<void> forgotPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar(
        'Email Required',
        'Enter your email above to reset your password.',
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16.w),
        borderRadius: 10.r,
      );
      return;
    }
    // TODO: wire up to /auth/forgot-password endpoint when ready
    Get.snackbar(
      'Coming Soon',
      'Password reset will be available once the API is connected.',
      backgroundColor: Colors.blue.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(16.w),
      borderRadius: 10.r,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
