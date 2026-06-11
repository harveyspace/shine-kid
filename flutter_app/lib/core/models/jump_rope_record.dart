import 'report.dart';

class JumpRopeRecord {
  final String id;
  final String userId;
  final int count;
  final int bpm;
  final int maxBpm;
  final int duration;
  final double breakRate;
  final String videoUrl;
  final Report report;
  final String createdAt;

  JumpRopeRecord({
    required this.id,
    required this.userId,
    required this.count,
    required this.bpm,
    required this.maxBpm,
    required this.duration,
    required this.breakRate,
    required this.videoUrl,
    required this.report,
    required this.createdAt,
  });

  factory JumpRopeRecord.fromJson(Map<String, dynamic> json) {
    return JumpRopeRecord(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      count: json['count'] ?? 0,
      bpm: json['bpm'] ?? 0,
      maxBpm: json['max_bpm'] ?? 0,
      duration: json['duration'] ?? 0,
      breakRate: json['break_rate'] ?? 0.0,
      videoUrl: json['video_url'] ?? '',
      report: Report.fromJson(json['report'] ?? {}),
      createdAt: json['created_at'] ?? '',
    );
  }
}