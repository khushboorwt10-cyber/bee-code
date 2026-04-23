import 'dart:io';

import 'package:beecode/screens/call/screen/call_screen.dart';
import 'package:beecode/screens/beebites/controller/beebites_controller.dart';
import 'package:beecode/screens/beebites/model/beebites_model.dart';
import 'package:beecode/screens/utils/images.dart';
import 'package:beecode/screens/utils/route.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:beecode/widget/share_custom.dart';
import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void showCourseBottomSheet(BuildContext context, BeeBitesModel reel) {
  final courseIndex = (int.tryParse(reel.id) ?? 1) - 1;
  final course = dummyCourses[courseIndex % dummyCourses.length];
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _CourseDetailSheet(course: course),
  );
}

class _CourseDetailSheet extends StatelessWidget {
  final CourseModel course;
  const _CourseDetailSheet({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
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
          SizedBox(height: 20.h),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                 Container(
  width: double.infinity,
  height: 160.h,
  decoration: BoxDecoration(
    color: course.color.withOpacity(0.08),
    borderRadius: BorderRadius.circular(16.r),
    border: Border.all(
      color: course.color.withOpacity(0.2),
      width: 1,
    ),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(16.r),
    child: Image.asset(
      AppImages.aiml,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    ),
  ),
),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: course.color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: course.color.withOpacity(0.3)),
                    ),
                    child: Text(
                      course.level,
                      style: TextStyle(
                        color: course.color,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Title
                  Text(
                    course.title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Subtitle
                  Text(
                    course.subtitle,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Stats
                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.access_time_rounded,
                        label: course.duration,
                        color: course.color,
                      ),
                      SizedBox(width: 12.w),
                      _StatChip(
                        icon: Icons.play_lesson_rounded,
                        label: course.lessons,
                        color: course.color,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // What you'll learn
                  Text(
                    "What you'll learn",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ..._learnPoints(course).map(
                    (point) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 3.h),
                            width: 16.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: course.color.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              color: course.color,
                              size: 10.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              point,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13.sp,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),

                  GestureDetector(
                    onTap: () {
                      Get.back();
                      // Get.toNamed(Routes.detailsScreen);
                      Get.toNamed(Routes.detailsScreen, arguments: {'title': course.title});
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: course.color,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: course.color.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Start Course',
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
                  SizedBox(height: 12.h),

                  // View All Courses button
                  GestureDetector(
                    onTap: () => Get.toNamed('/coursesScreen'),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.grid_view_rounded,
                            color: Colors.black54,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'View All Courses',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _learnPoints(CourseModel c) {
    switch (c.id) {
      case '1':
        return [
          'Set up Flutter & Dart development environment',
          'Build beautiful responsive UIs with widgets',
          'Handle user input, forms and navigation',
          'Connect to APIs and parse JSON data',
        ];
      case '2':
        return [
          'Reactive state management with Obx & GetX',
          'Named routing and route arguments',
          'Dependency injection with Get.put & Get.find',
          'GetX services, workers and bindings',
        ];
      case '3':
        return [
          'Async programming with Future & async/await',
          'Reactive streams and StreamController',
          'Isolates for background computation',
          'Null safety and advanced Dart patterns',
        ];
      case '4':
        return [
          'Firebase Authentication (email, Google, phone)',
          'Firestore real-time database & queries',
          'Firebase Storage for images & files',
          'Cloud Functions and push notifications',
        ];
      default:
        return [
          'Implicit and explicit animations',
          'Hero transitions between screens',
          'Lottie & Rive animations integration',
          'Custom painters and canvas drawing',
        ];
    }
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class BeeBitesScreen extends StatelessWidget {
  const BeeBitesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(BeeBitesController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        //  extendBody: true,
        appBar: _ReelsAppBar(),
        body: _ReelsFeed(ctrl: ctrl),
      ),
    );
  }
}

class _ReelsAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(50.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100.h,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
          ),
        ),
      ),
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(AppImages.logoapp, height: 30.h, width: 80.w),
            Row(
              children: [
                GestureDetector(
                  onTap: showSupportSheet,
                  child: const _AppBarIcon(icon: Icons.call_outlined),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => Get.toNamed("/profileScreen"),
                  child: const _AppBarIcon(icon: Icons.person_outline_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  const _AppBarIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 18.sp),
    );
  }
}

class _ReelsFeed extends StatefulWidget {
  final BeeBitesController ctrl;
  const _ReelsFeed({required this.ctrl});

  @override
  State<_ReelsFeed> createState() => _ReelsFeedState();
}

class _ReelsFeedState extends State<_ReelsFeed> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _pageController = PageController();
    _pageController.addListener(() {
      final page = _pageController.page?.round();
      if (page != null && page != widget.ctrl.selectedIndex.value) {
        widget.ctrl.selectReel(page);
      }
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: widget.ctrl.reels.length,
        itemBuilder: (context, index) =>
            _ReelItem(ctrl: widget.ctrl, index: index),
      ),
    );
  }
}

class _ReelItem extends StatelessWidget {
  final BeeBitesController ctrl;
  final int index;
  const _ReelItem({required this.ctrl, required this.index});

  @override
  Widget build(BuildContext context) {
    final reel = ctrl.reels[index];
    return Obx(() {
      final isActive = ctrl.selectedIndex.value == index;
      return Stack(
        fit: StackFit.expand,
        children: [
          _ReelVideoPlayer(reel: reel, isActive: isActive),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200.h,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 420.h,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.92),
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
          ),

          Obx(() {
            final liked = ctrl.likedIds.contains(reel.id);
            return _SideActions(
              reel: reel,
              liked: liked,
              onLike: () => ctrl.toggleLike(reel.id),
            );
          }),

          _BottomInfo(reel: reel),
        ],
      );
    });
  }
}

class _ReelVideoPlayer extends StatefulWidget {
  final BeeBitesModel reel;
  final bool isActive;
  const _ReelVideoPlayer({required this.reel, required this.isActive});

  @override
  State<_ReelVideoPlayer> createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<_ReelVideoPlayer> {
  BetterPlayerController? _controller;

  bool _isMuted = false;
  bool _isPaused = false;
  bool _showMuteIcon = false;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

//   void _initPlayer() {
//    final dataSource = BetterPlayerDataSource(
//   widget.reel.videoUrl.startsWith('http')
//       ? BetterPlayerDataSourceType.network
//       : widget.reel.videoUrl.startsWith('assets/')
//           ? BetterPlayerDataSourceType.file  // ← assets use file type
//           : BetterPlayerDataSourceType.file,
//   widget.reel.videoUrl,
// );


//     _controller = BetterPlayerController(
//       BetterPlayerConfiguration(
//         autoPlay: widget.isActive,
//         looping: true,
//         aspectRatio: 9 / 16,
//         fit: BoxFit.cover,
//         controlsConfiguration: const BetterPlayerControlsConfiguration(
//           showControls: false,
//         ),
//         autoDetectFullscreenDeviceOrientation: false,
//         allowedScreenSleep: false,
//         startAt: Duration.zero,
//       ),
//       betterPlayerDataSource: dataSource,
//     );

//     _controller!.addEventsListener((BetterPlayerEvent event) {
//       if (!mounted) return;
//       final type = event.betterPlayerEventType;
//       if (type == BetterPlayerEventType.initialized ||
//           type == BetterPlayerEventType.play) {
//         if (!_videoReady) {
//           SchedulerBinding.instance.addPostFrameCallback((_) {
//             if (mounted && !_videoReady) {
//               setState(() => _videoReady = true);
//             }
//           });
//         }
//       }
//     });
//   }
Future<void> _initPlayer() async {
  final url = widget.reel.videoUrl;
  BetterPlayerDataSource dataSource;

  if (url.startsWith('assets/')) {
    final byteData = await rootBundle.load(url);
    final tempDir = await getTemporaryDirectory();
    final fileName = url.split('/').last;
    final tempFile = File('${tempDir.path}/$fileName');
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
    await tempFile.writeAsBytes(byteData.buffer.asUint8List());

    dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      tempFile.path,
    );
  } else {
    dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
    );
  }

  _controller = BetterPlayerController(
    BetterPlayerConfiguration(
      autoPlay: widget.isActive,
      looping: true,
      aspectRatio: 9 / 16,
      fit: BoxFit.cover,
        errorBuilder: (context, errorMessage) => _buildErrorFallback(),
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        showControls: false,
      ),
      autoDetectFullscreenDeviceOrientation: false,
      allowedScreenSleep: false,
      startAt: Duration.zero,
    ),
    betterPlayerDataSource: dataSource,
  );

 _controller!.addEventsListener((BetterPlayerEvent event) {
  if (!mounted) return;
  final type = event.betterPlayerEventType;

  // 👇 Add error handling
  if (type == BetterPlayerEventType.exception) {
    debugPrint("BetterPlayer error: ${event.parameters}");
    if (mounted) {
      setState(() => _videoReady = false); 
    }
    return;
  }

  if (type == BetterPlayerEventType.initialized ||
      type == BetterPlayerEventType.play) {
    if (!_videoReady) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_videoReady) {
          setState(() => _videoReady = true);
        }
      });
    }
  }
});
  if (mounted) setState(() {});
}
  @override
  void didUpdateWidget(_ReelVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller?.play();
        _controller?.setVolume(_isMuted ? 0.0 : 1.0);
        setState(() => _isPaused = false);
      } else {
        _controller?.pause();
        setState(() => _isPaused = false);
      }
    }
  }
Widget _buildErrorFallback() {
  return Container(
    color: Colors.black,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.videocam_off_rounded,
            color: Colors.white38,
            size: 48.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            'Video unavailable',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    ),
  );
}
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onTap() {
    final nextMuted = !_isMuted;
    setState(() {
      _isMuted = nextMuted;
      _showMuteIcon = true;
    });
    _controller?.setVolume(nextMuted ? 0.0 : 1.0);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showMuteIcon = false);
    });
  }

  void _onLongPressStart(LongPressStartDetails details) {
    if (!widget.isActive) return;
    _controller?.pause();
    setState(() => _isPaused = true);
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (!widget.isActive) return;
    _controller?.play();
    setState(() => _isPaused = false);
  }

  void _onLongPressCancel() {
    if (_isPaused && widget.isActive) {
      _controller?.play();
      setState(() => _isPaused = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      onLongPressCancel: _onLongPressCancel,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (!_videoReady) const _ReelShimmer(),

          if (_controller != null)
            AnimatedOpacity(
              opacity: _videoReady ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: BetterPlayer(controller: _controller!),
            ),

          if (_isPaused && widget.isActive) ...[
            Container(color: Colors.black.withOpacity(0.35)),
            Center(
              child: Container(
                width: 72.w,
                height: 72.h,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.pause_rounded,
                  color: Colors.white,
                  size: 38.sp,
                ),
              ),
            ),
          ],

          if (_showMuteIcon)
            Center(
              child: TweenAnimationBuilder<double>(
                key: ValueKey(
                  'mute_${_isMuted}_${DateTime.now().millisecondsSinceEpoch}',
                ),
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                builder: (context, value, child) => Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.5 + (0.5 * value),
                    child: child,
                  ),
                ),
                child: Container(
                  width: 72.w,
                  height: 72.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
              ),
            ),

          if (_isMuted)
            Positioned(
              left: 14.w,
              bottom: 140.h,
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.volume_off_rounded,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReelShimmer extends StatelessWidget {
  const _ReelShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1A1A1A),
      highlightColor: const Color(0xFF2E2E2E),
      child: SizedBox.expand(
        child: Stack(
          children: [
            Container(color: Colors.white),
            Positioned(
              left: 16.w,
              right: 80.w,
              bottom: 36.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _shimmerBox(100.w, 14.h, 7.r),
                  SizedBox(height: 8.h),
                  _shimmerBox(double.infinity, 12.h, 6.r),
                  SizedBox(height: 6.h),
                  _shimmerBox(160.w, 12.h, 6.r),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      _shimmerBox(60.w, 10.h, 5.r),
                      SizedBox(width: 14.w),
                      _shimmerBox(50.w, 10.h, 5.r),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  _shimmerBox(double.infinity, 38.h, 30.r),
                ],
              ),
            ),
            Positioned(
              right: 14.w,
              bottom: 140.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _shimmerCircle(46.w, 46.h),
                  SizedBox(height: 28.h),
                  _shimmerCircle(32.w, 32.h),
                  SizedBox(height: 5.h),
                  _shimmerBox(28.w, 8.h, 4.r),
                  SizedBox(height: 22.h),
                  _shimmerCircle(32.w, 32.h),
                  SizedBox(height: 5.h),
                  _shimmerBox(28.w, 8.h, 4.r),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox(double w, double h, double r) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(r),
    ),
  );
  Widget _shimmerCircle(double w, double h) => Container(
    width: w,
    height: h,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
  );
}

class _SideActions extends StatelessWidget {
  final BeeBitesModel reel;
  final bool liked;
  final VoidCallback onLike;
  const _SideActions({
    required this.reel,
    required this.liked,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 14.w,
      bottom: 200.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SideBtn(
            icon: liked ? Icons.favorite : Icons.favorite_border,
            label: reel.likes,
            color: liked ? Colors.red : Colors.white,
            onTap: onLike,
          ),
          SizedBox(height: 20.h),
          _SideBtn(
            icon: Icons.reply_rounded,
            label: 'Share',
            color: Colors.white,
            onTap: shareApp,
            flipHorizontal: true,
          ),
        ],
      ),
    );
  }
}

class _SideBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool flipHorizontal;

  const _SideBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.flipHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: flipHorizontal
                ? (Matrix4.identity()..scale(-1.0, 1.0, 1.0))
                : Matrix4.identity(),
            child: Icon(icon, color: color, size: 32.sp),
          ),
          SizedBox(height: 3.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomInfo extends StatelessWidget {
  final BeeBitesModel reel;
  const _BottomInfo({required this.reel});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16.w,
      right: 16.w,
      bottom: 120.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                reel.authorName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
                ),
              ),
              SizedBox(width: 5.w),
              Icon(
                Icons.verified_rounded,
                color: const Color(0xFF60A5FA),
                size: 14.sp,
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            reel.title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              height: 1.45,
             
              shadows: const [Shadow(color: Colors.black45, blurRadius: 4)],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              _InfoChip(icon: Icons.remove_red_eye_outlined, label: reel.views),
              SizedBox(width: 14.w),
              _InfoChip(icon: Icons.access_time_rounded, label: reel.duration),
            ],
          ),
          SizedBox(height: 14.h),
          GestureDetector(
            onTap: () => showCourseBottomSheet(context, reel),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(6.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, color: Colors.white, size: 16.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'View Courses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white70,
                    size: 11.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white60, size: 13.sp),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(color: Colors.white60, fontSize: 11.sp),
        ),
      ],
    );
  }
}
