import 'package:beecode/screens/ai/controller/ai_controller.dart';
import 'package:beecode/screens/ai/model/ai_model.dart';
import 'package:beecode/screens/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AiChatScreen extends GetView<AiChatController> {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF111111),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFF0D0D0D),
          appBar: _buildAppBar(),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildMessageList()),
                _buildErrorBanner(),
                _buildInputBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF111111),
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Icon(Icons.arrow_back, color: Colors.white, size: 18.sp),
      ),
      title: Row(
        children: [
           SizedBox(
                  height: 50.h * 1,
                  width: 50.w * 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Lottie.asset(
                      //   'assets/aiIcon.json',
                      //   height: _fabSize /2,   
                      //   width: _fabSize /2,
                      //   repeat: true,
                      // ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset(
                          AppImages.beebitesicon,
                           fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(width: 5.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gemini Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(() => Text(
                    controller.isStreaming.value ? 'Typing...' : 'Online',
                    style: TextStyle(
                      color: controller.isStreaming.value
                          ? const Color(0xFF4F8EF7)
                          : Colors.green,
                      fontSize: 11.sp,
                    ),
                  )),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.white54, size: 20.sp),
          onPressed: _showClearDialog,
        )
      ],
    );
  }

  Widget _buildMessageList() {
    return Obx(() {
      if (controller.messages.isEmpty) return _buildEmptyState();

      return ListView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final msg = controller.messages[index];
          return _MessageBubble(message: msg);
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   width: 80.w,
          //   height: 80.h,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     gradient: const LinearGradient(
          //       colors: [Color(0xFF4F8EF7), Color(0xFF8B5CF6)],
          //     ),
          //     boxShadow: [
          //       BoxShadow(
          //         color: const Color(0xFF8B5CF6).withOpacity(0.3),
          //         blurRadius: 30.r,
          //       ),
          //     ],
          //   ),
          //   child: Icon(Icons.auto_awesome, color: Colors.white, size: 36.sp),
          // ),
          SizedBox(
                  height: 100.h * 1,
                  width: 100.w * 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Lottie.asset(
                      //   'assets/aiIcon.json',
                      //   height: _fabSize /2,   
                      //   width: _fabSize /2,
                      //   repeat: true,
                      // ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(56),
                        child: Image.asset(
                          AppImages.beebitesicon,

                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
          // SizedBox(height: 20.h),
          Text(
            'How can I help you today?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Powered by Gemini',
            style: TextStyle(color: Colors.white38, fontSize: 13.sp),
          )
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Obx(() {
      if (controller.errorMessage.value.isEmpty) return const SizedBox();

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.red.shade900.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Colors.orange, size: 16.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                controller.errorMessage.value,
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
            ),
            GestureDetector(
              onTap: () => controller.errorMessage.value = '',
              child: Icon(Icons.close, color: Colors.white54, size: 16.sp),
            )
          ],
        ),
      );
    });
  }

  Widget _buildInputBar() {
    return Container(
      color: const Color(0xFF111111),
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 16.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white12),
              ),
              child: TextField(
                controller: controller.inputController,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: controller.sendMessage,
                decoration: InputDecoration(
                  hintText: 'Ask Gemini anything...',
                  hintStyle:
                      TextStyle(color: Colors.white38, fontSize: 14.sp),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: controller.isStreaming.value
                    ? _StopButton(onTap: controller.cancelStream)
                    : _SendButton(
                        onTap: () => controller
                            .sendMessage(controller.inputController.text),
                      ),
              )),
        ],
      ),
    );
  }

  void _showClearDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title:
            Text('Clear Chat', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
        content: Text('Delete all messages?',
            style: TextStyle(color: Colors.white60, fontSize: 13.sp)),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('Cancel',
                style: TextStyle(color: Colors.white38, fontSize: 13.sp)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearChat();
            },
            child: Text('Clear',
                style: TextStyle(color: Colors.redAccent, fontSize: 13.sp)),
          )
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  bool get isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) _avatar(),
          SizedBox(width: 8.w),
          Flexible(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isUser ? null : const Color(0xFF1E1E1E),
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF4F8EF7), Color(0xFF3B6FE4)],
                      )
                    : null,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Obx(() => Text(
                    message.text.value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        height: 1.5),
                  )),
            ),
          ),
          SizedBox(width: 8.w),
          if (isUser) _avatar(),
        ],
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 30.w,
      height: 30.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
        ),
      ),
      child: Icon(Icons.auto_awesome, color: Colors.white, size: 16.sp),
    );
  }
}

class _SendButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SendButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46.w,
        height: 46.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF4F8EF7), Color(0xFF8B5CF6)],
          ),
        ),
        child: Icon(Icons.send_rounded, color: Colors.white, size: 22.sp),
      ),
    );
  }
}

class _StopButton extends StatelessWidget {
  final VoidCallback onTap;

  const _StopButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46.w,
        height: 46.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red.shade800,
        ),
        child: Icon(Icons.stop_rounded, color: Colors.white, size: 22.sp),
      ),
    );
  }
}