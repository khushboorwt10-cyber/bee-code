import 'dart:io';
import 'package:beecode/screens/auth/controller/auth_controller.dart';
import 'package:beecode/screens/enrollment/model/enrollment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class EnrollmentController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController    = TextEditingController();
  final phoneController   = TextEditingController();
  final emailController   = TextEditingController();
  final addressController = TextEditingController();

  final currentStep    = 0.obs;
  final isLoading      = false.obs;
  final isSubmitted    = false.obs;
  final selectedCourse = ''.obs;

  final aadharFile    = Rxn<File>();
  final tenthFile     = Rxn<File>();
  final twelfthFile   = Rxn<File>();
  final tcFile        = Rxn<File>();
  final casteCertFile = Rxn<File>();
  final photo1        = Rxn<File>();
  final photo2        = Rxn<File>();
  final signature     = Rxn<File>();

  bool _nameManuallyEdited  = false;
  bool _emailManuallyEdited = false;
  bool _phoneManuallyEdited = false;

  final courses = [
    'B.Sc Computer Science',
    'BCA – Bachelor of Computer Applications',
    'B.Sc Information Technology',
    'MCA – Master of Computer Applications',
    'M.Sc Computer Science',
    'B.Tech Computer Science',
    'Diploma in Programming',
    'Certificate in Web Development',
  ];

  int get uploadedCount => [
        aadharFile.value,
        tenthFile.value,
        twelfthFile.value,
        tcFile.value,
        casteCertFile.value,
        photo1.value,
        photo2.value,
        signature.value,
      ].where((f) => f != null).length;

  List<DocItem> get documentItems => [
        DocItem(
          key: 'aadhar',
          label: 'Aadhar Card',
          subtitle: 'Front & back scanned copy',
          icon: Icons.credit_card_outlined,
          file: aadharFile,
          isRequired: true,
          isImage: false,
        ),
        DocItem(
          key: 'tenth',
          label: '10th Certificate',
          subtitle: 'Mark sheet & passing certificate',
          icon: Icons.school_outlined,
          file: tenthFile,
          isRequired: true,
          isImage: false,
        ),
        DocItem(
          key: 'twelfth',
          label: '12th Certificate',
          subtitle: 'Mark sheet & passing certificate',
          icon: Icons.school_outlined,
          file: twelfthFile,
          isRequired: true,
          isImage: false,
        ),
        DocItem(
          key: 'tc',
          label: 'Transfer Certificate',
          subtitle: 'TC from previous institution',
          icon: Icons.description_outlined,
          file: tcFile,
          isRequired: false,
          isImage: false,
        ),
        DocItem(
          key: 'caste',
          label: 'Caste Certificate',
          subtitle: 'If applicable',
          icon: Icons.article_outlined,
          file: casteCertFile,
          isRequired: false,
          isImage: false,
        ),
      ];


  @override
  void onInit() {
    super.onInit();
    _setupAuthListener();
    _setupManualEditListeners();
  }

  void _setupAuthListener() {
    try {
      final auth = Get.find<AuthController>();

      
      ever(auth.user, (_) => _syncFromAuth(auth));

      
      _syncFromAuth(auth);
    } catch (_) {
      
    }
  }

  void _setupManualEditListeners() {
    nameController.addListener(() {
      final auth = _safeAuth();
      if (auth == null) { _nameManuallyEdited = true; return; }
      final authName = auth.displayName.trim();
      if (nameController.text != authName) _nameManuallyEdited = true;
    });

    emailController.addListener(() {
      final auth = _safeAuth();
      if (auth == null) { _emailManuallyEdited = true; return; }
      if (emailController.text != auth.email.trim()) _emailManuallyEdited = true;
    });

    phoneController.addListener(() {
      final auth = _safeAuth();
      if (auth == null) { _phoneManuallyEdited = true; return; }
      final rawPhone = auth.user.value?.phoneNumber ?? '';
      final stripped = rawPhone.startsWith('+91') ? rawPhone.substring(3) : rawPhone;
      if (phoneController.text != stripped) _phoneManuallyEdited = true;
    });
  }

  AuthController? _safeAuth() {
    try { return Get.find<AuthController>(); } catch (_) { return null; }
  }

  void _syncFromAuth(AuthController auth) {
    final name  = auth.displayName.trim();
    final email = auth.email.trim();
    final raw   = auth.user.value?.phoneNumber ?? '';
    final phone = raw.startsWith('+91') ? raw.substring(3) : raw;

    if (!_nameManuallyEdited && name.isNotEmpty && name != 'User') {
      nameController.text = name;
    }
    if (!_emailManuallyEdited && email.isNotEmpty) {
      emailController.text = email;
    }
    if (!_phoneManuallyEdited && phone.isNotEmpty) {
      phoneController.text = phone;
    }
  }

  // ── Navigation ────────────────────────────────────────
  void nextStep() {
    if (!formKey.currentState!.validate()) return;
    if (selectedCourse.value.isEmpty) {
      Get.snackbar(
        'Course Required',
        'Please select a course to continue.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
      );
      return;
    }
    currentStep.value = 1;
  }

  void prevStep() => currentStep.value = 0;

  Future<void> pickDocument(String key) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result == null || result.files.single.path == null) return;
    _setDocFile(key, File(result.files.single.path!));
  }

  Future<void> pickImage(String key) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;
    _setDocFile(key, File(picked.path));
  }

  void _setDocFile(String key, File file) {
    switch (key) {
      case 'aadhar':    aadharFile.value    = file; break;
      case 'tenth':     tenthFile.value     = file; break;
      case 'twelfth':   twelfthFile.value   = file; break;
      case 'tc':        tcFile.value        = file; break;
      case 'caste':     casteCertFile.value = file; break;
      case 'photo1':    photo1.value        = file; break;
      case 'photo2':    photo2.value        = file; break;
      case 'signature': signature.value     = file; break;
    }
  }

  
  Future<void> submit() async {
    if (aadharFile.value == null ||
        tenthFile.value == null ||
        twelfthFile.value == null ||
        photo1.value == null ||
        photo2.value == null ||
        signature.value == null) {
      Get.snackbar(
        'Documents Required',
        'Please upload all mandatory documents (marked with *).',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
      );
      return;
    }

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2)); 
      isSubmitted.value = true;
    } catch (e) {
      Get.snackbar(
        'Submission Failed',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
      );
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }
}