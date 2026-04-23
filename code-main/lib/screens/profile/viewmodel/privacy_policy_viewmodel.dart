import 'package:beecode/screens/profile/model/privacy_policy_model.dart';
import 'package:beecode/screens/profile/repository/privacy_policy_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


enum PolicyLoadState { idle, loading, success, error }

class PrivacyPolicyViewModel extends GetxController {
  final PrivacyPolicyRepository _repository;

  PrivacyPolicyViewModel({PrivacyPolicyRepository? repository})
      : _repository = repository ?? PrivacyPolicyRepository();

  // ── State ──────────────────────────────────
  final Rx<PolicyLoadState> loadState = PolicyLoadState.idle.obs;
  final Rx<PrivacyPolicyModel?> policy = Rx(null);
  final RxString errorMessage = ''.obs;

  // ── UI State ───────────────────────────────
  final RxInt expandedIndex = (-1).obs;
  final RxDouble scrollProgress = 0.0.obs;
  final RxBool hasReadPolicy = false.obs;
  final RxBool codeCopied = false.obs;

  // ── Derived getters ────────────────────────
  bool get isLoading => loadState.value == PolicyLoadState.loading;
  bool get hasError => loadState.value == PolicyLoadState.error;
  bool get hasData => loadState.value == PolicyLoadState.success;

  List<PrivacyPolicySection> get sections => policy.value?.sections ?? [];
  String get lastUpdated => policy.value?.lastUpdated ?? '';
  String get version => policy.value?.version ?? '';
  String get contactEmail => policy.value?.contactEmail ?? '';
  int get totalSections => sections.length;

  // ── Lifecycle ──────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadPolicy();
  }

  // ── Commands ───────────────────────────────
  Future<void> loadPolicy() async {
    try {
      loadState.value = PolicyLoadState.loading;
      policy.value = await _repository.fetchPolicy();
      loadState.value = PolicyLoadState.success;
    } catch (e) {
      errorMessage.value = 'Failed to load privacy policy. Please try again.';
      loadState.value = PolicyLoadState.error;
    }
  }

  void toggleSection(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  void expandAll() {
    // Not a real expand-all (accordion), just a helper to reset
    expandedIndex.value = -1;
  }

  void onScroll(double offset, double maxExtent) {
    if (maxExtent <= 0) return;
    final progress = (offset / maxExtent).clamp(0.0, 1.0);
    scrollProgress.value = progress;
    if (progress >= 0.95 && !hasReadPolicy.value) {
      hasReadPolicy.value = true;
    }
  }

  Future<void> copyEmail() async {
    await Clipboard.setData(ClipboardData(text: contactEmail));
    codeCopied.value = true;
    _showSnackbar(
      icon: Icons.check_circle_rounded,
      iconColor: Colors.green.shade600,
      message: 'Email address copied!',
    );
    Future.delayed(const Duration(seconds: 2), () => codeCopied.value = false);
  }

  void sharePolicy() {
    // Share.share('Read our Privacy Policy at https://learnapp.com/privacy');
    _showSnackbar(
      icon: Icons.ios_share_rounded,
      iconColor: const Color(0xFF6C63FF),
      message: 'Share triggered!',
    );
  }

  void acceptPolicy() {
    Get.back();
    _showSnackbar(
      icon: Icons.verified_rounded,
      iconColor: const Color(0xFF6C63FF),
      message: 'Privacy Policy accepted!',
    );
  }

  void retryLoad() => loadPolicy();

  // ── Private helpers ────────────────────────
  void _showSnackbar({
    required IconData icon,
    required Color iconColor,
    required String message,
  }) {
    Get.snackbar(
      '', '',
      titleText: const SizedBox.shrink(),
      messageText: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 8),
          Text(message,
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.w600)),
        ],
      ),
      backgroundColor: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      borderRadius: 12,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      boxShadows: [
        const BoxShadow(
            color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
      ],
    );
  }
}