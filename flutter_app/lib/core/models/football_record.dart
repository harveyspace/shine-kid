import 'report.dart';

class ActionCounts {
  final int balance;
  final int dribble;
  final int pass;
  final int shoot;
  final int defense;

  ActionCounts({
    required this.balance,
    required this.dribble,
    required this.pass,
    required this.shoot,
    required this.defense,
  });

  factory ActionCounts.fromJson(Map<String, dynamic> json) {
    return ActionCounts(
      balance: json['balance'] ?? 0,
      dribble: json['dribble'] ?? 0,
      pass: json['pass'] ?? 0,
      shoot: json['shoot'] ?? 0,
      defense: json['defense'] ?? 0,
    );
  }
}

class FootballRecord {
  final String id;
  final String userId;
  final String sceneType;
  final ActionCounts actionCounts;
  final int duration;
  final String videoUrl;
  final Report report;
  final String createdAt;

  FootballRecord({
    required this.id,
    required this.userId,
    required this.sceneType,
    required this.actionCounts,
    required this.duration,
    required this.videoUrl,
    required this.report,
    required this.createdAt,
  });

  factory FootballRecord.fromJson(Map<String, dynamic> json) {
    return FootballRecord(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      sceneType: json['scene_type'] ?? '',
      actionCounts: ActionCounts.fromJson(json['action_counts'] ?? {}),
      duration: json['duration'] ?? 0,
      videoUrl: json['video_url'] ?? '',
      report: Report.fromJson(json['report'] ?? {}),
      createdAt: json['created_at'] ?? '',
    );
  }
}