import 'dart:io';

import 'package:beecode/screens/auth/controller/auth_controller.dart';
import 'package:beecode/screens/profile/model/profile_model.dart';
import 'package:beecode/screens/profile/repository/profile_repository.dart';
import 'package:get/get.dart';

class ProfileViewModel extends GetxController {
  final ProfileRepository _repository;

  ProfileViewModel({ProfileRepository? repository})
      : _repository = repository ?? ProfileRepository();

  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxBool   isLoading        = true.obs;
  final RxBool   isUploadingPhoto = false.obs;
  final RxString error            = ''.obs;
  final Rx<File?> localPhoto      = Rx<File?>(null);
  final RxSet<String> _expanded   = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();

    // ✅ Re-fetch profile whenever the Firebase auth user changes
    // (fires on login, signup, Google sign-in, and logout)
    ever(Get.find<AuthController>().user, (_) => loadProfile());
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    error.value = '';
    try {
      profile.value = await _repository.fetchProfile();
    } catch (e) {
      error.value = 'Failed to load profile. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  bool isExpanded(String id) => _expanded.contains(id);

  void toggleExpanded(String id) {
    _expanded.contains(id) ? _expanded.remove(id) : _expanded.add(id);
  }

  void logout() async {
    await Get.find<AuthController>().signOut();
  }
}