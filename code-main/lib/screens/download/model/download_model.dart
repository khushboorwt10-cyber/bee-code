// lib/screens/downloads/model/download_model.dart

enum DownloadStatus { notStarted, downloading, paused, completed, failed }

enum DownloadFileType { video, pdf, zip, audio }

class DownloadModel {
  final String id;
  final String title;
  final String subtitle;     
  final String courseName;
  final DownloadFileType type;
  final double totalSizeMB;
  final double downloadedMB;
  final DownloadStatus status;
  final String? localPath;
  final DateTime? completedAt;

  const DownloadModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.courseName,
    required this.type,
    required this.totalSizeMB,
    this.downloadedMB = 0,
    this.status = DownloadStatus.notStarted,
    this.localPath,
    this.completedAt,
  });


  double get progress =>
      totalSizeMB > 0 ? (downloadedMB / totalSizeMB).clamp(0.0, 1.0) : 0.0;

  String get progressLabel =>
      '${downloadedMB.toStringAsFixed(1)} / ${totalSizeMB.toStringAsFixed(1)} MB';

  String get sizeLabel => '${totalSizeMB.toStringAsFixed(1)} MB';

  DownloadModel copyWith({
    double? downloadedMB,
    DownloadStatus? status,
    String? localPath,
    DateTime? completedAt,
  }) =>
      DownloadModel(
        id: id,
        title: title,
        subtitle: subtitle,
        courseName: courseName,
        type: type,
        totalSizeMB: totalSizeMB,
        downloadedMB: downloadedMB ?? this.downloadedMB,
        status: status ?? this.status,
        localPath: localPath ?? this.localPath,
        completedAt: completedAt ?? this.completedAt,
      );
}

final List<DownloadModel> sampleDownloads = [
  DownloadModel(
    id: '1',
    title: 'Introduction to Neural Networks',
    subtitle: 'Module 1 · Lecture 1 · 38 min',
    courseName: 'Executive Diploma in ML & AI',
    type: DownloadFileType.video,
    totalSizeMB: 245.0,
    downloadedMB: 245.0,
    status: DownloadStatus.completed,
    localPath: '/storage/downloads/intro_nn.mp4',
    completedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  DownloadModel(
    id: '2',
    title: 'Deep Learning — Week 2 Slides',
    subtitle: 'Module 2 · PDF · 32 pages',
    courseName: 'Executive Diploma in ML & AI',
    type: DownloadFileType.pdf,
    totalSizeMB: 12.5,
    downloadedMB: 12.5,
    status: DownloadStatus.completed,
    localPath: '/storage/downloads/week2_slides.pdf',
    completedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  DownloadModel(
    id: '3',
    title: 'Python for Data Science — Full Pack',
    subtitle: 'Module 4 · ZIP · Lab files',
    courseName: 'BCA – Semester 3',
    type: DownloadFileType.zip,
    totalSizeMB: 88.0,
    downloadedMB: 44.0,
    status: DownloadStatus.downloading,
  ),
  DownloadModel(
    id: '4',
    title: 'Capstone Project Guidelines',
    subtitle: 'Final Term · PDF · 18 pages',
    courseName: 'MBA – Operations',
    type: DownloadFileType.pdf,
    totalSizeMB: 6.2,
    downloadedMB: 6.2,
    status: DownloadStatus.completed,
    localPath: '/storage/downloads/capstone_guide.pdf',
    completedAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  DownloadModel(
    id: '5',
    title: 'AI Ethics – Recorded Lecture',
    subtitle: 'Module 6 · Lecture 3 · 55 min',
    courseName: 'Executive Diploma in ML & AI',
    type: DownloadFileType.video,
    totalSizeMB: 310.0,
    downloadedMB: 120.0,
    status: DownloadStatus.paused,
  ),
  DownloadModel(
    id: '6',
    title: 'Statistics Refresher Audio',
    subtitle: 'Supplementary · Audio · 22 min',
    courseName: 'B.Sc Physics – Year 1',
    type: DownloadFileType.audio,
    totalSizeMB: 18.4,
    downloadedMB: 0,
    status: DownloadStatus.failed,
  ),
  DownloadModel(
    id: '7',
    title: 'Computer Vision Workshop',
    subtitle: 'Module 5 · Lecture 2 · 48 min',
    courseName: 'Executive Diploma in ML & AI',
    type: DownloadFileType.video,
    totalSizeMB: 290.0,
    downloadedMB: 0,
    status: DownloadStatus.notStarted,
  ),
];