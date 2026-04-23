import 'package:beecode/screens/subscription/controller/subscription_controller.dart';
import 'package:beecode/screens/subscription/model/subscription_model.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';



class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F4FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: Get.back,
        ),
        title: Text(
          'Go Pro',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.productsLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1A3BE8),
                    strokeWidth: 2.5,
                  ),
                );
              }
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 8.h),
                    _buildHeader(),
                    SizedBox(height: 24.h),
                    _buildPlanCards(),
                    SizedBox(height: 24.h),
                    _buildFeatures(),
                    SizedBox(height: 24.h),
                    _buildBenefits(),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            }),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.kGradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              FontAwesomeIcons.crown,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Unlock BeeCode Pro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Learn faster with full access to all courses,\ncertificates & ad-free experience',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Plan Cards ────────────────────────────
  Widget _buildPlanCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your plan',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        ...SubscriptionData.plans.asMap().entries.map((entry) {
          final plan = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _PlanCard(plan: plan, controller: controller),
          );
        }),
      ],
    );
  }

  // ── Features ──────────────────────────────
  Widget _buildFeatures() {
    return Obx(() {
      final features = controller.currentFeatures;
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // ── Simple solid blue icon ──
                Icon(
                  Icons.check_circle_rounded,
                  color: const Color(0xFF1A3BE8),
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  "What's included",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            ...features.map((f) => _FeatureItem(text: f)),
          ],
        ),
      );
    });
  }

  // ── Benefits ──────────────────────────────
  Widget _buildBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pro benefits',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        ...SubscriptionData.benefits.map(
          (b) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _BenefitTile(benefit: b),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => GestureDetector(
                onTap: controller.isLoading.value
                    ? null
                    : controller.buySubscription,
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    gradient: controller.isLoading.value ? null : AppColors.kGradient,
                    color: controller.isLoading.value
                        ? Colors.grey.shade300
                        : null,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: controller.isLoading.value
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.crown,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Subscribe Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              )),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: controller.restorePurchases,
            child: ShaderMask(
              shaderCallback: (bounds) => AppColors.kGradient.createShader(bounds),
              child: Text(
                'Restore Purchases',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'By subscribing, you agree to our Terms & Privacy Policy',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp, color: Colors.black38),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PLAN CARD
// ═══════════════════════════════════════════════════════════════

class _PlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final SubscriptionController controller;

  const _PlanCard({
    required this.plan,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedPlan.value == plan.index;
      return GestureDetector(
        onTap: () => controller.selectPlan(plan.index),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Card container ──
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFEEF2FF) : Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF1A3BE8)
                      : Colors.grey.shade200,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  // ── Icon with gradient when selected ──
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      gradient: selected ? AppColors.kGradient : null,
                      color: selected ? null : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      plan.icon,
                      color: selected ? Colors.white : Colors.black45,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // ── Title + subtitle ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          plan.subtitle,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: selected
                                ? const Color(0xFF1A3BE8)
                                : Colors.black45,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Price ──
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      selected
                          ? ShaderMask(
                              shaderCallback: (bounds) =>
                                  AppColors.kGradient.createShader(bounds),
                              child: Text(
                                plan.price,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              plan.price,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                      Text(
                        plan.per,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),

                  // ── Radio with gradient when selected ──
                  selected
                      ? Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: const BoxDecoration(
                            gradient: AppColors.kGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 12.sp,
                          ),
                        )
                      : Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                        ),
                ],
              ),
            ),

            // ── Popular badge ──
            if (plan.popular)
              Positioned(
                top: -10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      gradient: AppColors.kGradient,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Most Popular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════════
// FEATURE ITEM — simple tick, no heavy circle
// ═══════════════════════════════════════════════════════════════

class _FeatureItem extends StatelessWidget {
  final String text;
  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Simple blue tick, no background circle ──
          Icon(
            Icons.check_rounded,
            color: const Color(0xFF1A3BE8),
            size: 18.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BENEFIT TILE
// ═══════════════════════════════════════════════════════════════

class _BenefitTile extends StatelessWidget {
  final SubscriptionBenefitModel benefit;
  const _BenefitTile({required this.benefit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // ── Icon with gradient background ──
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              gradient: AppColors.kGradient,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              benefit.icon,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit.title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  benefit.subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}