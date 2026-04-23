import 'package:beecode/screens/subscription/model/subscription_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  final selectedPlan = 0.obs;
  final isLoading = false.obs;
  final productsLoading = false.obs;
  final purchaseSuccess = false.obs;

  SubscriptionPlanModel get currentPlan =>
      SubscriptionData.plans[selectedPlan.value];

  List<String> get currentFeatures => currentPlan.features;

  void selectPlan(int index) => selectedPlan.value = index;

  Future<void> buySubscription() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    purchaseSuccess.value = true;
    Get.snackbar(
      'Welcome to Pro!',
      'Your subscription is now active.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1A3BE8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> restorePurchases() async {
    isLoading.value = true;
    // TODO: restore from your backend
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.snackbar(
      'Restored',
      'Your purchases have been restored.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}