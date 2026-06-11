import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers/user_provider.dart';
import '../../core/providers/record_provider.dart';

class FootballPage extends ConsumerStatefulWidget {
  const FootballPage({super.key});

  @override
  ConsumerState<FootballPage> createState() => _FootballPageState();
}

class _FootballPageState extends ConsumerState<FootballPage> {
  bool _isUploading = false;
  String? _selectedVideoPath;

  void _uploadVideo() {
    final user = ref.read(userProvider);
    if (user == null) {
      _showLoginPrompt();
      return;
    }

    setState(() {
      _isUploading = true;
    });

    _analyzeVideo(user.id);
  }

  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('请先登录'),
        content: const Text('登录后才能保存训练记录'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/');
            },
            child: const Text('去登录'),
          ),
        ],
      ),
    );
  }

  Future<void> _analyzeVideo(String userId) async {
    try {
      // 模拟视频文件路径
      final tempDir = await Directory.systemTemp.createTemp();
      final videoFile = File('${tempDir.path}/temp.mp4');
      await videoFile.writeAsString('dummy football video content');
      
      await ref.read(footballRecordsProvider.notifier).analyzeVideo(userId, videoFile.path);
      
      if (mounted) {
        setState(() => _isUploading = false);
        _showAnalysisResult();
      }
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('分析失败: $e')),
      );
    }
  }

  void _showAnalysisResult() {
    final footballRecords = ref.read(footballRecordsProvider);
    final latestRecord = footballRecords.isNotEmpty ? footballRecords.first : null;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '分析完成',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildResultItem(
                  '颠球',
                  '${latestRecord?.balanceCount ?? 12}次',
                  AppTheme.successColor,
                ),
                _buildResultItem(
                  '带球',
                  '${latestRecord?.dribbleCount ?? 30}次',
                  AppTheme.primaryColor,
                ),
                _buildResultItem(
                  '射门',
                  '${latestRecord?.shootCount ?? 5}次',
                  AppTheme.secondaryColor,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/report');
              },
              child: const Text('查看报告'),
            ),
            const SizedBox(height: 16),
            
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('返回'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('足球训练'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
              ),
              child: const Icon(
                Icons.sports_soccer,
                size: 80,
                color: AppTheme.successColor,
              ),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              '上传训练视频',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '支持5秒-60分钟视频',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            
            const SizedBox(height: 32),
            
            GestureDetector(
              onTap: _isUploading ? null : _uploadVideo,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.border,
                    width: 2,
                    style: BorderStyle.dashed,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                ),
                child: _isUploading
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppTheme.successColor,
                          ),
                          SizedBox(height: 16),
                          Text(
                            '分析中...',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_library_outlined,
                            size: 48,
                            color: AppTheme.textTertiary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            '点击选择视频',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _isUploading ? null : _uploadVideo,
                  icon: const Icon(Icons.camera_alt_outlined),
                  color: AppTheme.successColor,
                  iconSize: 40,
                ),
                const SizedBox(width: 32),
                IconButton(
                  onPressed: _isUploading ? null : _uploadVideo,
                  icon: const Icon(Icons.file_upload_outlined),
                  color: AppTheme.successColor,
                  iconSize: 40,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '拍摄',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(width: 48),
                Text(
                  '从相册选择',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '分析说明',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• AI会自动识别视频中的动作',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• 支持识别：颠球、带球、传球、射门、防守',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• AI自动识别场景：训练/比赛/玩耍',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• 分析结果仅供参考',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up_outlined),
          label: '报告',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          label: '我的',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/report');
            break;
          case 2:
            context.go('/profile');
            break;
        }
      },
    );
  }
}