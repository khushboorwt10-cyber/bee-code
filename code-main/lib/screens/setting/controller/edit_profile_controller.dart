import 'dart:io';

import 'package:beecode/screens/auth/controller/auth_controller.dart';
import 'package:beecode/screens/setting/controller/setting_controller.dart';
import 'package:beecode/screens/utils/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  AuthController get _auth => Get.find<AuthController>();

  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController phoneCtrl;

  final RxBool    isSaving       = false.obs;
  final RxString  avatarInitials = ''.obs;
  final RxString  photoUrl       = ''.obs;
  final Rx<File?> localPhoto     = Rx<File?>(null);

  bool _isLocalUser = false;
  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    nameCtrl  = TextEditingController();
    emailCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final firebaseUser = _auth.user.value;
    final settings = Get.isRegistered<SettingsController>()
        ? SettingsController.to
        : null;

    if (firebaseUser != null) {
      _isLocalUser = false;
      nameCtrl.text  = settings?.name.value.isNotEmpty == true
          ? settings!.name.value
          : (firebaseUser.displayName ?? '');
      emailCtrl.text = firebaseUser.email ?? '';
      phoneCtrl.text = settings?.phone.value ?? firebaseUser.phoneNumber ?? '';
      photoUrl.value = settings?.photoUrl.value.isNotEmpty == true
          ? settings!.photoUrl.value
          : (firebaseUser.photoURL ?? '');
    } else {
      _isLocalUser = true;
      final data     = await LocalUserService.instance.getUser();
      nameCtrl.text  = settings?.name.value.isNotEmpty == true
          ? settings!.name.value
          : (data['name'] ?? '');
      emailCtrl.text = settings?.email.value.isNotEmpty == true
          ? settings!.email.value
          : (data['email'] ?? '');
      phoneCtrl.text = settings?.phone.value.isNotEmpty == true
          ? settings!.phone.value
          : (data['phone'] ?? '');
      photoUrl.value = data['photoUrl'] ?? '';
    }

    avatarInitials.value = _initials(nameCtrl.text);
    nameCtrl.addListener(() {
      avatarInitials.value = _initials(nameCtrl.text);
    });
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }

  // ── Photo picker ──────────────────────────────────────
  void showPhotoOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('Choose Photo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () { Get.back(); _pickImage(ImageSource.gallery); },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a Photo'),
              onTap: () { Get.back(); _pickImage(ImageSource.camera); },
            ),
            if (photoUrl.value.isNotEmpty || localPhoto.value != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Get.back();
                  localPhoto.value = null;
                  photoUrl.value   = '';
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source, imageQuality: 80, maxWidth: 512, maxHeight: 512,
    );
    if (picked != null) localPhoto.value = File(picked.path);
  }

  // ── Save ──────────────────────────────────────────────
  Future<void> save() async {
    final newName  = nameCtrl.text.trim();
    final newPhone = phoneCtrl.text.trim();

    if (newName.isEmpty) { _error('Name cannot be empty'); return; }

    isSaving.value = true;
    try {
      if (_isLocalUser) {
        // ── Local user: save to SharedPreferences ─────
        String savedPhotoUrl = photoUrl.value;
        if (localPhoto.value != null) {
          // Store local file path for local users
          savedPhotoUrl = localPhoto.value!.path;
        }
        await LocalUserService.instance.saveUser(
          name:     newName,
          email:    emailCtrl.text.trim(),
          phone:    newPhone,
          photoUrl: savedPhotoUrl,
        );
        photoUrl.value = savedPhotoUrl;

      } else {
        // ── Firebase user: upload to Storage ──────────
        final user = FirebaseAuth.instance.currentUser!;
        String? uploadedPhotoUrl;

        if (localPhoto.value != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('profile_photos/${user.uid}.jpg');
          await ref.putFile(
            localPhoto.value!,
            SettableMetadata(contentType: 'image/jpeg'),
          );
          uploadedPhotoUrl = await ref.getDownloadURL();
          photoUrl.value   = uploadedPhotoUrl;
        }

        await user.updateDisplayName(newName);
        if (uploadedPhotoUrl != null) await user.updatePhotoURL(uploadedPhotoUrl);
        await user.reload();
        _auth.user.value = FirebaseAuth.instance.currentUser;
      }

      // ── Always sync SettingsController ───────────
      if (Get.isRegistered<SettingsController>()) {
        SettingsController.to.applyLocalUpdate(
          newName:     newName,
          newPhone:    newPhone,
          newPhotoUrl: photoUrl.value,
        );
      }

      Get.snackbar(
        'Profile Updated', 'Your profile has been saved successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      Get.back();
    } catch (e) {
      _error('Failed to save: ${e.toString()}');
    } finally {
      isSaving.value = false;
    }
  }

  String _initials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  void _error(String msg) => Get.snackbar(
        'Error', msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
}
// import 'dart:io';

// import 'package:beecode/screens/auth/controller/auth_controller.dart';
// import 'package:beecode/screens/setting/controller/setting_controller.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class EditProfileController extends GetxController {
//   AuthController get _auth => Get.find<AuthController>();

//   late final TextEditingController nameCtrl;
//   late final TextEditingController emailCtrl;
//   late final TextEditingController phoneCtrl;

//   final RxBool    isSaving        = false.obs;
//   final RxString  avatarInitials  = ''.obs;
//   final RxString  photoUrl        = ''.obs; 
//   final Rx<File?> localPhoto      = Rx<File?>(null); 

//   final _picker = ImagePicker();

//   @override
//   void onInit() {
//     super.onInit();
//     final user = _auth.user.value;
//     final settings = Get.isRegistered<SettingsController>() ? SettingsController.to : null;
//     nameCtrl  = TextEditingController(text: settings?.name.value.isNotEmpty == true ? settings!.name.value : (user?.displayName ?? ''));
//     emailCtrl = TextEditingController(text: user?.email ?? '');
//     phoneCtrl = TextEditingController(text: settings?.phone.value ?? user?.phoneNumber ?? '');
//     photoUrl.value       = settings?.photoUrl.value.isNotEmpty == true ? settings!.photoUrl.value : (user?.photoURL ?? '');
//     avatarInitials.value = _initials(nameCtrl.text);

//     nameCtrl.addListener(() {
//       avatarInitials.value = _initials(nameCtrl.text);
//     });
//   }

//   @override
//   void onClose() {
//     nameCtrl.dispose();
//     emailCtrl.dispose();
//     phoneCtrl.dispose();
//     super.onClose();
//   }
//   void showPhotoOptions() {
//     Get.bottomSheet(
//       Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             Text('Choose Photo',
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black87)),
//             const SizedBox(height: 16),
//             ListTile(
//               leading: const Icon(Icons.photo_library_outlined),
//               title: const Text('Choose from Gallery'),
//               onTap: () {
//                 Get.back();
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt_outlined),
//               title: const Text('Take a Photo'),
//               onTap: () {
//                 Get.back();
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             if (photoUrl.value.isNotEmpty || localPhoto.value != null)
//               ListTile(
//                 leading:
//                     const Icon(Icons.delete_outline, color: Colors.red),
//                 title: const Text('Remove Photo',
//                     style: TextStyle(color: Colors.red)),
//                 onTap: () {
//                   Get.back();
//                   localPhoto.value = null;
//                   photoUrl.value   = '';
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final picked = await _picker.pickImage(
//       source: source,
//       imageQuality: 80,
//       maxWidth: 512,
//       maxHeight: 512,
//     );
//     if (picked != null) {
//       localPhoto.value = File(picked.path);
//     }
//   }

//   Future<void> save() async {
//     final newName  = nameCtrl.text.trim();
//     final newPhone = phoneCtrl.text.trim();

//     if (newName.isEmpty) {
//       _error('Name cannot be empty');
//       return;
//     }

//     isSaving.value = true;
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//       String? uploadedPhotoUrl;

//       if (localPhoto.value != null) {
//         final ref = FirebaseStorage.instance
//             .ref()
//             .child('profile_photos/${user.uid}.jpg');
//         await ref.putFile(localPhoto.value!);
//         uploadedPhotoUrl = await ref.getDownloadURL();
//         photoUrl.value   = uploadedPhotoUrl;
//       }

//       await user.updateDisplayName(newName);
//       if (uploadedPhotoUrl != null) {
//         await user.updatePhotoURL(uploadedPhotoUrl);
//       }
//       if (Get.isRegistered<SettingsController>()) {
//         SettingsController.to.applyLocalUpdate(
//           newName:    newName,
//           newPhone:   newPhone,
//           newPhotoUrl: photoUrl.value,
//         );
//       }

//       Get.back();
//     } catch (e) {
//       _error('Failed to save. Please try again.');
//     } finally {
//       isSaving.value = false;
//     }
//   }
//   String _initials(String fullName) {
//     final parts = fullName.trim().split(RegExp(r'\s+'));
//     if (parts.isEmpty || parts.first.isEmpty) return 'U';
//     if (parts.length == 1) return parts.first[0].toUpperCase();
//     return (parts.first[0] + parts.last[0]).toUpperCase();
//   }

//   void _error(String msg) => Get.snackbar(
//         'Error', msg,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade600,
//         colorText: Colors.white,
//         margin: const EdgeInsets.all(16),
//       );
// }