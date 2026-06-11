import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers/user_provider.dart';
import '../../core/providers/record_provider.dart';
import '../../core/services/api_service.dart';

class JumpRopeRecordPage extends ConsumerStatefulWidget {
  const JumpRopeRecordPage({super.key});

  @override
  ConsumerState<JumpRopeRecordPage> createState() => _JumpRopeRecordPageState();
}

class _JumpRopeRecordPageState extends ConsumerState<JumpRopeRecordPage> {
  int _count = 0;
  int _bpm = 0;
  int _timeLeft = 60;
  int _totalDuration = 60;
  bool _isRecording = false;
  bool _isCountingDown = true;
  int _countdown = 3;
  bool _isAnalyzing = false;
  String? _videoPath;

  @override
  void initState() {
    super.initState();
    _loadDuration();
  }

  void _loadDuration() {
    final extra = GoRouterState.of(context).extra as Map?;
    if (extra != null && extra.containsKey('duration')) {
      setState(() {
        _totalDuration = extra['duration'] as int;
        _timeLeft = _totalDuration;
      });
    }
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _countdown--;
          if (_countdown > 0) {
            _startCountdown();
          } else {
            _isCountingDown = false;
            _startRecording();
          }
        });
      }
    });
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    _startTimer();
    _startCounting();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isRecording) {
        setState(() {
          _timeLeft--;
          if (_timeLeft > 0) {
            _startTimer();
          } else {
            _stopRecording();
          }
        });
      }
    });
  }

  void _startCounting() {
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted && _isRecording) {
        setState(() {
          _count++;
          final elapsed = _totalDuration - _timeLeft;
          _bpm = elapsed > 0 ? (_count * 60) ~/ elapsed : 0;
        });
        _startCounting();
      }
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    _showResult();
  }

  void _showResult() {
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
              '训练完成',
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
                  '次数',
                  _count.toString(),
                  AppTheme.primaryColor,
                ),
                _buildResultItem(
                  'BPM',
                  _bpm.toString(),
                  AppTheme.successColor,
                ),
                _buildResultItem(
                  '用时',
                  _totalDuration == 60 ? '1分钟' : '${_totalDuration}秒',
                  AppTheme.secondaryColor,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: () => _analyzeVideo(),
              child: _isAnalyzing 
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        SizedBox(width: 8),
                        Text('分析中...'),
                      ],
                    )
                  : const Text('生成报告'),
            ),
            const SizedBox(height: 16),
            
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.pop();
              },
              child: const Text('返回'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _analyzeVideo() async {
    setState(() => _isAnalyzing = true);
    
    final user = ref.read(userProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('用户未登录')),
      );
      setState(() => _isAnalyzing = false);
      return;
    }

    try {
      // 模拟视频文件路径（实际应用中应该是录制的视频）
      // 这里我们创建一个临时文件来模拟上传
      final tempDir = await Directory.systemTemp.createTemp();
      final videoFile = File('${tempDir.path}/temp.mp4');
      await videoFile.writeAsString('dummy video content');
      
      await ref.read(jumpRopeRecordsProvider.notifier).analyzeVideo(user.id, videoFile.path);
      
      if (mounted) {
        setState(() => _isAnalyzing = false);
        Navigator.pop(context);
        context.go('/report');
      }
    } catch (e) {
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('分析失败: $e')),
      );
    }
  }

  Widget _buildResultItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
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
        title: const Text('跳绳训练'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (!_isRecording && !_isAnalyzing) {
              context.pop();
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isCountingDown)
              Column(
                children: [
                  Text(
                    _countdown.toString(),
                    style: const TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '准备开始',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Icon(
                    Icons.sports_skip_outlined,
                    size: 80,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 32),
                  
                  Text(
                    _count.toString(),
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'BPM: $_bpm',
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppTheme.successColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    '剩余时间: ${_timeLeft}秒',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: 40),
            
            if (_isRecording)
              ElevatedButton(
                onPressed: _stopRecording,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                  minimumSize: const Size(120, 56),
                ),
                child: const Text(
                  '停止',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}