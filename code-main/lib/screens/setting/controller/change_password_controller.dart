import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl     = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final isCurrentHidden  = true.obs;
  final isNewHidden      = true.obs;
  final isConfirmHidden  = true.obs;
  final isLoading        = false.obs;
  final passwordStrength = 0.obs;

  @override
  void onInit() {
    super.onInit();
    
    newPasswordCtrl.addListener(() {
      passwordStrength.value = _checkStrength(newPasswordCtrl.text);
    });
  }

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }

  void toggleCurrent() => isCurrentHidden.toggle();
  void toggleNew()     => isNewHidden.toggle();
  void toggleConfirm() => isConfirmHidden.toggle();

  Future<void> changePassword() async {
    final current = currentPasswordCtrl.text.trim();
    final newPass = newPasswordCtrl.text.trim();
    final confirm = confirmPasswordCtrl.text.trim();

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      _error('All fields are required');
      return;
    }
    if (newPass.length < 8) {
      _error('New password must be at least 8 characters');
      return;
    }
    if (newPass != confirm) {
      _error('Passwords do not match');
      return;
    }
    if (current == newPass) {
      _error('New password must be different from current');
      return;
    }

    isLoading.value = true;
    try {
      final user       = FirebaseAuth.instance.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: current,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPass);

      Get.back();
      Get.snackbar(
        'Password Updated ✅',
        'Your password has been changed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    } on FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'wrong-password'        => 'Current password is incorrect',
        'weak-password'         => 'New password is too weak',
        'requires-recent-login' => 'Please log out and log in again',
        _                       => e.message ?? 'Something went wrong',
      };
      _error(msg);
    } catch (_) {
      _error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }



  int _checkStrength(String p) {
    if (p.isEmpty) return 0;
    int score = 0;
    if (p.length >= 8)                                     score++;
    if (RegExp(r'[A-Z]').hasMatch(p))                      score++;
    if (RegExp(r'[0-9]').hasMatch(p))                      score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p))   score++;
    return score;
  }

  void _error(String msg) => Get.snackbar(
        'Error',
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
}