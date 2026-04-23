import 'package:beecode/screens/call/screen/call_screen.dart';
import 'package:beecode/screens/home/controller/details_controller.dart';
import 'package:beecode/screens/home/model/details_model.dart';
import 'package:beecode/screens/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
class DetailsScreen extends GetView<DetailsController> {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ APPBAR
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: _AppBarWidget(
          onBack: controller.goBack,
          controller: controller,
        ),
      ),

      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  _HeroSection(controller: controller),
                  AboutSection(),
                  _WhatYouWillLearnSection(controller: controller),
                  _CertificateSection(controller: controller),
                  _NeedToKnowSection(controller: controller),
                  _LearningPathSection(controller: controller),
                  _FaqSection(controller: controller),
                  LearnerSupportSection(),
                  SizedBox(height: 90.h),
                ],
              ),
            );
          }),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _StickyButton(controller: controller),
          ),
        ],
      ),
    );
  }
}

class _AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  final DetailsController controller;

  const _AppBarWidget({
    required this.onBack,
    required this.controller,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      shadowColor: Colors.black12,

      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 20.sp,
          color: Colors.black87,
        ),
        onPressed: onBack,
      ),

      title: Obx(() {
        return Text(
          controller.displayTitle, // ✅ FIXED (reactive safe)
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        );
      }),

      centerTitle: false,
    );
  }
}


class _HeroSection extends StatelessWidget {
  final DetailsController controller;
  const _HeroSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final info = controller.courseInfo;

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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _IIITBLogo(),
                SizedBox(width: 12.w),
                _BadgeColumn(badges: info.badges),
              ],
            ),

            SizedBox(height: 20.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                info.tagline,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 14.h),

            Text(
              info.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                height: 1.25,
                letterSpacing: -0.3,
              ),
            ),

            SizedBox(height: 20.h),

            ...info.bullets.map((b) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _BulletRow(text: b.text),
            )),

            SizedBox(height: 12.h),

            Row(
              children: [
                _AlumniStack(count: info.alumniCount),
                Container(
                  width: 1,
                  height: 40.h,
                  color: Colors.white24,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                _StarRating(rating: info.rating, count: info.ratingCount),
              ],
            ),

            SizedBox(height: 24.h),

            _CourseInfoCard(info: info),
          ],
        ),
      );
    });
  }
}
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ABOUT THIS PROGRAM',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'About ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: 'the Course',
                  style: TextStyle(
                    color: AppColors.prime,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Learn to design intelligent AI systems using neural networks, machine learning frameworks, and modern AI tools.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14.sp,
              height: 1.65,
            ),
          ),
          SizedBox(height: 24.h),
          Container(width: 50.w, height: 3.h, color: AppColors.prime),
          SizedBox(height: 24.h),
          Row(
            children: [
              _statCell(Icons.school_outlined,      '10k+', 'Alumni'),
              _divider(),
              _statCell(Icons.description_outlined,  '30+',  'Projects'),
              _divider(),
              _statCell(Icons.star_outline_rounded,  '4.5',  'Rating'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCell(IconData icon, String value, String label) => Expanded(
        child: Column(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColors.prime.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.prime, size: 20.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );

  Widget _divider() => Container(
        width: 1,
        height: 60.h,
        color: Colors.black12,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
      );
}
class _WhatYouWillLearnSection extends StatelessWidget {
  final DetailsController controller;
  const _WhatYouWillLearnSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F8F8),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KEY HIGHLIGHTS',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: 'What You Will ',
                style: TextStyle(color: Colors.black87, fontSize: 22.sp, fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: 'Learn',
                style: TextStyle(color: AppColors.prime, fontSize: 22.sp, fontWeight: FontWeight.w800),
              ),
            ]),
          ),
          SizedBox(height: 20.h),

          // Timeline + Cards using Stack for precise dot alignment
          ...List.generate(controller.curriculumModules.length, (i) {
            final isLast = i == controller.curriculumModules.length - 1;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Timeline column
                  SizedBox(
                    width: 20.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 18.h),
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: AppColors.prime,
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: CustomPaint(
                                painter: _DashedLinePainter(),
                                child: const SizedBox(width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  // Card
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
                      child: _AccordionTile(module: controller.curriculumModules[i]),
                    ),
                  ),
                ],
              ),
            );
          }),

          SizedBox(height: 24.h),

          // Download full curriculum button
          Obx(() => GestureDetector(
                onTap: controller.downloadBrochure,
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller.isDownloading.value
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.black87),
                            )
                          : Icon(Icons.download_outlined, color: Colors.white, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Download full curriculum',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
// ignore: unused_element
class _TimelineDot extends StatelessWidget {
  final bool isLast;
  const _TimelineDot({required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Container(
          width: 10.w, height: 10.w,
          decoration: BoxDecoration(color: AppColors.prime, shape: BoxShape.circle),
        ),
        if (!isLast)
          CustomPaint(
            size: Size(2.w, 100.h),
            painter: _DashedLinePainter(),
          ),
      ],
    );
  }
}
class _AccordionTile extends StatefulWidget {
  final CurriculumModule module;
  const _AccordionTile({required this.module});

  @override
  State<_AccordionTile> createState() => _AccordionTileState();
}

class _AccordionTileState extends State<_AccordionTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _animController.forward() : _animController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.module.title,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (widget.module.isSpecialization) ...[
                              SizedBox(width: 6.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3E0),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(color: const Color(0xFFFFB74D)),
                                ),
                                child: Text(
                                  'Specialization',
                                  style: TextStyle(
                                    color: const Color(0xFFE65100),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Text(
                              widget.module.courseNumber,
                              style: TextStyle(color: Colors.black45, fontSize: 12.sp),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: Container(
                                width: 4.w, height: 4.w,
                                decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Text(
                              widget.module.duration,
                              style: TextStyle(color: Colors.black45, fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 32.w, height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.prime.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(Icons.keyboard_arrow_down, color: AppColors.prime, size: 20.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expandable Content ──
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(height: 1, color: Colors.black12),

                // Description
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
                  child: Text(
                    widget.module.description,
                    style: TextStyle(color: Colors.black54, fontSize: 13.sp, height: 1.5),
                  ),
                ),

                // Topics covered
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
                  child: Text(
                    'Topics covered',
                    style: TextStyle(color: Colors.black87, fontSize: 13.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                ...widget.module.topics.map(
                  (topic) => Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.black45, size: 16.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            topic,
                            style: TextStyle(color: Colors.black54, fontSize: 13.sp, height: 1.45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Skills acquired
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 6.h),
                  child: Text(
                    'Skills acquired',
                    style: TextStyle(color: Colors.black87, fontSize: 13.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: widget.module.skills.map((skill) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Text(
                            skill,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )).toList(),
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
class _CertificateSection extends StatelessWidget {
  final DetailsController controller;
  const _CertificateSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Executive Diploma In Machine Learning & AI',
            style: TextStyle(color: Colors.black54, fontSize: 11.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: 'Earn and Share ',
                style: TextStyle(color: AppColors.prime, fontSize: 22.sp, fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: 'Your\nCertificate',
                style: TextStyle(color: Colors.black87, fontSize: 22.sp, fontWeight: FontWeight.w800),
              ),
            ]),
          ),
          SizedBox(height: 20.h),
          Container(width: 50.w, height: 3.h, color: AppColors.prime),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.prime, width: 1.5),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: _CertificateMockup(),
            ),
          ),
          SizedBox(height: 28.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.certificateHighlights.length,
            separatorBuilder: (_, _) => SizedBox(height: 20.h),
            itemBuilder: (_, i) => _CertHighlightTile(highlight: controller.certificateHighlights[i]),
          ),
        ],
      ),
    );
  }
}

class _CertificateMockup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: 'Bee',
                style: TextStyle(color: AppColors.prime, fontSize: 24.sp, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
              ),
              TextSpan(
                text: 'Code',
                style: TextStyle(color: Colors.black87, fontSize: 24.sp, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
              ),
            ]),
          ),
          SizedBox(height: 10.h),
          Text(
            'CERTIFICATE OF COMPLETION',
            style: TextStyle(color: Colors.black87, fontSize: 11.sp, fontWeight: FontWeight.w700, letterSpacing: 1.5),
          ),
          SizedBox(height: 12.h),
          Text('This is to certify that', style: TextStyle(color: Colors.black45, fontSize: 10.sp)),
          SizedBox(height: 10.h),
          Container(height: 0.8, color: Colors.black12),
          SizedBox(height: 10.h),
          Text('has successfully completed the course on', style: TextStyle(color: Colors.black45, fontSize: 10.sp)),
          SizedBox(height: 6.h),
          Text(
            'Executive Diploma in Machine Learning & AI',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87, fontSize: 12.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10.h),
          Container(height: 0.8, color: Colors.black12),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('12 March, 2026', style: TextStyle(color: Colors.black87, fontSize: 10.sp, fontWeight: FontWeight.w600)),
                  Text('Issued on', style: TextStyle(color: Colors.black45, fontSize: 9.sp)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('~ Director', style: TextStyle(color: Colors.black54, fontSize: 10.sp, fontStyle: FontStyle.italic)),
                  Text('Rahul Sharma', style: TextStyle(color: Colors.black87, fontSize: 10.sp, fontWeight: FontWeight.w600)),
                  Text('Co-founder & MD', style: TextStyle(color: Colors.black45, fontSize: 9.sp)),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 0.8, color: Colors.black12),
          SizedBox(height: 8.h),
          Text(
            'AI Education Pvt. Ltd. · 123 Tech Park, Bengaluru – 560001',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black38, fontSize: 8.sp),
          ),
        ],
      ),
    );
  }
}

class _CertHighlightTile extends StatelessWidget {
  final CertificateHighlight highlight;
  const _CertHighlightTile({required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w, height: 40.w,
          decoration: BoxDecoration(color: AppColors.prime.withOpacity(0.08), shape: BoxShape.circle),
          child: Icon(highlight.icon, color: AppColors.prime, size: 18.sp),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(highlight.title, style: TextStyle(color: Colors.black87, fontSize: 15.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 4.h),
              Text(highlight.description, style: TextStyle(color: Colors.black54, fontSize: 13.sp, height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}

class _NeedToKnowSection extends StatelessWidget {
  final DetailsController controller;
  const _NeedToKnowSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Need to know more?', style: TextStyle(color: Colors.black87, fontSize: 20.sp, fontWeight: FontWeight.w800)),
          SizedBox(height: 8.h),
          Text(
            'Get all the details you need about the Executive Diploma in Machine Learning & AI, whenever you want them.',
            style: TextStyle(color: Colors.black54, fontSize: 13.sp, height: 1.5),
          ),
          SizedBox(height: 18.h),
          Obx(() => _CTAButton(
                label: 'Download Brochure',
                isLoading: controller.isDownloading.value,
                onTap: controller.downloadBrochure,
              )),
        ],
      ),
    );
  }
}

class _LearningPathSection extends StatelessWidget {
  final DetailsController controller;
  const _LearningPathSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 24.h,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
        ],
      ),
    );
  }
}

class _StickyButton extends StatelessWidget {
  final DetailsController controller;
  const _StickyButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
  decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
  ),
  child: Obx(() => _DualCTAButton(
    label1: 'BeeCode Pro',
    label2: 'Start learning',
    isLoading1: controller.isApplying.value,
    isLoading2: controller.isDownloading.value,
    onTap1: controller.beeCodePro,
    onTap2: controller.startlearning,
    
  )),
);
  }
}

class _IIITBLogo extends StatelessWidget {
  const _IIITBLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32.w, height: 32.h,
            decoration: BoxDecoration(color: const Color(0xFF1A3A6B), borderRadius: BorderRadius.circular(6.r)),
            child: Center(child: Text('iiit-b', style: TextStyle(color: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.w800))),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('International',            style: TextStyle(fontSize: 7.sp, color: Colors.black87)),
              Text('Institute of Information', style: TextStyle(fontSize: 7.sp, color: Colors.black87)),
              Text('Technology Bangalore',     style: TextStyle(fontSize: 7.sp, color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgeColumn extends StatelessWidget {
  final List<BadgeModel> badges;
  const _BadgeColumn({required this.badges});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: badges.map((b) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD4A843)),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(b.label, style: TextStyle(color: const Color(0xFFD4A843), fontSize: 10.sp, fontWeight: FontWeight.w600)),
            ),
          )).toList(),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String text;
  const _BulletRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: Icon(Icons.check_circle_outline, color: Colors.white70, size: 16.sp),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(text, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13.sp, height: 1.5)),
        ),
      ],
    );
  }
}

class _AlumniStack extends StatelessWidget {
  final int count;
  const _AlumniStack({required this.count});

  @override
  Widget build(BuildContext context) {
    const avatarColors = [Color(0xFF4A90D9), Color(0xFF7B5EA7), Color(0xFFE8A87C)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70.w, height: 32.h,
          child: Stack(
            children: List.generate(3, (i) => Positioned(
              left: i * 18.0.w,
              child: Container(
                width: 32.w, height: 32.h,
                decoration: BoxDecoration(shape: BoxShape.circle, color: avatarColors[i], border: Border.all(color: const Color(0xFF0D2044), width: 2)),
                child: Icon(Icons.person, color: Colors.white, size: 16.sp),
              ),
            )),
          ),
        ),
        SizedBox(height: 4.h),
        RichText(
          text: TextSpan(children: [
            TextSpan(text: 'Join ', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
            TextSpan(text: '${count}k+ alumni', style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w700)),
          ]),
        ),
      ],
    );
  }
}

class _StarRating extends StatelessWidget {
  final String rating;
  final int count;
  const _StarRating({required this.rating, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: List.generate(5, (i) => Icon(i < 4 ? Icons.star : Icons.star_half, color: const Color(0xFFFFC107), size: 18.sp))),
        SizedBox(height: 4.h),
        Text('$rating ($count ratings)', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
      ],
    );
  }
}

class _CourseInfoCard extends StatelessWidget {
  final CourseInfoModel info;
  const _CourseInfoCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          _infoCell('Duration', info.duration),
          _divider(),
          _infoCell('EMI Starts\nFrom', info.emiFrom),
          _divider(),
          _infoCell('Admission\nDeadline', info.admissionDeadline),
        ],
      ),
    );
  }

  Widget _infoCell(String label, String value) => Expanded(
        child: Column(
          children: [
            Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 11.sp, height: 1.4)),
            SizedBox(height: 4.h),
            Text(value, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w700, height: 1.3)),
          ],
        ),
      );

  Widget _divider() => Container(width: 1, height: 40.h, color: Colors.white24);
}

class _CTAButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const _CTAButton({required this.label, required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(width: 22.w, height: 22.h, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : Text(label, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
        ),
      ),
    );
  }
}
class _DualCTAButton extends StatelessWidget {
  final String label1;
  final String label2;
  final bool isLoading1;
  final bool isLoading2;
  final VoidCallback onTap1;
  final VoidCallback onTap2;

  const _DualCTAButton({
    required this.label1, required this.label2,
    required this.isLoading1, required this.isLoading2,
    required this.onTap1, required this.onTap2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 43.h,
      child: Row(
        children: [
          _half(label1, isLoading1, onTap1,
              icon: FontAwesomeIcons.crown,
              colors: [ const Color(0xFF1E40AF),Color.fromARGB(255, 62, 101, 230), const Color(0xFF1E40AF)],
              textColor: Colors.white),
          SizedBox(width: 5.w),
          _half(label2, isLoading2, onTap2,
              colors: [AppColors.black, const Color(0xFF333333)],
              textColor: Colors.white),
        ],
      ),
    );
  }
  Widget _half(String label, bool loading, VoidCallback onTap,
      {IconData? icon,
      List<Color> colors = const [Colors.black, Colors.black],
      Color textColor = Colors.white}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 22.w, height: 22.h,
                    child: CircularProgressIndicator(
                        color: textColor, strokeWidth: 2.5))
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        FaIcon(icon, color: textColor, size: 18.sp),
                        SizedBox(width: 6.w),
                      ],
                      Text(label,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashHeight = 5.0;
    const dashSpace  = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _FaqSection extends StatelessWidget {
  final DetailsController controller;
  const _FaqSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              color: AppColors.prime,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 20.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.faqCategories.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (_, i) => _FaqCategoryTile(
              category: controller.faqCategories[i],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqCategoryTile extends StatefulWidget {
  final FaqCategory category;
  const _FaqCategoryTile({required this.category});

  @override
  State<_FaqCategoryTile> createState() => _FaqCategoryTileState();
}

class _FaqCategoryTileState extends State<_FaqCategoryTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _animController.forward() : _animController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          // ── Header ──
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.category.title,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black45,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                Divider(height: 1, color: Colors.black12),
                ...widget.category.questions.map(
                  (faq) => _FaqItemTile(faq: faq),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItemTile extends StatefulWidget {
  final FaqItem faq;
  const _FaqItemTile({required this.faq});

  @override
  State<_FaqItemTile> createState() => _FaqItemTileState();
}

class _FaqItemTileState extends State<_FaqItemTile>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _animController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isOpen = !_isOpen;
              _isOpen ? _animController.forward() : _animController.reverse();
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.faq.question,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.prime,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
            child: Text(
              widget.faq.answer,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13.sp,
                height: 1.6,
              ),
            ),
          ),
        ),
        Divider(height: 1, color: Colors.black12),
      ],
    );
  }
}

// class CourseFeeSection extends GetView<CourseFeeController> {
//   const CourseFeeSection({super.key});
 
//   @override
//   CourseFeeController get controller {
//     if (!Get.isRegistered<CourseFeeController>()) {
//       return Get.put(CourseFeeController());
//     }
//     return Get.find<CourseFeeController>();
//   }
 
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Header ──
//           Text(
//             'Executive Diploma In AI And ML Course Fees',
//             style: TextStyle(
//               fontSize: 13.sp,
//               color: Colors.black54,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           SizedBox(height: 6.h),
//           RichText(
//             text: TextSpan(children: [
//               TextSpan(
//                 text: 'Invest In ',
//                 style: TextStyle(
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.w800,
//                   color: Colors.black87,
//                 ),
//               ),
//               TextSpan(
//                 text: 'Your Success',
//                 style: TextStyle(
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.w800,
//                   color: AppColors.prime,
//                 ),
//               ),
//             ]),
//           ),
//           SizedBox(height: 20.h),
 
//           // ── Tab Bar ──
//           Obx(() => _TabBar(
//                 tabs: controller.tabs,
//                 selectedIndex: controller.selectedTab.value,
//                 onTap: controller.selectTab,
//               )),
//           SizedBox(height: 20.h),
 
//           // ── Pricing Card ──
//           Obx(() => _PricingCard(plan: controller.currentPlan)),
//           SizedBox(height: 16.h),
//         ],
//       ),
//     );
//   }
// }
 
class _TabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final void Function(int) onTap;
 
  const _TabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(tabs.length, (i) {
              final isSelected = i == selectedIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                child: Padding(
                  padding: EdgeInsets.only(right: 24.w),
                  child: Text(
                    tabs[i],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected ? Colors.black87 : Colors.black45,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 10.h),
        // Animated underline
        LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              // Full divider
              Container(height: 1.5, color: Colors.grey.shade200),
              // Active tab indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: _getIndicatorLeft(constraints.maxWidth),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 2.5.h,
                  width: _getIndicatorWidth(),
                  decoration: BoxDecoration(
                    color: AppColors.prime,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
 
  double _getIndicatorLeft(double totalWidth) {
    // Approximate: first tab is shorter
    if (selectedIndex == 0) return 0;
    // Rough offset for second tab
    return 90.0;
  }
 
  double _getIndicatorWidth() {
    // First tab "Course Fee" ≈ 80, second tab is longer
    return selectedIndex == 0 ? 80.0 : 220.0;
  }
}
 
// ─────────────────────────────────────────────
// PRICING CARD
// ─────────────────────────────────────────────
class _PricingCard extends StatelessWidget {
  final CourseFeeModel plan;
  const _PricingCard({required this.plan});
 
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Container(
        key: ValueKey(plan.label),
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Duration badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                plan.duration,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            SizedBox(height: 16.h),
 
            // Starting at
            Text(
              'Starting at',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4.h),
 
            // Monthly price
            Text(
              plan.monthlyPrice,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.prime,
                height: 1.2,
              ),
            ),
            SizedBox(height: 8.h),
 
            // Total price
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Totally ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: plan.totalPrice,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: '  Incl. Taxes',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black38,
                  ),
                ),
              ]),
            ),
            SizedBox(height: 20.h),
 
            // Divider
            Divider(color: Colors.grey.shade100, height: 1),
            SizedBox(height: 16.h),
 
            // Inclusions
            Text(
              'Inclusions',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10.h),
            ...plan.inclusions.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 18.sp,
                        color: AppColors.prime,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                SizedBox(height: 10.h,),
                  Center(
            child: GestureDetector(
              // onTap: controller.viewPlans,
              child: Text(
                'View Plans',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black87,
                  decorationThickness: 1.5,
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
 