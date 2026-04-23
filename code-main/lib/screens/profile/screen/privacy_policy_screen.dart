import 'package:beecode/screens/profile/model/privacy_policy_model.dart';
import 'package:beecode/screens/profile/viewmodel/privacy_policy_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class PrivacyPolicyScreen extends GetView<PrivacyPolicyViewModel> {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.hasClients) {
        controller.onScroll(
          scrollController.offset,
          scrollController.position.maxScrollExtent,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading) return const _LoadingView();
        if (controller.hasError) {
          return _ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.retryLoad,
          );
        }
        return Column(
          children: [
            _TopBar(vm: controller),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroHeader(vm: controller),
                    SizedBox(height: 14.h),
                    _QuickStats(vm: controller),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(label: 'Policy Sections'),
                          SizedBox(height: 14.h),
                          _AccordionList(vm: controller),
                          SizedBox(height: 24.h),
                          _ContactCard(vm: controller),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _BottomBar(vm: controller),
          ],
        );
      }),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.h,
            child: const CircularProgressIndicator(
              color: Color(0xFF6C63FF),
              strokeWidth: 2.5,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading policy...',
            style: TextStyle(color: Colors.black45, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                color: Colors.red.shade300, size: 48.sp),
            SizedBox(height: 16.h),
            Text(message,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black54, fontSize: 13.sp, height: 1.5)),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text('Try Again',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _TopBar extends StatelessWidget {
  final PrivacyPolicyViewModel vm;
  const _TopBar({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 16.w,
        right: 16.w,
        bottom: 12.h,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _IconBtn(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Get.back(),
              ),
              Expanded(
                child: Text(
                  'Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700),
                ),
              ),
              _IconBtn(
                icon: Icons.ios_share_rounded,
                onTap: vm.sharePolicy,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reading progress',
                          style: TextStyle(
                              color: Colors.black38, fontSize: 11.sp)),
                      Text(
                        '${(vm.scrollProgress.value * 100).toInt()}%',
                        style: TextStyle(
                            color: const Color(0xFF1565C0),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: vm.scrollProgress.value,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF6C63FF)),
                      minHeight: 5.h,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final PrivacyPolicyViewModel vm;
  const _HeroHeader({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
         colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(Icons.privacy_tip_rounded,
                color: Colors.white, size: 28.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Privacy Matters',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 4.h),
                Text('Last updated: ${vm.lastUpdated}',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12.sp)),
                SizedBox(height: 2.h),
                Text(vm.version,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 11.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  final PrivacyPolicyViewModel vm;
  const _QuickStats({required this.vm});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'icon': Icons.article_outlined,
        'value': '${vm.totalSections}',
        'label': 'Sections'
      },
      {'icon': Icons.timer_outlined, 'value': '5 min', 'label': 'Read time'},
      {'icon': Icons.shield_outlined, 'value': 'GDPR', 'label': 'Compliant'},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: stats
            .map((s) => Expanded(
                  child: Column(
                    children: [
                      Icon(s['icon'] as IconData,
                          color:  Color(0xFF1565C0), size: 20.sp),
                      SizedBox(height: 6.h),
                      Text(s['value'] as String,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800)),
                      SizedBox(height: 2.h),
                      Text(s['label'] as String,
                          style: TextStyle(
                              color: Colors.black38, fontSize: 11.sp)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _AccordionList extends StatelessWidget {
  final PrivacyPolicyViewModel vm;
  const _AccordionList({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: vm.sections.asMap().entries.map((e) {
            return _AccordionTile(
              section: e.value,
              index: e.key,
              isExpanded: vm.expandedIndex.value == e.key,
              onTap: () => vm.toggleSection(e.key),
            );
          }).toList(),
        ));
  }
}

class _AccordionTile extends StatelessWidget {
  final PrivacyPolicySection section;
  final int index;
  final bool isExpanded;
  final VoidCallback onTap;

  const _AccordionTile({
    required this.section,
    required this.index,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: isExpanded
              ? const Color(0xFF1565C0).withOpacity(0.04)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isExpanded
                ? const Color(0xFF1565C0).withOpacity(0.3)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(14.r),
              child: Row(
                children: [
                  Container(
                    width: 38.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? const Color(0xFF1565C0).withOpacity(0.12)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(section.icon,
                        color: isExpanded
                            ? const Color(0xFF1565C0)
                            : Colors.black45,
                        size: 18.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(section.title,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: 2.h),
                        Text(section.short,
                            style: TextStyle(
                                color: Colors.black38, fontSize: 11.sp)),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: isExpanded
                            ? const Color(0xFF1565C0)
                            : Colors.black38,
                        size: 22.sp),
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 14.h),
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(section.content,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.sp,
                        height: 1.7)),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final PrivacyPolicyViewModel vm;
  const _ContactCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: vm.copyEmail,
      child: Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: vm.codeCopied.value
                  ? Colors.green.shade50
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: vm.codeCopied.value
                    ? Colors.green.shade200
                    : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: vm.codeCopied.value
                        ? Colors.green.withOpacity(0.12)
                        : const Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    vm.codeCopied.value
                        ? Icons.check_rounded
                        : Icons.mail_outline_rounded,
                    color: vm.codeCopied.value
                        ? Colors.green.shade600
                        : const Color(0xFF6C63FF),
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Have questions?',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 2.h),
                      Text(vm.contactEmail,
                          style: TextStyle(
                              color: const Color(0xFF6C63FF),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Icon(
                  vm.codeCopied.value
                      ? Icons.check_circle_outline_rounded
                      : Icons.copy_outlined,
                  color: vm.codeCopied.value
                      ? Colors.green.shade400
                      : Colors.black26,
                  size: 16.sp,
                ),
              ],
            ),
          )),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final PrivacyPolicyViewModel vm;
  const _BottomBar({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20.w, 14.h, 20.w, MediaQuery.of(context).padding.bottom + 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!vm.hasReadPolicy.value)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: Colors.orange.shade400, size: 14.sp),
                      SizedBox(width: 6.w),
                      Text('Please scroll to read the full policy',
                          style: TextStyle(
                              color: Colors.orange.shade600,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              GestureDetector(
                onTap:
                    vm.hasReadPolicy.value ? vm.acceptPolicy : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    gradient: vm.hasReadPolicy.value
                        ?  LinearGradient(
                         colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
                          )
                        : null,
                    color: vm.hasReadPolicy.value
                        ? null
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: vm.hasReadPolicy.value
                        ? [
                            BoxShadow(
                              color: const Color(0xFF1565C0).withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        vm.hasReadPolicy.value
                            ? Icons.check_circle_rounded
                            : Icons.lock_outline_rounded,
                        color: vm.hasReadPolicy.value
                            ? Colors.white
                            : Colors.black38,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        vm.hasReadPolicy.value
                            ? 'I Accept the Privacy Policy'
                            : 'Read policy to continue',
                        style: TextStyle(
                            color: vm.hasReadPolicy.value
                                ? Colors.white
                                : Colors.black38,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

// ─────────────────────────────────────────────
// Shared Widgets
// ─────────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: Colors.black54, size: 16.sp),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: TextStyle(
            color: Colors.black87,
            fontSize: 16.sp,
            fontWeight: FontWeight.w800));
  }
}