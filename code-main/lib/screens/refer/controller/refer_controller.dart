// refer_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class ReferController extends GetxController {
  final String referCode = 'LEARN2025';
  final RxInt totalReferred = 0.obs;
  final RxInt coinsEarned = 0.obs;
  final RxBool codeCopied = false.obs;

  final List<Map<String, dynamic>> rewards = [
    {
      'referred': 1,
      'reward': '50 Coins',
      'icon': Icons.workspace_premium_rounded,
      'unlocked': false,
    },
    {
      'referred': 3,
      'reward': '1 Free Course',
      'icon': Icons.auto_stories_rounded,
      'unlocked': false,
    },
    {
      'referred': 5,
      'reward': 'Pro Badge',
      'icon': Icons.verified_rounded,
      'unlocked': false,
    },
    {
      'referred': 10,
      'reward': '1 Month Free',
      'icon': Icons.card_membership_rounded,
      'unlocked': false,
    },
  ];

  void copyCode() async {
    await Clipboard.setData(ClipboardData(text: referCode));
    codeCopied.value = true;
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 18),
          const SizedBox(width: 8),
          const Text(
            'Referral code copied!',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      borderRadius: 12,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      boxShadows: [
        BoxShadow(color: Colors.black12, blurRadius: 12, offset: const Offset(0, 4)),
      ],
    );
    Future.delayed(const Duration(seconds: 2), () => codeCopied.value = false);
  }

  void shareCode() {
    Get.snackbar('Share', 'Share functionality triggered');
  }
}