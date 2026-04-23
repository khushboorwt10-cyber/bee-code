import 'dart:io';
import 'package:beecode/screens/enrollment/controller/enrollment_controller.dart';
import 'package:beecode/screens/enrollment/model/enrollment_model.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ═══════════════════════════════════════════════════════
//  ENROLLMENT SCREEN
// ═══════════════════════════════════════════════════════
class EnrollmentScreen extends GetView<EnrollmentController> {
  const EnrollmentScreen({super.key});

  @override
  EnrollmentController get controller {
    if (!Get.isRegistered<EnrollmentController>()) {
      return Get.put(EnrollmentController());
    }
    return Get.find<EnrollmentController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: _AppBarWidget(onBack: () => Get.back()),
      ),
      body: Obx(() {
        if (controller.isSubmitted.value) return const _SuccessView();
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _HeroSection(controller: controller),
                  _StepProgressSection(controller: controller),
                  Obx(() => controller.currentStep.value == 0
                      ? _PersonalInfoSection(controller: controller)
                      : _DocumentsSection(controller: controller)),
                  SizedBox(height: 90.h),
                ],
              ),
            ),
            // Sticky bottom button
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _StickyActionBar(controller: controller),
            ),
          ],
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  APP BAR
// ═══════════════════════════════════════════════════════
class _AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  const _AppBarWidget({required this.onBack});

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      shadowColor: Colors.black12,
      leadingWidth: double.infinity,
      leading: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: Colors.black87),
            onPressed: onBack,
          ),
          Expanded(
            child: Text(
              'Course Enrollment',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  HERO SECTION  (dark gradient — matches detail screen)
// ═══════════════════════════════════════════════════════
class _HeroSection extends StatelessWidget {
  final EnrollmentController controller;
  const _HeroSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 1, 11, 43),
            Color.fromARGB(255, 6, 49, 130),
            Color.fromARGB(255, 1, 11, 43),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Institute badge row
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.school_outlined, color: Colors.white70, size: 14.sp),
                    SizedBox(width: 6.w),
                    Text(
                      'Institute Portal',
                      style: TextStyle(color: Colors.white70, fontSize: 11.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Main title
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: 'Start Your\n',
                style: TextStyle(color: Colors.white, fontSize: 26.sp, fontWeight: FontWeight.w800, height: 1.25),
              ),
              TextSpan(
                text: 'Enrollment',
                style: TextStyle(color: AppColors.prime, fontSize: 26.sp, fontWeight: FontWeight.w800, height: 1.25),
              ),
              TextSpan(
                text: ' Journey',
                style: TextStyle(color: Colors.white, fontSize: 26.sp, fontWeight: FontWeight.w800, height: 1.25),
              ),
            ]),
          ),
          SizedBox(height: 12.h),

          Text(
            'Fill in your personal details and upload the required documents to complete your application.',
            style: TextStyle(color: Colors.white.withOpacity(0.70), fontSize: 13.sp, height: 1.55),
          ),
          SizedBox(height: 20.h),

          // Quick stat chips
          Row(
            children: [
              _HeroChip(icon: Icons.timer_outlined,          label: '5 min process'),
              SizedBox(width: 10.w),
              _HeroChip(icon: Icons.lock_outline,            label: '100% Secure'),
              SizedBox(width: 10.w),
              _HeroChip(icon: Icons.check_circle_outline,    label: 'Instant Confirm'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeroChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 12.sp),
          SizedBox(width: 4.w),
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 10.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  STEP PROGRESS  (matches app's section separator style)
// ═══════════════════════════════════════════════════════
class _StepProgressSection extends StatelessWidget {
  final EnrollmentController controller;
  const _StepProgressSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final step = controller.currentStep.value;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        color: Colors.white,
        child: Row(
          children: [
            _StepDot(number: 1, label: 'Personal Info', isActive: step == 0, isDone: step > 0),
            Expanded(
              child: Container(
                height: 2.h,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: step > 0 ? AppColors.prime : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            _StepDot(number: 2, label: 'Documents',    isActive: step == 1, isDone: false),
          ],
        ),
      );
    });
  }
}

class _StepDot extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isDone;
  const _StepDot({required this.number, required this.label, required this.isActive, required this.isDone});

  @override
  Widget build(BuildContext context) {
    final active = isActive || isDone;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: active ? AppColors.prime : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: active ? AppColors.prime : Colors.grey.shade300, width: 2),
          ),
          child: Center(
            child: isDone
                ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: active ? AppColors.prime : Colors.black38,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
//  STEP 1 — PERSONAL INFO
// ═══════════════════════════════════════════════════════
class _PersonalInfoSection extends StatelessWidget {
  final EnrollmentController controller;
  const _PersonalInfoSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Course Selection Card ──────────────────────
          _SectionBlock(
            label: 'SELECT COURSE',
            title: 'Choose Your',
            titleHighlight: 'Programme',
            child: _CourseDropdown(controller: controller),
          ),

          // ── Personal Details Card ──────────────────────
          _SectionBlock(
            label: 'PERSONAL DETAILS',
            title: 'Your',
            titleHighlight: 'Information',
            child: Column(
              children: [
                _AppTextField(
                  controller: controller.nameController,
                  label: 'Full Name',
                  hint: 'As per official documents',
                  icon: Icons.person_outline,
                  validator: (v) => v == null || v.isEmpty ? 'Full name is required' : null,
                ),
                SizedBox(height: 14.h),
                _AppTextField(
                  controller: controller.phoneController,
                  label: 'Phone Number',
                  hint: '10-digit mobile number',
                  icon: Icons.phone_outlined,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Phone number is required';
                    if (v.length < 10) return 'Enter a valid 10-digit number';
                    return null;
                  },
                ),
                SizedBox(height: 14.h),
                _AppTextField(
                  controller: controller.emailController,
                  label: 'Email Address',
                  hint: 'you@example.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!GetUtils.isEmail(v)) return 'Enter a valid email address';
                    return null;
                  },
                ),
                SizedBox(height: 14.h),
                _AppTextField(
                  controller: controller.addressController,
                  label: 'Residential Address',
                  hint: 'Street, City, State, PIN',
                  icon: Icons.location_on_outlined,
                  maxLines: 3,
                  validator: (v) => v == null || v.isEmpty ? 'Address is required' : null,
                ),
              ],
            ),
          ),

          // ── Info note ─────────────────────────────────
          _InfoBanner(
            text: 'All details must match your official documents. Double-check before proceeding.',
            icon: Icons.shield_outlined,
          ),
        ],
      ),
    );
  }
}

// ── Course Dropdown ──────────────────────────────────────
class _CourseDropdown extends StatelessWidget {
  final EnrollmentController controller;
  const _CourseDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: controller.selectedCourse.value.isNotEmpty
                  ? AppColors.prime
                  : Colors.grey.shade200,
              width: controller.selectedCourse.value.isNotEmpty ? 1.5 : 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: controller.selectedCourse.value.isEmpty ? null : controller.selectedCourse.value,
            hint: Text('Choose your course', style: TextStyle(color: Colors.black38, fontSize: 14.sp)),
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.prime, size: 20.sp),
            isExpanded: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.menu_book_outlined, color: AppColors.prime, size: 20.sp),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
            ),
            borderRadius: BorderRadius.circular(12.r),
            items: controller.courses
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c, style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                    ))
                .toList(),
            onChanged: (val) => controller.selectedCourse.value = val ?? '',
          ),
        ));
  }
}

// ═══════════════════════════════════════════════════════
//  STEP 2 — DOCUMENTS
// ═══════════════════════════════════════════════════════
class _DocumentsSection extends StatelessWidget {
  final EnrollmentController controller;
  const _DocumentsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Upload progress banner
        Obx(() => _UploadProgressBanner(
              uploaded: controller.uploadedCount,
              total: 7,
            )),

        // Academic documents
        _SectionBlock(
          label: 'ACADEMIC RECORDS',
          title: 'Identity &',
          titleHighlight: 'Documents',
          child: Column(
            children: controller.documentItems
                .map((doc) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: _DocUploadTile(
                        item: doc,
                        onTap: () => controller.pickDocument(doc.key),
                      ),
                    ))
                .toList(),
          ),
        ),

        // Photos & Signature
        _SectionBlock(
          label: 'PHOTOS & SIGNATURE',
          title: 'Your',
          titleHighlight: 'Photos',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _PhotoCard(
                      label: 'Passport Photo 1',
                      file: controller.photo1,
                      onTap: () => controller.pickImage('photo1'),
                      isRequired: true,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _PhotoCard(
                      label: 'Passport Photo 2',
                      file: controller.photo2,
                      onTap: () => controller.pickImage('photo2'),
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _DocUploadTile(
                item: DocItem(
                  key: 'signature',
                  label: 'Signature',
                  subtitle: 'Clear image on white background',
                  icon: Icons.draw_outlined,
                  file: controller.signature,
                  isRequired: true,
                  isImage: true,
                ),
                onTap: () => controller.pickImage('signature'),
              ),
            ],
          ),
        ),
        _InfoBanner(
          text: 'Aadhar Card, 10th, 12th certificates, 2 photos and Signature are mandatory.',
          icon: Icons.info_outline,
        ),
      ],
    );
  }
}

// ── Upload Progress Banner ─────────────────────────────
class _UploadProgressBanner extends StatelessWidget {
  final int uploaded;
  final int total;
  const _UploadProgressBanner({required this.uploaded, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = uploaded / total;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.prime.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.prime.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Documents Uploaded',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              Text(
                '$uploaded / $total',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.prime),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6.h,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.prime),
            ),
          ),
          if (uploaded == total) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 14.sp),
                SizedBox(width: 4.w),
                Text('All documents ready!', style: TextStyle(color: Colors.green.shade700, fontSize: 12.sp, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Document Upload Tile ───────────────────────────────
class _DocUploadTile extends StatelessWidget {
  final DocItem item;
  final VoidCallback onTap;
  const _DocUploadTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final uploaded = item.file.value != null;
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: uploaded ? AppColors.prime.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: uploaded ? AppColors.prime : Colors.grey.shade200,
              width: uploaded ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Icon box
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: uploaded
                      ? AppColors.prime.withOpacity(0.12)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  uploaded ? Icons.check_circle_outline : item.icon,
                  color: uploaded ? AppColors.prime : Colors.black38,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 14.w),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: uploaded ? AppColors.prime : Colors.black87,
                            ),
                          ),
                        ),
                        if (item.isRequired)
                          Text(' *', style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      uploaded
                          ? item.file.value!.path.split('/').last
                          : item.subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: uploaded ? Colors.green.shade700 : Colors.black38,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Action icon
              Icon(
                uploaded ? Icons.edit_outlined : Icons.upload_file_outlined,
                color: AppColors.prime,
                size: 18.sp,
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ── Photo Card ────────────────────────────────────────
class _PhotoCard extends StatelessWidget {
  final String label;
  final Rxn<File> file;
  final VoidCallback onTap;
  final bool isRequired;
  const _PhotoCard({required this.label, required this.file, required this.onTap, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final uploaded = file.value != null;
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 120.h,
          decoration: BoxDecoration(
            color: uploaded ? AppColors.prime.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: uploaded ? AppColors.prime : Colors.grey.shade200,
              width: uploaded ? 1.5 : 1,
            ),
          ),
          child: uploaded
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(11.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(file.value!, fit: BoxFit.cover),
                      Positioned(
                        top: 6.h,
                        right: 6.w,
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                          child: Icon(Icons.check, color: Colors.white, size: 10.sp),
                        ),
                      ),
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withOpacity(0.65), Colors.transparent],
                            ),
                          ),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.w, height: 40.w,
                      decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                      child: Icon(Icons.add_a_photo_outlined, color: Colors.black38, size: 20.sp),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.black54, fontWeight: FontWeight.w500)),
                        if (isRequired) Text(' *', style: TextStyle(color: Colors.red, fontSize: 12.sp)),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text('Tap to upload', style: TextStyle(fontSize: 10.sp, color: Colors.black38)),
                  ],
                ),
        ),
      );
    });
  }
}

// ═══════════════════════════════════════════════════════
//  STICKY ACTION BAR  (matches app's _StickyButton style)
// ═══════════════════════════════════════════════════════
class _StickyActionBar extends StatelessWidget {
  final EnrollmentController controller;
  const _StickyActionBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: Obx(() {
        final isStep2 = controller.currentStep.value == 1;
        return Row(
          children: [
            if (isStep2) ...[
              GestureDetector(
                onTap: controller.prevStep,
                child: Container(
                  width: 52.w, height: 52.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                  ),
                  child: Icon(Icons.arrow_back_ios, size: 18.sp, color: Colors.black87),
                ),
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: GestureDetector(
                onTap: isStep2 ? controller.submit : controller.nextStep,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: controller.isLoading.value
                        ? SizedBox(
                            width: 22.w, height: 22.h,
                            child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isStep2 ? 'Submit Application' : 'Continue to Documents',
                                style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w700, letterSpacing: 0.2),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                isStep2 ? Icons.send_rounded : Icons.arrow_forward,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  SUCCESS VIEW
// ═══════════════════════════════════════════════════════
class _SuccessView extends StatelessWidget {
  const _SuccessView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90.w, height: 90.w,
                decoration: BoxDecoration(
                  color: AppColors.prime.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_outline, color: AppColors.prime, size: 48.sp),
              ),
              SizedBox(height: 28.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Application\n',
                    style: TextStyle(color: Colors.black87, fontSize: 28.sp, fontWeight: FontWeight.w800, height: 1.25),
                  ),
                  TextSpan(
                    text: 'Submitted!',
                    style: TextStyle(color: AppColors.prime, fontSize: 28.sp, fontWeight: FontWeight.w800, height: 1.25),
                  ),
                ]),
              ),
              SizedBox(height: 16.h),
              Text(
                'Your enrollment application has been received. Check your email for confirmation and next steps.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black45, fontSize: 14.sp, height: 1.6),
              ),
              SizedBox(height: 40.h),
              Container(width: 50.w, height: 3.h, color: AppColors.prime),
              SizedBox(height: 40.h),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: double.infinity,
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'Back to Home',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  SHARED COMPONENTS
// ═══════════════════════════════════════════════════════

/// Matches the app's section style: label + RichText title + content
class _SectionBlock extends StatelessWidget {
  final String label;
  final String title;
  final String titleHighlight;
  final Widget child;
  const _SectionBlock({
    required this.label,
    required this.title,
    required this.titleHighlight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 6.h),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '$title ',
                style: TextStyle(color: Colors.black87, fontSize: 20.sp, fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: titleHighlight,
                style: TextStyle(color: AppColors.prime, fontSize: 20.sp, fontWeight: FontWeight.w800),
              ),
            ]),
          ),
          SizedBox(height: 6.h),
          Container(width: 40.w, height: 3.h, color: AppColors.prime),
          SizedBox(height: 20.h),
          child,
        ],
      ),
    );
  }
}
/// Text field matching the app's input style
class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;          // ← NEW
  final String? Function(String?)? validator;

  const _AppTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,              // ← NEW
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,      // ← NEW
      validator: validator,
      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black26, fontSize: 13.sp),
        labelStyle: TextStyle(color: Colors.black45, fontSize: 13.sp),
        prefixIcon: Icon(icon, color: AppColors.prime, size: 20.sp),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        counterText: '',         // ← hides the "0/10" counter below field
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.prime, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
/// Info note banner — amber style matching _RequiredNote
class _InfoBanner extends StatelessWidget {
  final String text;
  final IconData icon;
  const _InfoBanner({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange.shade600, size: 16.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12.sp, color: Colors.black54, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}