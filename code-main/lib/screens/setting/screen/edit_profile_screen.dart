import 'package:beecode/screens/setting/controller/edit_profile_controller.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  EditProfileController get c {
    if (!Get.isRegistered<EditProfileController>()) {
      return Get.put(EditProfileController());
    }
    return Get.find<EditProfileController>();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = c;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: 20.sp, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text('Edit Profile',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
        actions: [
          Obx(() => TextButton(
                onPressed: ctrl.isSaving.value ? null : ctrl.save,
                child: ctrl.isSaving.value
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Save',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.prime)),
              )),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(height: 12.h),

            
            GestureDetector(
              onTap: ctrl.showPhotoOptions,
              child: Obx(() {
                final localFile = ctrl.localPhoto.value;
                final networkUrl = ctrl.photoUrl.value;
                final initials  = ctrl.avatarInitials.value;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: AppColors.prime,
                      backgroundImage: localFile != null
                          ? FileImage(localFile) as ImageProvider
                          : (networkUrl.isNotEmpty
                              ? NetworkImage(networkUrl)
                              : null),
                      child: (localFile == null && networkUrl.isEmpty)
                          ? Text(initials,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w700))
                          : null,
                    ),

                    
                    Positioned.fill(
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.black.withOpacity(0.28),
                        child: Icon(Icons.camera_alt_outlined,
                            color: Colors.white, size: 26.sp),
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 8.h),
            Text('Tap to change photo',
                style: TextStyle(fontSize: 12.sp, color: Colors.black38)),
            SizedBox(height: 28.h),
            _label('Full Name'),
            SizedBox(height: 6.h),
            _field(
              textCtrl: ctrl.nameCtrl,
              icon: Icons.person_outline,
              hint: 'Enter your full name',
            ),
            SizedBox(height: 16.h),
            _label('Email'),
            SizedBox(height: 6.h),
            _field(
              textCtrl: ctrl.emailCtrl,
              icon: Icons.email_outlined,
              hint: 'Email address',
              readOnly: true,
              suffix: Icon(Icons.lock_outline,
                  size: 16.sp, color: Colors.black38),
            ),
            SizedBox(height: 4.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Email address cannot be changed',
                  style: TextStyle(fontSize: 11.sp, color: Colors.black38)),
            ),
            SizedBox(height: 16.h),

            
            _label('Phone Number'),
            SizedBox(height: 6.h),
            _field(
              textCtrl: ctrl.phoneCtrl,
              icon: Icons.phone_outlined,
              hint: '+91 XXXXX XXXXX',
              keyboardType: TextInputType.phone,
              maxLength: 10
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                letterSpacing: 0.4)),
      );

  Widget _field({
    required TextEditingController textCtrl,
    required IconData icon,
    required String hint,
    bool readOnly = false,
    Widget? suffix,
    TextInputType? keyboardType,
    int? maxLength,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: readOnly ? const Color(0xFFF0F0F0) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: readOnly ? Colors.grey.shade300 : Colors.grey.shade200),
        ),
        child: TextField(
          controller: textCtrl,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLength: maxLength,
          style: TextStyle(
              fontSize: 14.sp,
              color: readOnly ? Colors.black45 : Colors.black87),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18.sp, color: AppColors.prime),
            suffixIcon: suffix,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13.sp, color: Colors.black38),
            border: InputBorder.none,
            counterText: '',      // hides the "0/10" counter below the field
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      );}