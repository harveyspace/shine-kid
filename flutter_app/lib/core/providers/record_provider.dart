import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/jump_rope_record.dart';
import '../models/football_record.dart';
import '../services/api_service.dart';

final jumpRopeRecordsProvider = StateNotifierProvider<JumpRopeRecordsNotifier, List<JumpRopeRecord>>((ref) {
  return JumpRopeRecordsNotifier();
});

class JumpRopeRecordsNotifier extends StateNotifier<List<JumpRopeRecord>> {
  JumpRopeRecordsNotifier() : super([]);

  Future<void> fetchRecords(String userId) async {
    try {
      final response = await ApiService().getJumpRopeHistory(userId);
      if (response.statusCode == 200) {
        state = List<JumpRopeRecord>.from(
          response.data.map((item) => JumpRopeRecord.fromJson(item)),
        );
      }
    } catch (e) {
      throw Exception('获取记录失败: $e');
    }
  }

  Future<JumpRopeRecord> analyzeVideo(String userId, String videoPath) async {
    try {
      final response = await ApiService().analyzeJumpRope(userId, videoPath);
      if (response.statusCode == 200) {
        final record = JumpRopeRecord.fromJson(response.data);
        state = [record, ...state];
        return record;
      }
      throw Exception('分析失败');
    } catch (e) {
      throw Exception('分析失败: $e');
    }
  }

  void clearRecords() {
    state = [];
  }
}

final footballRecordsProvider = StateNotifierProvider<FootballRecordsNotifier, List<FootballRecord>>((ref) {
  return FootballRecordsNotifier();
});

class FootballRecordsNotifier extends StateNotifier<List<FootballRecord>> {
  FootballRecordsNotifier() : super([]);

  Future<void> fetchRecords(String userId) async {
    try {
      final response = await ApiService().getFootballHistory(userId);
      if (response.statusCode == 200) {
        state = List<FootballRecord>.from(
          response.data.map((item) => FootballRecord.fromJson(item)),
        );
      }
    } catch (e) {
      throw Exception('获取记录失败: $e');
    }
  }

  Future<FootballRecord> analyzeVideo(String userId, String videoPath) async {
    try {
      final response = await ApiService().analyzeFootball(userId, videoPath);
      if (response.statusCode == 200) {
        final record = FootballRecord.fromJson(response.data);
        state = [record, ...state];
        return record;
      }
      throw Exception('分析失败');
    } catch (e) {
      throw Exception('分析失败: $e');
    }
  }

  void clearRecords() {
    state = [];
  }
}