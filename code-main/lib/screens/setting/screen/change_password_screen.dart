
import 'package:beecode/screens/setting/controller/change_password_controller.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

 
  ChangePasswordController get c {
    if (!Get.isRegistered<ChangePasswordController>()) {
      return Get.put(ChangePasswordController());
    }
    return Get.find<ChangePasswordController>();
  }

  @override
  Widget build(BuildContext context) {
 
    final ctrl = c;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Change Password',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),

            
            Center(
              child: Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.prime.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock_reset_rounded,
                    size: 38.sp, color: AppColors.prime),
              ),
            ),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                'Create a strong password',
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
            ),
            Center(
              child: Text(
                'Use 8+ characters with letters, numbers & symbols',
                style: TextStyle(fontSize: 12.sp, color: Colors.black45),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 28.h),

            
            _label('Current Password'),
            SizedBox(height: 6.h),
            Obx(() => _field(
                  textCtrl: ctrl.currentPasswordCtrl,
                  hint: 'Enter current password',
                  isHidden: ctrl.isCurrentHidden.value,
                  onToggle: ctrl.toggleCurrent,
                )),
            SizedBox(height: 16.h),

            
            _label('New Password'),
            SizedBox(height: 6.h),
            Obx(() => _field(
                  textCtrl: ctrl.newPasswordCtrl,
                  hint: 'Enter new password',
                  isHidden: ctrl.isNewHidden.value,
                  onToggle: ctrl.toggleNew,
                )),
            SizedBox(height: 8.h),

            
            Obx(() => _PasswordStrengthBar(strength: ctrl.passwordStrength.value)),
            SizedBox(height: 16.h),

            
            _label('Confirm New Password'),
            SizedBox(height: 6.h),
            Obx(() => _field(
                  textCtrl: ctrl.confirmPasswordCtrl,
                  hint: 'Re-enter new password',
                  isHidden: ctrl.isConfirmHidden.value,
                  onToggle: ctrl.toggleConfirm,
                )),
            SizedBox(height: 32.h),

            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed:
                        ctrl.isLoading.value ? null : ctrl.changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      disabledBackgroundColor:
                          AppColors.black.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                      elevation: 0,
                    ),
                    child: ctrl.isLoading.value
                        ? SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
                            'Update Password',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                )),
            SizedBox(height: 20.h),

           
          ],
        ),
      ),
    );
  }


  Widget _label(String text) => Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
          letterSpacing: 0.4,
        ),
      );

  Widget _field({
    required TextEditingController textCtrl,
    required String hint,
    required bool isHidden,
    required VoidCallback onToggle,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: TextField(
          controller: textCtrl,
          obscureText: isHidden,
          style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline,
                size: 18.sp, color: AppColors.prime),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                isHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18.sp,
                color: Colors.black38,
              ),
            ),
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13.sp, color: Colors.black38),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      );

}

class _PasswordStrengthBar extends StatelessWidget {
  final int strength;
  const _PasswordStrengthBar({required this.strength});

  @override
  Widget build(BuildContext context) {
    if (strength == 0) return const SizedBox.shrink();

    const labels = ['', 'Weak', 'Fair', 'Good', 'Strong'];
    final colors = [
      Colors.transparent,
      Colors.red.shade400,
      Colors.orange.shade400,
      Colors.blue.shade400,
      Colors.green.shade500,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < 3 ? 4.w : 0),
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: i < strength
                        ? colors[strength]
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              )),
        ),
        SizedBox(height: 4.h),
        Text(
          labels[strength],
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: colors[strength],
          ),
        ),
      ],
    );
  }
}