// lib/screens/download/controller/download_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/download_model.dart';

class DownloadController extends GetxController {

  final downloads      = <DownloadModel>[].obs;
  final selectedFilter = 'All'.obs;
  final isLoading      = false.obs;

  final List<String> filters = ['All', 'Completed', 'Downloading', 'Paused', 'Failed'];

  final _timers = <String, Timer>{};

  // ── Computed getters ──────────────────────────────
  List<DownloadModel> get filtered {
    switch (selectedFilter.value) {
      case 'Completed':   return downloads.where((d) => d.status == DownloadStatus.completed).toList();
      case 'Downloading': return downloads.where((d) => d.status == DownloadStatus.downloading).toList();
      case 'Paused':      return downloads.where((d) => d.status == DownloadStatus.paused).toList();
      case 'Failed':      return downloads.where((d) => d.status == DownloadStatus.failed).toList();
      default:            return downloads;
    }
  }

  int get totalCompleted  => downloads.where((d) => d.status == DownloadStatus.completed).length;
  int get activeCount     => downloads.where((d) => d.status == DownloadStatus.downloading).length;
  double get totalStorageMB => downloads
      .where((d) => d.status == DownloadStatus.completed)
      .fold(0.0, (sum, d) => sum + d.totalSizeMB);

  @override
  void onInit() {
    super.onInit();
    // ── No sample data loaded here ──
    // downloads starts empty — only real lesson downloads will appear
    isLoading.value = false;
  }

  @override
  void onClose() {
    for (final t in _timers.values) t.cancel();
    super.onClose();
  }

  // ── Add a new download (called from SectionLessonsController) ──
  void addAndStart(DownloadModel model) {
    final alreadyExists = downloads.any((d) => d.id == model.id);
    if (alreadyExists) return;
    downloads.add(model);
    startDownload(model.id);
  }

  void selectFilter(String f) => selectedFilter.value = f;

  void startDownload(String id) {
    _updateStatus(id, DownloadStatus.downloading);
    _startTimer(id);
  }

  void resumeDownload(String id) => startDownload(id);

  void pauseDownload(String id) {
    _timers[id]?.cancel();
    _timers.remove(id);
    _updateStatus(id, DownloadStatus.paused);
  }

  void retryDownload(String id) {
    final idx = _indexOf(id);
    if (idx == -1) return;
    downloads[idx] = downloads[idx].copyWith(
      downloadedMB: 0,
      status: DownloadStatus.downloading,
    );
    downloads.refresh();
    _startTimer(id);
  }

  void cancelDownload(String id) {
    _timers[id]?.cancel();
    _timers.remove(id);
    downloads.removeWhere((d) => d.id == id);
  }

  void deleteDownload(String id) {
    _timers[id]?.cancel();
    _timers.remove(id);
    downloads.removeWhere((d) => d.id == id);
  }

  void clearCompleted() {
    final completedIds = downloads
        .where((d) => d.status == DownloadStatus.completed)
        .map((d) => d.id)
        .toList();
    for (final id in completedIds) {
      _timers[id]?.cancel();
      _timers.remove(id);
    }
    downloads.removeWhere((d) => d.status == DownloadStatus.completed);
  }

  void openFile(DownloadModel item) {
    Get.snackbar(
      'Opening File',
      item.title,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _startTimer(String id) {
    _timers[id]?.cancel();
    _timers[id] = Timer.periodic(const Duration(milliseconds: 400), (t) {
      final idx = _indexOf(id);
      if (idx == -1) { t.cancel(); return; }
      final item = downloads[idx];
      if (item.status != DownloadStatus.downloading) { t.cancel(); return; }

      final newMB = (item.downloadedMB + item.totalSizeMB * 0.03)
          .clamp(0.0, item.totalSizeMB);
      final isDone = newMB >= item.totalSizeMB;

      downloads[idx] = item.copyWith(
        downloadedMB: newMB,
        status: isDone ? DownloadStatus.completed : DownloadStatus.downloading,
        completedAt: isDone ? DateTime.now() : null,
        localPath: isDone ? '/storage/downloads/${item.id}.file' : null,
      );
      downloads.refresh();
      if (isDone) { t.cancel(); _timers.remove(id); }
    });
  }

  void _updateStatus(String id, DownloadStatus status) {
    final idx = _indexOf(id);
    if (idx == -1) return;
    downloads[idx] = downloads[idx].copyWith(status: status);
    downloads.refresh();
  }

  int _indexOf(String id) => downloads.indexWhere((d) => d.id == id);

  String storageLabel() {
    final mb = totalStorageMB;
    if (mb == 0) return '0 MB';
    return mb >= 1024
        ? '${(mb / 1024).toStringAsFixed(1)} GB'
        : '${mb.toStringAsFixed(0)} MB';
  }

  String timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60)  return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24)  return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}