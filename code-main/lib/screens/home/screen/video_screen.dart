import 'dart:async';
import 'dart:math';
import 'package:beecode/screens/home/controller/video_controller.dart';
import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with RouteAware {
  late LessonPlayerController ctrl;
  late BetterPlayerController _player;
  bool _isVideoReady = false;
  bool _isDisposed = false;
  bool _playerDisposed = false;
  bool _showControls = true;
  bool _isDragging = false;
  bool _isBuffering = false;
  bool _isInFullscreen = false;
  bool _showSeekLeft = false;
  bool _showSeekRight = false;
bool _playerReady = false;
  double _brightness = 0.5;
  double _volume = 0.5;
  bool _showBrightnessUI = false;
  bool _showVolumeUI = false;
  Timer? _brightnessTimer;
  Timer? _volumeTimer;

  Timer? _hideTimer;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _speed = 1.0;
  String _selectedQuality = 'Auto';
  final TextEditingController _noteController = TextEditingController();

  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

 @override
void initState() {
  super.initState();
  WakelockPlus.enable();

  // This is the ONLY place that deletes + recreates the controller
  if (Get.isRegistered<LessonPlayerController>()) {
    Get.delete<LessonPlayerController>(force: true);
  }
  ctrl = Get.put(LessonPlayerController());

  _initPlayer();
  _startHideTimer();

  Future.microtask(() async {
    if (_isDisposed) return;
    _brightness = await ScreenBrightness().current;
    _volume = await VolumeController().getVolume();
  });

  ever(ctrl.currentIndex, (_) => _reloadPlayer());
}


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) routeObserver.subscribe(this, route);
  }
@override
void didPushNext() {
  super.didPushNext();
  if (!_playerDisposed && !_isInFullscreen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_playerDisposed || _isDisposed) return;
      try { _player.pause(); } catch (_) {}
    });
  }
}

  @override
void didPopNext() {
  super.didPopNext();
  if (!_playerDisposed && !_isDisposed) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDisposed) return;
      setState(() => _showControls = true);
      _startHideTimer();
    });
  }
}
  @override
void deactivate() {
  if (!_playerDisposed && !_isInFullscreen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_playerDisposed || _isDisposed) return;
      try { _player.pause(); } catch (_) {}
    });
  }
  super.deactivate();
}


@override
void dispose() {
  _isDisposed = true;
  WakelockPlus.disable();
  routeObserver.unsubscribe(this);
  _hideTimer?.cancel();
  _brightnessTimer?.cancel();
  _volumeTimer?.cancel();
  _noteController.dispose();

  // Save position so CourseDetailController can read it after pop
  ctrl.currentPosition.value = _position;

  _disposePlayer();
  // ── Do NOT delete here ──
  super.dispose();
}
void _initPlayer() {
  final config = BetterPlayerConfiguration(
    autoPlay: true,
    fit: BoxFit.contain,
    looping: false,
    allowedScreenSleep: false,
    handleLifecycle: true,
    autoDispose: false,
    controlsConfiguration:
        const BetterPlayerControlsConfiguration(showControls: false),
  );

  _player = BetterPlayerController(config);
  _playerDisposed = false;
  _playerReady = false;
  _player.addEventsListener(_onPlayerEvent);

  final lesson = ctrl.currentLesson;

// Safety check
  if (lesson.videoUrl.isEmpty) {
    debugPrint("❌ Video URL empty hai");
    return;
  }

// ✅ Correct DataSource
  final dataSource = BetterPlayerDataSource(
    BetterPlayerDataSourceType.network,
    lesson.videoUrl,


    headers: {'User-Agent': 'Mozilla/5.0'},
    cacheConfiguration: const BetterPlayerCacheConfiguration(
      useCache: false,
    ),
  );

  _player.setupDataSource(dataSource).then((_) {
    if (!mounted || _isDisposed) return;
    setState(() => _playerReady = true);
  }).catchError((_) {
    if (!mounted || _isDisposed) return;
    setState(() => _playerReady = true);
  });
}
void _reloadPlayer() {
  if (_isDisposed) return;
  setState(() {
    _isVideoReady = false;
    _playerReady = false;
    _position = Duration.zero;
    _duration = Duration.zero;
  });

  final lesson = ctrl.currentLesson;
  final dataSource = BetterPlayerDataSource(
    BetterPlayerDataSourceType.network,
    lesson.videoUrl!,
    videoFormat: BetterPlayerVideoFormat.hls,
    headers: {'User-Agent': 'Mozilla/5.0'},
    cacheConfiguration:
        const BetterPlayerCacheConfiguration(useCache: false),
  );

  _player.setupDataSource(dataSource).then((_) {
    if (!mounted || _isDisposed) return;
    setState(() => _playerReady = true);
  }).catchError((_) {
    if (!mounted || _isDisposed) return;
    setState(() => _playerReady = true);
  });
}

  void _disposePlayer() {
    if (_playerDisposed) return;
    _playerDisposed = true;
    try {
      _player.removeEventsListener(_onPlayerEvent);
    } catch (_) {}
    try {
      _player.pause();
    } catch (_) {}
    try {
      _player.dispose();
    } catch (_) {}
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
  if (_isDisposed) {
    try { _player.pause(); } catch (_) {}
    return;
  }
  if (!mounted) return;

  if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
  if (_isDisposed) {
    try { _player.pause(); _player.dispose(); } catch (_) {}
    return;
  }

  // ── Seek to resume position if set ──
  if (ctrl.resumePosition > Duration.zero) {
    final seekTo = ctrl.resumePosition;
    ctrl.resumePosition = Duration.zero; // clear so it doesn't repeat
    Future.delayed(const Duration(milliseconds: 300), () async {
      if (_isDisposed || !mounted) return;
      try { await _player.seekTo(seekTo); } catch (_) {}
    });
  }

  if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDisposed) return;
      setState(() => _isVideoReady = true);
    });
  } else {
    setState(() => _isVideoReady = true);
  }
  return;
}
  if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
    try {
      _player.seekTo(Duration.zero);
      _player.pause();
    } catch (_) {}
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _isDisposed) return;
        setState(() { _position = Duration.zero; _showControls = true; });
        _hideTimer?.cancel();
      });
    } else {
      setState(() { _position = Duration.zero; _showControls = true; });
      _hideTimer?.cancel();
    }
    return;
  } if (SchedulerBinding.instance.schedulerPhase ==
      SchedulerPhase.persistentCallbacks) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDisposed) return;
      setState(() => _isVideoReady = true);
    });
  } else {
    setState(() => _isVideoReady = true);
  }
 
  // ── Seek to resume position if set ──
  if (ctrl.resumePosition > Duration.zero) {
    final seekTo = ctrl.resumePosition;
    ctrl.resumePosition = Duration.zero; // clear so it doesn't repeat
 
    // Retry seek up to 5 times — HLS needs buffering time before seekTo works
    _seekWithRetry(seekTo, retries: 5);
  }

  final v = _player.videoPlayerController?.value;
  if (v == null) return;

  if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDisposed) return;
      setState(() {
        _position = v.position;
        _duration = v.duration ?? Duration.zero;
        _isBuffering = v.isBuffering;
      });
      ctrl.currentPosition.value = v.position;
    });
  } else {
    setState(() {
      _position = v.position;
      _duration = v.duration ?? Duration.zero;
      _isBuffering = v.isBuffering;
    });
    ctrl.currentPosition.value = v.position;
  }
}
  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_isDragging && !_isDisposed) {
        setState(() => _showControls = false);
      }
    });
  }
void _seekWithRetry(Duration target, {int retries = 5, int attempt = 0}) {
  if (_isDisposed || !mounted) return;
 
  // Wait longer on each retry: 500ms, 800ms, 1200ms, 1800ms, 2500ms
  final delays = [500, 800, 1200, 1800, 2500];
  final delay = attempt < delays.length ? delays[attempt] : 2500;
 
  Future.delayed(Duration(milliseconds: delay), () async {
    if (_isDisposed || !mounted) return;
 
    try {
      final duration = _player.videoPlayerController?.value.duration;
 
      // Duration not ready yet — retry
      if (duration == null || duration == Duration.zero) {
        if (attempt < retries) {
          _seekWithRetry(target, retries: retries, attempt: attempt + 1);
        }
        return;
      }
 
      // Clamp target to valid range
      final clamped = target > duration ? duration : target;
 
      await _player.seekTo(clamped);
 
      // Verify seek worked — if position is still 0, retry
      await Future.delayed(const Duration(milliseconds: 300));
      if (_isDisposed || !mounted) return;
 
      final pos = _player.videoPlayerController?.value.position ?? Duration.zero;
      if (pos.inSeconds < clamped.inSeconds - 2 && attempt < retries) {
        _seekWithRetry(target, retries: retries, attempt: attempt + 1);
      }
    } catch (_) {
      if (attempt < retries) {
        _seekWithRetry(target, retries: retries, attempt: attempt + 1);
      }
    }
  });
}
  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideTimer();
  }

 void _togglePlayPause() {
  if (!_isVideoReady) return;

  final isPlaying = _player.isPlaying() ?? false;
  isPlaying ? _player.pause() : _player.play();
  setState(() {});
  _startHideTimer();
}

  Future<void> _seekBy(int seconds) async {
  if (_isDisposed || !_isVideoReady) return;

  final v = _player.videoPlayerController?.value;
  if (v == null) return;

  final current = v.position;
  final total = v.duration ?? Duration.zero;

  Duration target = current + Duration(seconds: seconds);
  if (target < Duration.zero) target = Duration.zero;
  if (target > total) target = total;

  await _player.seekTo(target);
  _startHideTimer();
}

  void _showSeekEffect(bool right) {
    if (right) {
      setState(() => _showSeekRight = true);
      Future.delayed(const Duration(milliseconds: 450), () {
        if (mounted && !_isDisposed) setState(() => _showSeekRight = false);
      });
    } else {
      setState(() => _showSeekLeft = true);
      Future.delayed(const Duration(milliseconds: 450), () {
        if (mounted && !_isDisposed) setState(() => _showSeekLeft = false);
      });
    }
  }


  Future<void> _openFullscreen() async {
    _isInFullscreen = true;
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    if (!mounted) return;

    final livePos =
        _player.videoPlayerController?.value.position ?? _position;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullscreenPage(
          player: _player,
          title: ctrl.currentLesson.title,
          speed: _speed,
          position: livePos,
          duration: _duration,  selectedQuality: _selectedQuality,            
      onQualitySelected: (q) {                       
        setState(() => _selectedQuality = q);
      },
        ),
      ),
    );

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _isInFullscreen = false;

    if (!mounted || _isDisposed) return;

    // Re-attach after fullscreen
    // Inside _openFullscreen, replace the re-attach block:
await Future.delayed(const Duration(milliseconds: 800));
if (!mounted || _isDisposed) return;

try {
  final reattachUrl = ctrl.currentLesson.videoUrl!;
  await _player.setupDataSource(BetterPlayerDataSource(
    BetterPlayerDataSourceType.network,
    reattachUrl,
    videoFormat: BetterPlayerVideoFormat.hls,
    headers: {'User-Agent': 'Mozilla/5.0'},
    cacheConfiguration:
        const BetterPlayerCacheConfiguration(useCache: false),
  ));
} catch (_) {}

if (!mounted || _isDisposed) return;
await Future.delayed(const Duration(milliseconds: 400));
if (!mounted || _isDisposed) return;

try { await _player.seekTo(livePos); } catch (_) {}

await Future.delayed(const Duration(milliseconds: 200));
if (!mounted || _isDisposed) return;

try { _player.play(); } catch (_) {}

setState(() => _showControls = true);
_startHideTimer();}


  void _openSettingsSheet() {
  _player.pause();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted || _isDisposed) return;
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 64.w,
          child: _SettingsSheet(
            speed: _speed,
            selectedQuality: _selectedQuality,
            onSpeedSelected: (s) {
              setState(() => _speed = s);
              _player.setSpeed(s);
              _player.play();
            },
            onQualitySelected: (q) {
              setState(() => _selectedQuality = q);
              _player.play();
            },
          ),
        ),
      ),
    ).then((_) {
      if (!_isDisposed) _player.play();
    });
  });
}
  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  Widget _seekOverlay(bool right) {
    final show = right ? _showSeekRight : _showSeekLeft;
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: show ? 1 : 0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedScale(
          scale: show ? 1 : 0.9,
          duration: const Duration(milliseconds: 120),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(right ? Icons.fast_forward : Icons.fast_rewind,
                    color: Colors.white, size: 20),
                const SizedBox(width: 4),
                const Text('10 sec',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }

  Widget _sideIndicator(IconData icon, double value) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: RotatedBox(
              quarterTurns: -1,
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.white24,
                valueColor:
                    const AlwaysStoppedAnimation(Color(0xFF1A3BE8)),
                minHeight: 5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('${(value * 100).toInt()}%',
              style:
                  const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    final isPlaying = _player.isPlaying() ?? false;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          
         if (_playerReady)
  BetterPlayer(controller: _player)
else
  Container(color: Colors.black), 

          
          // if (!_isVideoReady)
          //   Positioned.fill(
          //     child: Container(
          //       color: Colors.black,
          //       child: const Center(
          //         child: CircularProgressIndicator(
          //             strokeWidth: 3, color: Color(0xFF1A3BE8)),
          //       ),
          //     ),
          //   ),

       
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _toggleControls,
              child: const SizedBox.expand(),
            ),
          ),

       
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onDoubleTap: () async {
                      _showSeekEffect(false);
                      await _seekBy(-10);
                    },
                    child: const SizedBox.expand(),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onDoubleTap: () async {
                      _showSeekEffect(true);
                      await _seekBy(10);
                    },
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          ),

          // ── Brightness drag (left half) ──
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragUpdate: (details) async {
                  if (!_isVideoReady || _isDisposed) return;
                  final delta = details.primaryDelta! / 300;
                  _brightness =
                      (_brightness - delta).clamp(0.0, 1.0);
                  await ScreenBrightness()
                      .setScreenBrightness(_brightness);
                  if (!_isDisposed)
                    setState(() => _showBrightnessUI = true);
                  _brightnessTimer?.cancel();
                  _brightnessTimer =
                      Timer(const Duration(milliseconds: 800), () {
                    if (mounted && !_isDisposed)
                      setState(() => _showBrightnessUI = false);
                  });
                },
                child: const SizedBox.expand(),
              ),
            ),
          ),

          // ── Volume drag (right half) ──
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragUpdate: (details) async {
                  if (!_isVideoReady || _isDisposed) return;
                  final delta = details.primaryDelta! / 300;
                  _volume = (_volume - delta).clamp(0.0, 1.0);
                  VolumeController().setVolume(_volume);
                  if (!_isDisposed)
                    setState(() => _showVolumeUI = true);
                  _volumeTimer?.cancel();
                  _volumeTimer =
                      Timer(const Duration(milliseconds: 800), () {
                    if (mounted && !_isDisposed)
                      setState(() => _showVolumeUI = false);
                  });
                },
                child: const SizedBox.expand(),
              ),
            ),
          ),

          // ── Seek overlays ──
          Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(child: _seekOverlay(false))),
          Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Center(child: _seekOverlay(true))),

          // ── Buffering ──
          if (_isVideoReady && _isBuffering)
            Positioned.fill(
              child: Container(
                color: Colors.black38,
                child: const Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 3, color: Color(0xFF1A3BE8)),
                ),
              ),
            ),

          // ── Center controls ──
          if (_showControls && _isVideoReady)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _circleBtn(Icons.fast_rewind, () => _seekBy(-10)),
                  const SizedBox(width: 24),
                  _circleBtn(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    _togglePlayPause,
                  ),
                  const SizedBox(width: 24),
                  _circleBtn(Icons.fast_forward, () => _seekBy(10)),
                ],
              ),
            ),
          if (_showControls)
            Positioned(
              top: 20.h,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white),
                      ),
                      Expanded(
                        child: Text(
                          ctrl.currentLesson.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Bottom bar ──
          if (_showControls && _isVideoReady)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6),
                        overlayShape:
                            const RoundSliderOverlayShape(
                                overlayRadius: 12),
                        activeTrackColor:
                            const Color(0xFF1A3BE8),
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.white,
                        overlayColor: Colors.white24,
                      ),
                      child: Slider(
                        value: min(
                          _position.inSeconds.toDouble(),
                          _duration.inSeconds.toDouble() == 0
                              ? 1
                              : _duration.inSeconds.toDouble(),
                        ),
                        max: _duration.inSeconds.toDouble() == 0
                            ? 1
                            : _duration.inSeconds.toDouble(),
                        onChangeStart: (_) =>
                            setState(() => _isDragging = true),
                        onChanged: (v) => setState(() =>
                            _position =
                                Duration(seconds: v.toInt())),
                        onChangeEnd: (v) async {
                          setState(() => _isDragging = false);
                          await _player.seekTo(
                              Duration(seconds: v.toInt()));
                          _startHideTimer();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4, right: 4, bottom: 6),
                      child: Row(
                        children: [
                          Text(
                            '${_fmt(_position)} / ${_fmt(_duration)}',
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: _openSettingsSheet,
                            child: const Icon(Icons.settings,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: _openFullscreen,
                            child: const Icon(Icons.fullscreen,
                                color: Colors.white, size: 22),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Brightness indicator ──
          if (_showBrightnessUI)
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                  child: _sideIndicator(
                      Icons.brightness_6, _brightness)),
            ),

          // ── Volume indicator ──
          if (_showVolumeUI)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                  child:
                      _sideIndicator(Icons.volume_up, _volume)),
            ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════
  // NOTES TAB
  // ══════════════════════════════════════════════

  Widget _buildNotesTab() {
    return Obx(() {
      if (ctrl.isAddingNote.value) return _buildNoteInput();
      if (ctrl.notes.isEmpty) return _buildEmptyNotes();
      return _buildNotesList();
    });
  }

  Widget _buildEmptyNotes() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          SizedBox(
            width: 160.w,
            height: 160.w,
            child: CustomPaint(painter: _NoteIllustrationPainter()),
          ),
          SizedBox(height: 28.h),
          Text(
            'Take quick notes to remember\nwhat you have learned',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Notes can help you to retain whatever you\nlearn in courses for a longer period of time',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black45,
              height: 1.5,
            ),
          ),
          SizedBox(height: 28.h),
          GestureDetector(
            onTap: ctrl.startAddingNote,
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1A3BE8),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Add Note',
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
        ],
      ),
    );
  }

  Widget _buildNoteInput() {
    final timestamp =
        ctrl.formatDuration(ctrl.currentPosition.value);
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _noteController,
              autofocus: true,
              maxLines: 5,
              minLines: 3,
              style:
                  TextStyle(fontSize: 14.sp, color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Start typing your note...',
                hintStyle: TextStyle(
                    color: Colors.black38, fontSize: 14.sp),
                contentPadding: EdgeInsets.all(14.w),
                border: InputBorder.none,
              ),
              onChanged: (v) => ctrl.noteText.value = v,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  size: 16.sp, color: Colors.black54),
              SizedBox(width: 4.w),
              Text(timestamp,
                  style: TextStyle(
                      fontSize: 13.sp, color: Colors.black54)),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  _noteController.clear();
                  ctrl.cancelNote();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A3BE8),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Obx(() => GestureDetector(
                    onTap: ctrl.noteText.value.trim().isEmpty
                        ? null
                        : () {
                            ctrl.saveNote(timestamp);
                            _noteController.clear();
                          },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: ctrl.noteText.value.trim().isEmpty
                            ? Colors.grey.shade300
                            : const Color(0xFF1A3BE8),
                        borderRadius:
                            BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Add Note',
                        style: TextStyle(
                          color: ctrl.noteText.value
                                  .trim()
                                  .isEmpty
                              ? Colors.black38
                              : Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
          child: GestureDetector(
            onTap: ctrl.startAddingNote,
            child: Container(
              width: double.infinity,
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1A3BE8),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add,
                      color: Colors.white, size: 18.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'Add Note',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() => ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: ctrl.notes.length,
                separatorBuilder: (_, _) =>
                    SizedBox(height: 10.h),
                itemBuilder: (context, i) {
                  final note = ctrl.notes[i];
                  return Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(10.r),
                      border: Border.all(
                          color: Colors.grey.shade100),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color:
                      //         Colors.black.withOpacity(0.04),
                      //     blurRadius: 6,
                      //     offset: const Offset(0, 1),
                      //   ),
                      // ],
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFEEF2FF),
                            borderRadius:
                                BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            note.timestamp,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color:
                                  const Color(0xFF1A3BE8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            note.text,
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.black87,
                                height: 1.4),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => ctrl.deleteNote(i),
                          child: Icon(
                              Icons.delete_outline_rounded,
                              size: 18.sp,
                              color: Colors.black26),
                        ),
                      ],
                    ),
                  );
                },
              )),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding:
          EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Obx(() => GestureDetector(
                onTap:
                    ctrl.hasPrev ? ctrl.goToPrev : null,
                child: Container(
                  width: 46.w,
                  height: 46.w,
                  decoration: BoxDecoration(
                    color: ctrl.hasPrev
                        ? const Color(0xFFEEF2FF)
                        : Colors.grey.shade100,
                    borderRadius:
                        BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: ctrl.hasPrev
                        ? const Color(0xFF1A3BE8)
                        : Colors.black26,
                    size: 22.sp,
                  ),
                ),
              )),
          SizedBox(width: 10.w),
          Expanded(
            child: GestureDetector(
              onTap: ctrl.openCourseDetails,
              child: Container(
                height: 46.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius:
                      BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list_rounded,
                        color: const Color(0xFF1A3BE8),
                        size: 20.sp),
                    SizedBox(width: 6.w),
                    Text(
                      'Course Details',
                      style: TextStyle(
                        color: const Color(0xFF1A3BE8),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Obx(() => GestureDetector(
                onTap:
                    ctrl.hasNext ? ctrl.goToNext : null,
                child: Container(
                  width: 46.w,
                  height: 46.w,
                  decoration: BoxDecoration(
                    color: ctrl.hasNext
                        ? const Color(0xFFEEF2FF)
                        : Colors.grey.shade100,
                    borderRadius:
                        BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: ctrl.hasNext
                        ? const Color(0xFF1A3BE8)
                        : Colors.black26,
                    size: 22.sp,
                  ),
                ),
              )),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF0F4FA),
        body: Column(
          children: [
            _buildVideoPlayer(),
            // Tab header
            Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 13),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFF1A3BE8),
                              width: 2.5,
                            ),
                          ),
                        ),
                        child: Text(
                          'Notes',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A3BE8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      height: 1,
                      color: Colors.grey.shade200),
                ],
              ),
            ),
            Expanded(child: _buildNotesTab()),
            if (MediaQuery.of(context).viewInsets.bottom == 0)
              _buildBottomBar(),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// NOTE ILLUSTRATION PAINTER
// ═══════════════════════════════════════════════
class _NoteIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const blue = Color(0xFF1A3BE8);
    final black = Colors.black87;

    final notePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final noteBorderPaint = Paint()
      ..color = black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeJoin = StrokeJoin.round;

    final noteRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.18, size.height * 0.2,
          size.width * 0.55, size.height * 0.6),
      const Radius.circular(16),
    );
    canvas.drawRRect(noteRect, notePaint);
    canvas.drawRRect(noteRect, noteBorderPaint);

    final linePaint = Paint()
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final lineXStart = size.width * 0.27;
    final lineXEnd = size.width * 0.62;

    for (int i = 0; i < 4; i++) {
      final y = size.height * (0.38 + i * 0.1);
      linePaint.color =
          i == 1 || i == 2 || i == 3 ? blue : black;
      canvas.drawLine(
          Offset(lineXStart, y), Offset(lineXEnd, y), linePaint);
    }

    final pencilPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final pencilBorder = Paint()
      ..color = black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeJoin = StrokeJoin.round;

    final pencilPath = Path();
    pencilPath.moveTo(size.width * 0.52, size.height * 0.2);
    pencilPath.lineTo(size.width * 0.78, size.height * 0.46);
    pencilPath.lineTo(size.width * 0.68, size.height * 0.56);
    pencilPath.lineTo(size.width * 0.42, size.height * 0.3);
    pencilPath.close();
    canvas.drawPath(pencilPath, pencilPaint);
    canvas.drawPath(pencilPath, pencilBorder);

    final tipPath = Path();
    tipPath.moveTo(size.width * 0.68, size.height * 0.56);
    tipPath.lineTo(size.width * 0.78, size.height * 0.46);
    tipPath.lineTo(size.width * 0.76, size.height * 0.62);
    tipPath.close();
    canvas.drawPath(tipPath, Paint()..color = blue);

    final dotPaint = Paint()..color = blue;
    canvas.drawCircle(
        Offset(size.width * 0.15, size.height * 0.38), 6, dotPaint);
    canvas.drawCircle(
        Offset(size.width * 0.82, size.height * 0.68),
        3,
        Paint()..color = Colors.black26);

    final plusPaint = Paint()
      ..color = blue
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final px1 = size.width * 0.85;
    final py1 = size.height * 0.2;
    canvas.drawLine(
        Offset(px1 - 7, py1), Offset(px1 + 7, py1), plusPaint);
    canvas.drawLine(
        Offset(px1, py1 - 7), Offset(px1, py1 + 7), plusPaint);

    final px2 = size.width * 0.1;
    final py2 = size.height * 0.72;
    canvas.drawLine(
        Offset(px2 - 9, py2), Offset(px2 + 9, py2), plusPaint);
    canvas.drawLine(
        Offset(px2, py2 - 9), Offset(px2, py2 + 9), plusPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FullscreenPage extends StatefulWidget {
  final BetterPlayerController player;
  final String title;
  final double speed;
  final Duration position;
  final Duration duration;
  final String selectedQuality;              // ← ADD THIS
  final Function(String) onQualitySelected;  // ← ADD THIS

  const _FullscreenPage({
    required this.player,
    required this.title,
    required this.speed,
    required this.position,
    required this.duration,
    required this.selectedQuality,           // ← ADD THIS
    required this.onQualitySelected,         // ← ADD THIS
  });

  @override
  State<_FullscreenPage> createState() => _FullscreenPageState();
}

class _FullscreenPageState extends State<_FullscreenPage> {
  bool _showControls = true;
  bool _isDragging = false;
  bool _isDisposed = false;
  bool _isLocked = false;
  bool _showUnlockButton = false;
  bool _isFillMode = false;
  bool _isBuffering = false;
  bool _showSeekLeft = false;
  bool _showSeekRight = false;
  bool _showBrightnessUI = false;
  bool _showVolumeUI = false;
String _selectedQuality = 'Auto';
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Timer? _hideTimer;
  Timer? _unlockHideTimer;
  Timer? _brightnessTimer;
  Timer? _volumeTimer;

  double _brightness = 0.5;
  double _volume = 0.5;
  double _speed = 1.0;
  double _scale = 1.0;
  double _previousScale = 1.0;

  DeviceOrientation _currentOrientation =
      DeviceOrientation.landscapeLeft;

  static const double _minScale = 1.0;
  static const double _maxScale = 3.0;

 // In _FullscreenPageState
@override
void initState() {
  super.initState();
  _position = widget.position;
  _duration = widget.duration;
  _speed = widget.speed;
  _selectedQuality = widget.selectedQuality;
  WakelockPlus.enable();

  // ── NO Get.delete here — it kills the controller while player is active ──

  Future.microtask(() async {
    if (_isDisposed) return;
    _brightness = await ScreenBrightness().current;
    _volume = await VolumeController().getVolume();
  });

  widget.player.addEventsListener(_onEvent);
  _startHideTimer();
}
  @override
  void dispose() {
    _isDisposed = true;
    WakelockPlus.disable();
    _hideTimer?.cancel();
    _unlockHideTimer?.cancel();
    _brightnessTimer?.cancel();
    _volumeTimer?.cancel();
    try {
      widget.player.removeEventsListener(_onEvent);
    } catch (_) {}
    super.dispose();
  }

  void _onEvent(BetterPlayerEvent event) {
  if (_isDisposed || !mounted) return;

  if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
    try {
      widget.player.seekTo(Duration.zero);
      widget.player.pause();
    } catch (_) {}
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _isDisposed) return;
        setState(() { _position = Duration.zero; _showControls = true; });
        _hideTimer?.cancel();
      });
    } else {
      setState(() { _position = Duration.zero; _showControls = true; });
      _hideTimer?.cancel();
    }
    return;
  }

  final v = widget.player.videoPlayerController?.value;
  if (v == null) return;

  if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDisposed) return;
      setState(() {
        _position = v.position;
        _duration = v.duration ?? Duration.zero;
        _isBuffering = v.isBuffering;
      });
    });
  } else {
    setState(() {
      _position = v.position;
      _duration = v.duration ?? Duration.zero;
      _isBuffering = v.isBuffering;
    });
  }
}
  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_isDragging && !_isLocked && !_isDisposed) {
        setState(() => _showControls = false);
      }
    });
  }

  void _startUnlockHideTimer() {
    _unlockHideTimer?.cancel();
    _unlockHideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isLocked && !_isDisposed) {
        setState(() => _showUnlockButton = false);
      }
    });
  }

  void _toggleControls() {
    if (_isLocked) {
      setState(() => _showUnlockButton = true);
      _startUnlockHideTimer();
      return;
    }
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideTimer();
  }

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
      if (_isLocked) {
        _showControls = false;
        _showUnlockButton = true;
        _startUnlockHideTimer();
      } else {
        _showControls = true;
        _showUnlockButton = false;
        _startHideTimer();
      }
    });
  }

  void _toggleFillMode() {
    setState(() {
      _isFillMode = !_isFillMode;
      _scale = _isFillMode ? 1.5 : 1.0;
    });
    _startHideTimer();
  }

  Future<void> _toggleRotation() async {
    final next =
        _currentOrientation == DeviceOrientation.landscapeLeft
            ? DeviceOrientation.landscapeRight
            : DeviceOrientation.landscapeLeft;
    setState(() => _currentOrientation = next);
    await SystemChrome.setPreferredOrientations([next]);
    _startHideTimer();
  }

  Future<void> _seekBy(int seconds) async {
    if (_isLocked || _isDisposed) return;
    final v = widget.player.videoPlayerController?.value;
    if (v == null) return;
    final current = v.position;
    final total = v.duration ?? Duration.zero;
    Duration target = current + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    if (target > total) target = total;
    await widget.player.seekTo(target);
    _startHideTimer();
  }

  void _showSeekEffect(bool right) {
    if (_isLocked) return;
    if (right) {
      setState(() => _showSeekRight = true);
      Future.delayed(const Duration(milliseconds: 450), () {
        if (mounted && !_isDisposed)
          setState(() => _showSeekRight = false);
      });
    } else {
      setState(() => _showSeekLeft = true);
      Future.delayed(const Duration(milliseconds: 450), () {
        if (mounted && !_isDisposed)
          setState(() => _showSeekLeft = false);
      });
    }
  }

  void _handleBack() {
    if (_isDisposed) return;
    _isDisposed = true;
    _hideTimer?.cancel();
    _unlockHideTimer?.cancel();
    _brightnessTimer?.cancel();
    _volumeTimer?.cancel();
    try {
      widget.player.removeEventsListener(_onEvent);
    } catch (_) {}
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context);
    });
  }

void _openSettingsSheet() {
  if (_isLocked) return;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted || _isDisposed) return;
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 120,
          child: _FullscreenSettingsSheet(
            speed: _speed,
            selectedQuality: _selectedQuality,
            onSpeedSelected: (s) {
              setState(() => _speed = s);
              widget.player.setSpeed(s);
              Navigator.pop(context);
              _startHideTimer();
            },
            onQualitySelected: (q) {
              setState(() => _selectedQuality = q);
              widget.onQualitySelected(q);
              Navigator.pop(context);
              _startHideTimer();
            },
          ),
        ),
      ),
    ).then((_) => _startHideTimer());
  });
}

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '${two(h)}:${two(m)}:${two(s)}';
    return '${two(m)}:${two(s)}';
  }

  Widget _seekOverlay(bool right) {
    final show = right ? _showSeekRight : _showSeekLeft;
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: show ? 1 : 0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedScale(
          scale: show ? 1 : 0.9,
          duration: const Duration(milliseconds: 120),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                    right
                        ? Icons.fast_forward
                        : Icons.fast_rewind,
                    color: Colors.white,
                    size: 22),
                const SizedBox(width: 6),
                const Text('10 sec',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        if (_isLocked || _isDisposed) return;
        onTap();
        _startHideTimer();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.65),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _sideIndicator(IconData icon, double value) {
    return Container(
      width: 65,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: RotatedBox(
              quarterTurns: -1,
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation(
                    Color(0xFF1A3BE8)),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text('${(value * 100).toInt()}%',
              style: const TextStyle(
                  color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = widget.player.isPlaying() ?? false;

    return WillPopScope(
      onWillPop: () async {
        _handleBack();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // ── Video with pinch zoom ──
            Positioned.fill(
              child: GestureDetector(
                onScaleStart: (d) => _previousScale = _scale,
                onScaleUpdate: (d) {
                  if (d.pointerCount >= 2) {
                    setState(() {
                      _scale =
                          (_previousScale * d.scale)
                              .clamp(_minScale, _maxScale);
                    });
                  }
                },
                child: IgnorePointer(
                  ignoring: true,
                  child: RepaintBoundary(
                    child: Transform.scale(
                      scale: _scale,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: widget
                                  .player
                                  .videoPlayerController
                                  ?.value
                                  .aspectRatio ??
                              16 / 9,
                          child: BetterPlayer(
                              controller: widget.player),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Buffering ──
            if (_isBuffering)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: const Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xFF1A3BE8)),
                  ),
                ),
              ),

            // ── Left half: tap toggle + double-tap rewind + brightness drag ──
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _toggleControls,
                  onDoubleTap: _isLocked
                      ? null
                      : () async {
                          _showSeekEffect(false);
                          await _seekBy(-10);
                        },
                  onVerticalDragUpdate: (details) async {
                    if (_isLocked || _isDisposed) return;
                    final delta =
                        details.primaryDelta! / 300;
                    _brightness =
                        (_brightness - delta).clamp(0.0, 1.0);
                    await ScreenBrightness()
                        .setScreenBrightness(_brightness);
                    if (!_isDisposed)
                      setState(() => _showBrightnessUI = true);
                    _brightnessTimer?.cancel();
                    _brightnessTimer = Timer(
                        const Duration(milliseconds: 800), () {
                      if (mounted && !_isDisposed)
                        setState(
                            () => _showBrightnessUI = false);
                    });
                  },
                  child: const SizedBox.expand(),
                ),
              ),
            ),

            // ── Right half: tap toggle + double-tap forward + volume drag ──
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _toggleControls,
                  onDoubleTap: _isLocked
                      ? null
                      : () async {
                          _showSeekEffect(true);
                          await _seekBy(10);
                        },
                  onVerticalDragUpdate: (details) async {
                    if (_isLocked || _isDisposed) return;
                    final delta =
                        details.primaryDelta! / 300;
                    _volume =
                        (_volume - delta).clamp(0.0, 1.0);
                    VolumeController().setVolume(_volume);
                    if (!_isDisposed)
                      setState(() => _showVolumeUI = true);
                    _volumeTimer?.cancel();
                    _volumeTimer = Timer(
                        const Duration(milliseconds: 800), () {
                      if (mounted && !_isDisposed)
                        setState(() => _showVolumeUI = false);
                    });
                  },
                  child: const SizedBox.expand(),
                ),
              ),
            ),

            // ── Seek overlays ──
            Positioned(
                left: 20,
                top: 0,
                bottom: 0,
                child: Center(child: _seekOverlay(false))),
            Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Center(child: _seekOverlay(true))),

            // ── Center controls ──
            if (_showControls && !_isLocked)
              Center(
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    _circleBtn(Icons.fast_rewind,
                        () => _seekBy(-10)),
                    const SizedBox(width: 28),
                    _circleBtn(
                      isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      () {
                        isPlaying
                            ? widget.player.pause()
                            : widget.player.play();
                        setState(() {});
                        _startHideTimer();
                      },
                    ),
                    const SizedBox(width: 28),
                    _circleBtn(Icons.fast_forward,
                        () => _seekBy(10)),
                  ],
                ),
              ),

            // ── Top bar ──
            if (_showControls && !_isLocked)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: _handleBack,
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                          ),
                          Expanded(
                            child: Text(widget.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w700),
                                overflow:
                                    TextOverflow.ellipsis),
                          ),
                          // Fill / Fit toggle
                          IconButton(
                            onPressed: _toggleFillMode,
                            icon: Icon(
                              _isFillMode
                                  ? Icons.fit_screen
                                  : Icons.crop_free,
                              color: Colors.white,
                            ),
                          ),
                          // Lock
                          IconButton(
                            onPressed: _toggleLock,
                            icon: const Icon(Icons.lock_open,
                                color: Colors.white),
                          ),
                          // Settings
                          IconButton(
                            onPressed: _openSettingsSheet,
                            icon: const Icon(Icons.settings,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // ── Bottom bar ──
            if (_showControls && !_isLocked)
              Positioned(
                bottom: 10,
                left: 14,
                right: 14,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context)
                            .copyWith(
                          trackHeight: 2,
                          thumbShape:
                              const RoundSliderThumbShape(
                                  enabledThumbRadius: 6),
                          overlayShape:
                              const RoundSliderOverlayShape(
                                  overlayRadius: 12),
                          activeTrackColor:
                              const Color(0xFF1A3BE8),
                          inactiveTrackColor:
                              Colors.white24,
                          thumbColor: Colors.white,
                          overlayColor: Colors.white24,
                        ),
                        child: Slider(
                          value: min(
                            _position.inSeconds.toDouble(),
                            _duration.inSeconds
                                        .toDouble() ==
                                    0
                                ? 1
                                : _duration.inSeconds
                                    .toDouble(),
                          ),
                          max: _duration.inSeconds
                                      .toDouble() ==
                                  0
                              ? 1
                              : _duration.inSeconds
                                  .toDouble(),
                          onChangeStart: (_) =>
                              setState(
                                  () => _isDragging = true),
                          onChanged: (v) => setState(() =>
                              _position = Duration(
                                  seconds: v.toInt())),
                          onChangeEnd: (v) async {
                            setState(
                                () => _isDragging = false);
                            await widget.player.seekTo(
                                Duration(
                                    seconds: v.toInt()));
                            _startHideTimer();
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_fmt(_position)} / ${_fmt(_duration)}',
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12),
                          ),
                          // Rotate button
                          GestureDetector(
                            onTap: _toggleRotation,
                            child: Icon(
                              _currentOrientation ==
                                      DeviceOrientation
                                          .landscapeLeft
                                  ? Icons
                                      .screen_rotation_alt
                                  : Icons.screen_rotation,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // ── Lock / Unlock button ──
            if (_isLocked && _showUnlockButton)
              Positioned(
                right: 18,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _toggleLock,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_open,
                          color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ),

            // ── Lock indicator (when locked, show lock icon) ──
            if (_isLocked && !_showUnlockButton)
              Positioned(
                right: 18,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(
                          () => _showUnlockButton = true);
                      _startUnlockHideTimer();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock,
                          color: Colors.white54, size: 22),
                    ),
                  ),
                ),
              ),

            // ── Brightness indicator ──
            if (_showBrightnessUI)
              Positioned(
                left: 20,
                top: 0,
                bottom: 0,
                child: Center(
                    child: _sideIndicator(
                        Icons.brightness_6, _brightness)),
              ),

            // ── Volume indicator ──
            if (_showVolumeUI)
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Center(
                    child: _sideIndicator(
                        Icons.volume_up, _volume)),
              ),
          ],
        ),
      ),
    );
  }
}

class _FullscreenSettingsSheet extends StatefulWidget {
  final double speed;
  final String selectedQuality;
  final Function(double) onSpeedSelected;
  final Function(String) onQualitySelected;

  const _FullscreenSettingsSheet({
    required this.speed,
    required this.selectedQuality,
    required this.onSpeedSelected,
    required this.onQualitySelected,
  });

  @override
  State<_FullscreenSettingsSheet> createState() =>
      _FullscreenSettingsSheetState();
}

class _FullscreenSettingsSheetState
    extends State<_FullscreenSettingsSheet> {
  int _page = 0;

  static const _accent  = Color(0xFF1A3BE8);
  static const _accentL = Color(0xFF5C7CFA);

@override
Widget build(BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 160),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: child,
      ),
      child: _page == 0 ? _main() : _page == 1 ? _quality() : _speed(),
    ),
  );
}


  Widget _main() {
    return _card(
      key: const ValueKey('m'),
      title: 'Settings',
      onBack: null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row(Icons.hd_rounded, 'Quality',
              widget.selectedQuality, widget.selectedQuality != 'Auto',
              () => setState(() => _page = 1)),
          _divider(),
          _row(Icons.speed_rounded, 'Speed',
              widget.speed == 1.0 ? 'Normal' : '${widget.speed}×',
              widget.speed != 1.0,
              () => setState(() => _page = 2)),
        ],
      ),
    );
  }

  Widget _quality() {
    final items = [
      ('Auto', 'Recommended'),
      ('1080p', 'Full HD'),
      ('720p', 'HD'),
      ('480p', 'SD'),
      ('360p', 'Low'),
      ('240p', 'Min'),
    ];
    return _card(
      key: const ValueKey('q'),
      title: 'Quality',
      onBack: () => setState(() => _page = 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final q = e.value.$1;
          final sub = e.value.$2;
          final sel = widget.selectedQuality == q;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (i != 0) _divider(),
              _option(q, sub, sel, () => widget.onQualitySelected(q)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _speed() {
    final items = [
      (0.5,  'Slow'),
      (0.75, 'Slightly slow'),
      (1.0,  'Normal'),
      (1.25, 'Slightly fast'),
      (1.5,  'Fast'),
      (2.0,  'Very fast'),
    ];
    return _card(
      key: const ValueKey('s'),
      title: 'Speed',
      onBack: () => setState(() => _page = 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final s = e.value.$1;
          final sub = e.value.$2;
          final sel = widget.speed == s;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (i != 0) _divider(),
              _option(s == 1.0 ? '1× Normal' : '$s×', sub, sel,
                  () => widget.onSpeedSelected(s)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _card({
  required Key key,
  required String title,
  required VoidCallback? onBack,
  required Widget child,
}) {
  return ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.75,
    ),
    child: Container(
      key: key,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 10.w, 14.h),
            child: Row(
              children: [
                if (onBack != null) ...[
                  GestureDetector(
                    onTap: onBack,
                    child: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 8.sp),
                  ),
                  SizedBox(width: 8.w),
                ],
                Text(title,
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded,
                        color: Colors.black38, size: 8.sp),
                  ),
                ),
              ],
            ),
          ),
          _divider(),
          // Body — scrollable
          Flexible(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: child,
            ),
          ),
          SizedBox(height: 6.h),
        ],
      ),
    ),
  );
}
  Widget _row(IconData icon, String label, String value, bool active,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: _accentL, size: 16),
            ),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: active
                    ? _accent.withOpacity(0.2)
                    : Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(value,
                  style: TextStyle(
                      fontSize: 12,
                      color: active ? _accentL : Colors.white38,
                      fontWeight: active
                          ? FontWeight.w600
                          : FontWeight.w400)),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                size: 16, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _option(String label, String sub, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        color: selected ? _accent.withOpacity(0.1) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 130),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? _accent : Colors.transparent,
                border: Border.all(
                  color: selected ? _accent : Colors.white24,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 10)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 13,
                          color: selected ? Colors.white : Colors.white70,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400)),
                  Text(sub,
                      style: TextStyle(
                          fontSize: 11,
                          color: selected
                              ? _accentL.withOpacity(0.7)
                              : Colors.white30)),
                ],
              ),
            ),
            if (selected)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('ON',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _divider() =>
      Container(height: 1, color: Colors.white.withOpacity(0.05));
}
class _SettingsSheet extends StatefulWidget {
  final double speed;
  final String selectedQuality;
  final Function(double) onSpeedSelected;
  final Function(String) onQualitySelected;

  const _SettingsSheet({
    required this.speed,
    required this.selectedQuality,
    required this.onSpeedSelected,
    required this.onQualitySelected,
  });

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  int _page = 0;

  static const _accent   = Color(0xFF1A3BE8);
  static const _accentBg = Color(0xFFEEF2FF);

  @override
  @override
Widget build(BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 160),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: child,
      ),
      child: _page == 0
          ? _main()
          : _page == 1
              ? _quality()
              : _page == 2
                  ? _speed()
                  : _captions(),
    ),
  );
}
  Widget _main() {
    return _card(
      key: const ValueKey('m'),
      title: 'Settings',
      onBack: null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row(Icons.hd_rounded, 'Quality',
              widget.selectedQuality, widget.selectedQuality != 'Auto',
              () => setState(() => _page = 1)),
          _divider(),
          _row(Icons.speed_rounded, 'Speed',
              widget.speed == 1.0 ? 'Normal' : '${widget.speed}×',
              widget.speed != 1.0,
              () => setState(() => _page = 2)),
          _divider(),
          _row(Icons.subtitles_outlined, 'Captions', 'Off', false,
              () => setState(() => _page = 3)),
        ],
      ),
    );
  }

  Widget _quality() {
    final items = [
      ('Auto', 'Recommended'),
      ('1080p', 'Full HD'),
      ('720p', 'HD'),
      ('480p', 'SD'),
      ('360p', 'Low'),
      ('240p', 'Min'),
    ];
    return _card(
      key: const ValueKey('q'),
      title: 'Quality',
      onBack: () => setState(() => _page = 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final q = e.value.$1;
          final sub = e.value.$2;
          final sel = widget.selectedQuality == q;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (i != 0) _divider(),
              _option(q == 'Auto' ? 'Auto' : q, sub, sel, () {
                widget.onQualitySelected(q);
                Navigator.pop(context);
              }),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _speed() {
    final items = [
      (0.5,  'Slow'),
      (0.75, 'Slightly slow'),
      (1.0,  'Normal'),
      (1.25, 'Slightly fast'),
      (1.5,  'Fast'),
      (2.0,  'Very fast'),
    ];
    return _card(
      key: const ValueKey('s'),
      title: 'Speed',
      onBack: () => setState(() => _page = 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final s = e.value.$1;
          final sub = e.value.$2;
          final sel = widget.speed == s;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (i != 0) _divider(),
              _option(s == 1.0 ? '1× Normal' : '$s×', sub, sel, () {
                widget.onSpeedSelected(s);
                Navigator.pop(context);
              }),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _captions() {
    return _card(
      key: const ValueKey('c'),
      title: 'Captions',
      onBack: () => setState(() => _page = 0),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                  color: _accentBg, shape: BoxShape.circle),
              child: Icon(Icons.subtitles_off_outlined,
                  size: 18.sp, color: _accent),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No captions available',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  Text('This video has no captions',
                      style: TextStyle(
                          fontSize: 11.sp, color: Colors.black38)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required Key key,
    required String title,
    required VoidCallback? onBack,
    required Widget child,
  }) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 10.w, 14.h),
            child: Row(
              children: [
                if (onBack != null) ...[
                  GestureDetector(
                    onTap: onBack,
                    child: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.black45, size: 15.sp),
                  ),
                  SizedBox(width: 8.w),
                ],
                Text(title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    )),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded,
                        color: Colors.black38, size: 13.sp),
                  ),
                ),
              ],
            ),
          ),
          _divider(),
          child,
          SizedBox(height: 6.h),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value, bool active,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: _accentBg,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: _accent, size: 16.sp),
            ),
            SizedBox(width: 12.w),
            Text(label,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500)),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: active ? _accentBg : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6.r),
                border: active
                    ? Border.all(color: _accent.withOpacity(0.3))
                    : null,
              ),
              child: Text(value,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: active ? _accent : Colors.black38,
                      fontWeight: active
                          ? FontWeight.w600
                          : FontWeight.w400)),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.chevron_right_rounded,
                size: 16.sp, color: Colors.black26),
          ],
        ),
      ),
    );
  }

  Widget _option(String label, String sub, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child:ClipRect(
  child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        color: selected ? _accentBg : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 130),
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? _accent : Colors.transparent,
                border: Border.all(
                  color: selected ? _accent : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Icon(Icons.check_rounded,
                      color: Colors.white, size: 10.sp)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: selected ? _accent : Colors.black87,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400)),
                  Text(sub,
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: selected
                              ? _accent.withOpacity(0.6)
                              : Colors.black38)),
                ],
              ),
            ),
            if (selected)
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text('ON',
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5)),
              ),
          ],
        ),
      ),
    ));
  }

  Widget _divider() => Container(
      height: 1,
      color: Colors.grey.shade100);
}