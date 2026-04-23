import 'package:beecode/screens/auth/controller/login_controller.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:beecode/screens/utils/images.dart';
import 'package:beecode/widget/login_toggel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            _Header(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Form(
                key: loginController.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 28.h),
                    TabSwitcher(isLogin: true),
                    SizedBox(height: 28.h),

                    _FieldLabel('Email'),
                    SizedBox(height: 8.h),
                    _EmailField(loginController: loginController),

                    SizedBox(height: 20.h),

                    _FieldLabel('Password'),
                    SizedBox(height: 8.h),
                    _PasswordField(loginController: loginController),

                    SizedBox(height: 14.h),
                    _RememberForgotRow(
                        loginController: loginController),

                    SizedBox(height: 28.h),

                    _LoginButton(
                        loginController: loginController),

                    SizedBox(height: 24.h),
                    _OrDivider(),
                    SizedBox(height: 20.h),

                    _SocialButton(
                      image: Image.asset(
                        AppImages.google,
                        height: 20.h,
                      ),
                      label: 'Continue with Google',
                      onTap: loginController.loginWithGoogle,
                    ),

                    SizedBox(height: 80.h), 
                  ],
                ),
              ),
            ),
          ],
        ),
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
      decoration: const BoxDecoration(color: Color(0xFF0D1117)),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _StarfieldPainter())),

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

class _EmailField extends StatelessWidget {
  final LoginController loginController;
  const _EmailField({required this.loginController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: loginController.emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: TextStyle(fontSize: 14.sp, color: const Color(0xFF111111)),
      decoration: _inputDecoration(hint: 'Loisbecket@gmail.com'),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Email is required';
        final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
        return null;
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  final LoginController loginController;
  const _PasswordField({required this.loginController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        controller: loginController.passwordController,
        obscureText: loginController.isPasswordHidden.value,
        textInputAction: TextInputAction.done,
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF111111)),
        decoration: _inputDecoration(hint: '••••••••').copyWith(
          suffixIcon: GestureDetector(
            onTap: loginController.togglePassword,
            child: Icon(
              loginController.isPasswordHidden.value
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
      ),
    );
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
      borderSide: BorderSide(color: AppColors.prime, width: 1.2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: AppColors.prime, width: 1.5),
    ),
    errorStyle: TextStyle(fontSize: 11.sp),
  );
}

class _RememberForgotRow extends StatefulWidget {
  final LoginController loginController;
  const _RememberForgotRow({required this.loginController});

  @override
  State<_RememberForgotRow> createState() => _RememberForgotRowState();
}

class _RememberForgotRowState extends State<_RememberForgotRow> {
  bool _remember = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _remember = !_remember),
          child: Row(
            children: [
              Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _remember
                        ? const Color(0xFF3B5BDB)
                        : Colors.grey.shade400,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                  color: _remember ? const Color(0xFF3B5BDB) : Colors.white,
                ),
                child: _remember
                    ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 8.w),
              Text(
                'Remember me',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: widget.loginController.forgotPassword,
          child: Text(
            'Forgot Password ?',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF3B5BDB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  final LoginController loginController;
  const _LoginButton({required this.loginController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 54.h,
        child: ElevatedButton(
          onPressed: loginController.isLoading.value
              ? null
              : loginController.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B5BDB),
            disabledBackgroundColor: const Color(0xFF3B5BDB).withOpacity(0.7),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: loginController.isLoading.value
              ? SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
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
    required this.onTap,
    required this.image,
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
