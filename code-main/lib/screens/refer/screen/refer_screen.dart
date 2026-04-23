// refer_screen.dart
import 'package:beecode/screens/refer/controller/refer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReferScreen extends StatelessWidget {
  const ReferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReferController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black87, size: 16.sp),
          ),
        ),
        title: Text(
          'Refer & Earn',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero banner
            _HeroBanner(),
            SizedBox(height: 28.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Referral code card
                  _ReferralCodeCard(controller: controller),
                  SizedBox(height: 28.h),

                  // Stats row
                  _StatsRow(controller: controller),
                  SizedBox(height: 28.h),

                  // How it works
                  _SectionTitle(title: 'How It Works'),
                  SizedBox(height: 16.h),
                  _HowItWorks(),
                  SizedBox(height: 28.h),

                  // Reward milestones
                  _SectionTitle(title: 'Reward Milestones'),
                  SizedBox(height: 16.h),
                  _RewardMilestones(controller: controller),
                  SizedBox(height: 28.h),

                  // Share button
                  _ShareButton(controller: controller),
                  SizedBox(height: 36.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Hero Banner
// ──────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF6C63FF), const Color(0xFF9C8FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.card_giftcard_rounded,
                color: Colors.white, size: 36.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            'Invite Friends,\nEarn Together!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Share your code and earn rewards\nfor every friend who joins.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Referral Code Card
// ──────────────────────────────────────────────
class _ReferralCodeCard extends StatelessWidget {
  final ReferController controller;
  const _ReferralCodeCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Referral Code',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.confirmation_number_rounded,
                          color: const Color(0xFF6C63FF), size: 18.sp),
                      SizedBox(width: 10.w),
                      Text(
                        controller.referCode,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Obx(() => GestureDetector(
                    onTap: controller.copyCode,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: controller.codeCopied.value
                            ? Colors.green.shade50
                            : const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: controller.codeCopied.value
                              ? Colors.green.shade300
                              : const Color(0xFF6C63FF).withOpacity(0.3),
                        ),
                      ),
                      child: Icon(
                        controller.codeCopied.value
                            ? Icons.check_rounded
                            : Icons.copy_rounded,
                        color: controller.codeCopied.value
                            ? Colors.green.shade600
                            : const Color(0xFF6C63FF),
                        size: 20.sp,
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Stats Row
// ──────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final ReferController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.people_alt_rounded,
                label: 'Total Referred',
                value: '${controller.totalReferred.value}',
                color: const Color(0xFF6C63FF),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: _StatCard(
                icon: Icons.monetization_on_rounded,
                label: 'Coins Earned',
                value: '${controller.coinsEarned.value}',
                color: const Color(0xFFFFB300),
              ),
            ),
          ],
        ));
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// How It Works
// ──────────────────────────────────────────────
class _HowItWorks extends StatelessWidget {
  final List<Map<String, dynamic>> steps = const [
    {
      'step': '01',
      'title': 'Share Your Code',
      'desc': 'Send your unique referral code to friends via any platform.',
      'icon': Icons.share_rounded,
    },
    {
      'step': '02',
      'title': 'Friend Signs Up',
      'desc': 'Your friend creates an account using your code.',
      'icon': Icons.person_add_alt_1_rounded,
    },
    {
      'step': '03',
      'title': 'Both Earn Rewards',
      'desc': 'You get coins and unlock milestones as your network grows.',
      'icon': Icons.emoji_events_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps
          .asMap()
          .entries
          .map((e) => _StepTile(
                step: e.value,
                isLast: e.key == steps.length - 1,
              ))
          .toList(),
    );
  }
}

class _StepTile extends StatelessWidget {
  final Map<String, dynamic> step;
  final bool isLast;
  const _StepTile({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step number + line
        Column(
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: const Color(0xFF6C63FF).withOpacity(0.25)),
              ),
              child: Icon(step['icon'] as IconData,
                  color: const Color(0xFF6C63FF), size: 20.sp),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 32.h,
                margin: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: isLast ? 0 : 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'] as String,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  step['desc'] as String,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Reward Milestones
// ──────────────────────────────────────────────
class _RewardMilestones extends StatelessWidget {
  final ReferController controller;
  const _RewardMilestones({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: controller.rewards.asMap().entries.map((e) {
            final reward = e.value;
            final unlocked =
                controller.totalReferred.value >= (reward['referred'] as int);
            return _MilestoneTile(reward: reward, unlocked: unlocked);
          }).toList(),
        ));
  }
}

class _MilestoneTile extends StatelessWidget {
  final Map<String, dynamic> reward;
  final bool unlocked;
  const _MilestoneTile({required this.reward, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: unlocked
            ? const Color(0xFF6C63FF).withOpacity(0.06)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: unlocked
              ? const Color(0xFF6C63FF).withOpacity(0.25)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: unlocked
                  ? const Color(0xFF6C63FF).withOpacity(0.12)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              reward['icon'] as IconData,
              color: unlocked
                  ? const Color(0xFF6C63FF)
                  : Colors.grey.shade400,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward['reward'] as String,
                  style: TextStyle(
                    color: unlocked ? Colors.black87 : Colors.black45,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Invite ${reward['referred']} friend${(reward['referred'] as int) > 1 ? 's' : ''}',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: unlocked
                  ? Colors.green.shade50
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: unlocked
                    ? Colors.green.shade200
                    : Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  unlocked
                      ? Icons.check_circle_rounded
                      : Icons.lock_outline_rounded,
                  color: unlocked
                      ? Colors.green.shade600
                      : Colors.grey.shade400,
                  size: 13.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  unlocked ? 'Unlocked' : 'Locked',
                  style: TextStyle(
                    color: unlocked
                        ? Colors.green.shade700
                        : Colors.grey.shade500,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
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

// ──────────────────────────────────────────────
// Share Button
// ──────────────────────────────────────────────
class _ShareButton extends StatelessWidget {
  final ReferController controller;
  const _ShareButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.shareCode,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF9C8FFF)],
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.share_rounded, color: Colors.white, size: 20.sp),
            SizedBox(width: 10.w),
            Text(
              'Share Invite Link',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Section Title
// ──────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}