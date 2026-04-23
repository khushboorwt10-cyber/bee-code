import 'package:beecode/screens/profile/model/terms_condition_model.dart';
import 'package:beecode/screens/profile/repository/terms_condition_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


enum TermsLoadState { idle, loading, success, error }

class TermsConditionViewModel extends GetxController {
  final TermsConditionRepository _repository;

  TermsConditionViewModel({TermsConditionRepository? repository})
      : _repository = repository ?? TermsConditionRepository();

  // ── State ──────────────────────────────────
  final Rx<TermsLoadState> loadState = TermsLoadState.idle.obs;
  final Rx<TermsConditionModel?> terms = Rx(null);
  final RxString errorMessage = ''.obs;

  // ── UI State ───────────────────────────────
  final RxInt expandedIndex = (-1).obs;
  final RxDouble scrollProgress = 0.0.obs;
  final RxBool hasReadTerms = false.obs;
  final RxBool emailCopied = false.obs;

  // ── Derived Getters ────────────────────────
  bool get isLoading => loadState.value == TermsLoadState.loading;
  bool get hasError => loadState.value == TermsLoadState.error;
  bool get hasData => loadState.value == TermsLoadState.success;

  List<TermsSection> get sections => terms.value?.sections ?? [];
  String get lastUpdated => terms.value?.lastUpdated ?? '';
  String get version => terms.value?.version ?? '';
  String get contactEmail => terms.value?.contactEmail ?? '';
  int get totalSections => sections.length;

  // ── Theme Color ────────────────────────────
  static const Color primary = Color(0xFF1565C0);
  static const Color secondary = Color(0xFF1E88E5);

  // ── Lifecycle ──────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadTerms();
  }

  // ── Commands ───────────────────────────────
  Future<void> loadTerms() async {
    try {
      loadState.value = TermsLoadState.loading;
      terms.value = await _repository.fetchTerms();
      loadState.value = TermsLoadState.success;
    } catch (e) {
      errorMessage.value = 'Failed to load terms. Please try again.';
      loadState.value = TermsLoadState.error;
    }
  }

  void toggleSection(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  void onScroll(double offset, double maxExtent) {
    if (maxExtent <= 0) return;
    final progress = (offset / maxExtent).clamp(0.0, 1.0);
    scrollProgress.value = progress;
    if (progress >= 0.95 && !hasReadTerms.value) {
      hasReadTerms.value = true;
    }
  }

  Future<void> copyEmail() async {
    await Clipboard.setData(ClipboardData(text: contactEmail));
    emailCopied.value = true;
    _showSnackbar(
      icon: Icons.check_circle_rounded,
      iconColor: Colors.green.shade600,
      message: 'Email address copied!',
    );
    Future.delayed(const Duration(seconds: 2), () => emailCopied.value = false);
  }

  void shareTerms() {
    _showSnackbar(
      icon: Icons.ios_share_rounded,
      iconColor: primary,
      message: 'Share triggered!',
    );
  }

  void acceptTerms() {
    Get.back();
    _showSnackbar(
      icon: Icons.verified_rounded,
      iconColor: primary,
      message: 'Terms & Conditions accepted!',
    );
  }

  void retryLoad() => loadTerms();

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