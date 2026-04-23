import 'package:beecode/screens/auth/controller/signup_controller.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/images.dart';
import 'package:beecode/widget/login_toggel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpController = Get.put(SignUpController());

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Column(
        children: [
          _Header(),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: signUpController.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 28.h),
                       TabSwitcher(isLogin: false),
                        SizedBox(height: 28.h),
                        _FieldLabel('Full Name'),
                        SizedBox(height: 8.h),
                        _NameField(signUpController: signUpController),
                        SizedBox(height: 20.h),
                        _FieldLabel('Email'),
                        SizedBox(height: 8.h),
                        _EmailField(signUpController: signUpController),
                        SizedBox(height: 20.h),
                        _FieldLabel('Password'),
                        SizedBox(height: 8.h),
                        _PasswordField(signUpController: signUpController),

                        SizedBox(height: 20.h),
                        _FieldLabel('Confirm Password'),
                        SizedBox(height: 8.h),
                        _ConfirmPasswordField(signUpController: signUpController),

                        SizedBox(height: 18.h),

                        _TermsRow(signUpController: signUpController),

                        SizedBox(height: 28.h),

                        // Sign Up button
                        _SignUpButton(signUpController: signUpController),

                        SizedBox(height: 24.h),

                        // Or divider
                        _OrDivider(),

                        SizedBox(height: 20.h),

                        // Google button
                        _SocialButton(
                          label: 'Continue with Google',
                          image: Image.asset(AppImages.google),
                          onTap: signUpController.signUpWithGoogle,
                        ),

                        SizedBox(height: 60.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 265.h,
      decoration: const BoxDecoration(
        color: Color(0xFF0D1117),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _StarfieldPainter()),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                     Image.asset(
                        AppImages.logoapp,
                        height: 30.h,
                        width: 50.w,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Get Started now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Create an account or log in to explore\nabout our app',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final rng = math.Random(42);
    for (int i = 0; i < 60; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = rng.nextDouble() * 1.2 + 0.4;
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// class _TabSwitcher extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 48.h,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF2F2F2),
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () => Get.back(),
//               child: Container(
//                 margin: EdgeInsets.all(4.w),
//                 alignment: Alignment.center,
//                 child: Text(
//                   'Log In',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                     color: const Color(0xFF999999),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // Active: Sign Up
//           Expanded(
//             child: Container(
//               margin: EdgeInsets.all(4.w),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(9.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.08),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 'Sign Up',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w700,
//                   color: const Color(0xFF111111),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF555555),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  final SignUpController signUpController;
  const _NameField({required this.signUpController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: signUpController.nameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      style: TextStyle(fontSize: 14.sp, color: const Color(0xFF111111)),
      decoration: _inputDecoration(hint: 'John Doe'),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Name is required';
        return null;
      },
    );
  }
}



class _EmailField extends StatelessWidget {
  final SignUpController signUpController;
  const _EmailField({required this.signUpController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: signUpController.emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: TextStyle(fontSize: 14.sp, color: const Color(0xFF111111)),
      decoration: _inputDecoration(hint: 'example@gmail.com'),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Email is required';
        final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
        return null;
      },
    );
  }
}

// ─── Password field ───────────────────────────────────────────────────────────

class _PasswordField extends StatelessWidget {
  final SignUpController signUpController;
  const _PasswordField({required this.signUpController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
          controller: signUpController.passwordController,
          obscureText: signUpController.isPasswordHidden.value,
          textInputAction: TextInputAction.next,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF111111)),
          decoration: _inputDecoration(hint: '••••••••').copyWith(
            suffixIcon: GestureDetector(
              onTap: signUpController.togglePassword,
              child: Icon(
                signUpController.isPasswordHidden.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey.shade400,
                size: 20.sp,
              ),
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Password is required';
            if (v.length < 6) return 'Minimum 6 characters';
            return null;
          },
        ));
  }
}


class _ConfirmPasswordField extends StatelessWidget {
  final SignUpController signUpController;
  const _ConfirmPasswordField({required this.signUpController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
          controller: signUpController.confirmController,
          obscureText: signUpController.isConfirmHidden.value,
          textInputAction: TextInputAction.done,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF111111)),
          decoration: _inputDecoration(hint: '••••••••').copyWith(
            suffixIcon: GestureDetector(
              onTap: signUpController.toggleConfirmPassword,
              child: Icon(
                signUpController.isConfirmHidden.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey.shade400,
                size: 20.sp,
              ),
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Please confirm your password';
            if (v != signUpController.passwordController.text) return 'Passwords do not match';
            return null;
          },
        ));
  }
}

InputDecoration _inputDecoration({required String hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: Color(0xFF3B5BDB), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color:  AppColors.prime, width: 1.2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color:  AppColors.prime, width: 1.5),
    ),
    errorStyle: TextStyle(fontSize: 11.sp),
  );
}


class _TermsRow extends StatelessWidget {
  final SignUpController signUpController;
  const _TermsRow({required this.signUpController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: signUpController.toggleTerms,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: signUpController.agreedToTerms.value
                        ? const Color(0xFF3B5BDB)
                        : Colors.grey.shade400,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                  color: signUpController.agreedToTerms.value
                      ? const Color(0xFF3B5BDB)
                      : Colors.white,
                ),
                child: signUpController.agreedToTerms.value
                    ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                    children: const [
                      TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: Color(0xFF3B5BDB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFF3B5BDB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// ─── Sign Up button ───────────────────────────────────────────────────────────

class _SignUpButton extends StatelessWidget {
  final SignUpController signUpController;
  const _SignUpButton({required this.signUpController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          height: 54.h,
          child: ElevatedButton(
            onPressed: signUpController.isLoading.value ? null : signUpController.signUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B5BDB),
              disabledBackgroundColor: const Color(0xFF3B5BDB).withOpacity(0.7),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: signUpController.isLoading.value
                ? SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ));
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Text(
            'Or',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Image image;
  final VoidCallback onTap;
  const _SocialButton({
    required this.label,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade200, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF222222),
              ),
            ),
          ],
        ),
      ),
    );
  }
}