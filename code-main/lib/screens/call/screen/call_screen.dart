import 'package:beecode/screens/call/controller/call_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LearnerSupportSection extends StatelessWidget {
  const LearnerSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "BeeCode Support",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Talk to our experts. We are available 7 days a week.",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SupportButton(
                icon: Icons.call,
                label: "Call",
                color: Colors.green,
                onTap: () => showSupportSheet(),
              ),
              _SupportButton(
                icon: Icons.email,
                label: "Email",
                color: Colors.blue,
                onTap: () => showSupportSheet(),
              ),
              _SupportButton(
                icon: Icons.chat,
                label: "Chat",
                color: Colors.teal,
                onTap: () => showSupportSheet(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Category list
// ─────────────────────────────────────────────
const List<Map<String, dynamic>> _ticketCategories = [
  {"label": "Payment Issue",      "icon": Icons.payment},
  {"label": "Course Not Loading", "icon": Icons.play_circle_outline},
  {"label": "Certificate Issue",  "icon": Icons.card_membership},
  {"label": "Login / Account",    "icon": Icons.lock_outline},
  {"label": "Refund Request",     "icon": Icons.currency_rupee},
  {"label": "Other",              "icon": Icons.help_outline},
];

// ─────────────────────────────────────────────
// Category picker sheet
// ─────────────────────────────────────────────
void _showCategorySheet({required Function(String) onSelected}) {
  Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Select Category",
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4.h),
          Text(
            "Choose the category that best describes your issue.",
            style: TextStyle(fontSize: 12.sp, color: Colors.black54),
          ),
          SizedBox(height: 16.h),
          ..._ticketCategories.map(
            (cat) => GestureDetector(
              onTap: () {
                Get.back();
                onSelected(cat["label"] as String);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(cat["icon"] as IconData,
                        size: 20.sp, color: Colors.black87),
                    SizedBox(width: 12.w),
                    Text(
                      cat["label"] as String,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right,
                        size: 18.sp, color: Colors.black38),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

// ─────────────────────────────────────────────
// Raise a Ticket sheet
// ─────────────────────────────────────────────
void showRaiseTicketSheet() {
  Get.bottomSheet(
    const _RaiseTicketSheetBody(),
    isScrollControlled: true,
  );
}

class _RaiseTicketSheetBody extends StatefulWidget {
  const _RaiseTicketSheetBody();

  @override
  State<_RaiseTicketSheetBody> createState() => _RaiseTicketSheetBodyState();
}

class _RaiseTicketSheetBodyState extends State<_RaiseTicketSheetBody> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  String? selectedCategory;

  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Raise a Ticket",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4.h),
            Text(
              "Describe your issue and our team will get back to you.",
              style: TextStyle(fontSize: 12.sp, color: Colors.black54),
            ),
            SizedBox(height: 20.h),

            // ── Subject ──
            Text("Subject",
                style: TextStyle(
                    fontSize: 13.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 6.h),
            TextField(
              controller: subjectController,
              style: TextStyle(fontSize: 13.sp),
              decoration: InputDecoration(
                hintText: "e.g. Payment issue, Course not loading…",
                hintStyle:
                    TextStyle(fontSize: 12.sp, color: Colors.black38),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w, vertical: 10.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 14.h),

            // ── Message ──
            Text("Message",
                style: TextStyle(
                    fontSize: 13.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 6.h),
            TextField(
              controller: messageController,
              maxLines: 4,
              style: TextStyle(fontSize: 13.sp),
              decoration: InputDecoration(
                hintText: "Describe your issue in detail…",
                hintStyle:
                    TextStyle(fontSize: 12.sp, color: Colors.black38),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w, vertical: 10.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 14.h),

            // ── Issue Category ──
            Text("Issue Category",
                style: TextStyle(
                    fontSize: 13.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 6.h),
            GestureDetector(
              onTap: () => _showCategorySheet(
                onSelected: (val) => setState(() => selectedCategory = val),
              ),
              child: Container(
                width: double.infinity,
                height: 44.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: selectedCategory != null
                      ? Colors.black
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: selectedCategory != null
                        ? Colors.black
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedCategory != null
                          ? Icons.check_circle_outline
                          : Icons.category_outlined,
                      size: 18.sp,
                      color: selectedCategory != null
                          ? Colors.white
                          : Colors.black54,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        selectedCategory ?? "Select a category",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: selectedCategory != null
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: selectedCategory != null
                              ? Colors.white
                              : Colors.black45,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20.sp,
                      color: selectedCategory != null
                          ? Colors.white
                          : Colors.black38,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // ── Submit ──
            GestureDetector(
              onTap: () {
                // TODO: wire up your ticket submission logic here
                Get.back();
                Get.snackbar(
                  "Ticket Raised",
                  "We'll get back to you shortly!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black,
                  colorText: Colors.white,
                  borderRadius: 10.r,
                  margin: EdgeInsets.all(16.w),
                );
              },
              child: Container(
                width: double.infinity,
                height: 46.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    "Submit Ticket",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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

void showSupportSheet() {
  Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),

          Text(
            "Contact Support",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 20.h),

          // ── Raise a Ticket button only (no form here) ──
          GestureDetector(
            onTap: () {
              Get.back();                // close this sheet first
              showRaiseTicketSheet();    // then open ticket form sheet
            },
            child: Container(
              width: double.infinity,
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_number_outlined,
                      color: Colors.white, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(
                    "Raise a Ticket",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),

          Row(
            children: [
              Expanded(
                child: _SheetItem(
                  icon: Icons.call,
                  title: "Call Us",
                  subtitle: "+91 734 757 4707",
                  onTap: () {
                    Get.back();
                    LearnerSupportController.makeCall("734 757 4707");
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _SheetItem(
                  icon: Icons.email,
                  title: "Email Us",
                  subtitle: "support@beecode.com",
                  onTap: () {
                    Get.back();
                    LearnerSupportController.launchEmail(
                      to: "support@beecode.com",
                      subject: "Support Query",
                      body: "",
                    );
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _SheetItem(
                  icon: Icons.chat,
                  title: "Chat Us",
                  subtitle: "Chat with support",
                  onTap: () {
                    Get.back();
                    LearnerSupportController.openWhatsApp("91734 757 4707");
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

// ─────────────────────────────────────────────
// Reusable widgets
// ─────────────────────────────────────────────
class _SupportButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SupportButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: color.withOpacity(.08),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withOpacity(.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18.sp),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}