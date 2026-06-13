import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers/user_provider.dart';
import '../../core/providers/record_provider.dart';
import '../../core/models/jump_rope_record.dart';
import '../../core/models/football_record.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoginModalOpen = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    await ref.read(userProvider.notifier).loadUserFromStorage();
    final user = ref.read(userProvider);
    if (user != null) {
      await ref.read(jumpRopeRecordsProvider.notifier).fetchRecords(user.id);
      await ref.read(footballRecordsProvider.notifier).fetchRecords(user.id);
    }
  }

  void _handleLogin() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入正确的手机号')),
      );
      return;
    }

    try {
      await ref.read(userProvider.notifier).login(phone);
      setState(() {
        _isLoginModalOpen = false;
        _phoneController.clear();
      });
      await ref.read(jumpRopeRecordsProvider.notifier).fetchRecords(ref.read(userProvider)!.id);
      await ref.read(footballRecordsProvider.notifier).fetchRecords(ref.read(userProvider)!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('登录成功')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('登录失败: $e')),
      );
    }
  }

  void _handleMockLogin() async {
    try {
      await ref.read(userProvider.notifier).mockLogin();
      setState(() {
        _isLoginModalOpen = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('快速体验已开启')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('体验失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final jumpRopeRecords = ref.watch(jumpRopeRecordsProvider);
    final footballRecords = ref.watch(footballRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('闪光少年'),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => context.push('/profile'),
                child: const CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            if (user != null)
              _buildWelcomeSection(user.nickname)
            else
              _buildGuestSection(),
            
            const SizedBox(height: 24),
            
            const Text(
              '开始训练',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildSportCard(
                    context,
                    icon: Icons.fitness_center,
                    title: '跳绳',
                    description: '选择时长开始训练',
                    color: AppTheme.primaryColor,
                    route: '/jump-rope',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSportCard(
                    context,
                    icon: Icons.sports_soccer,
                    title: '足球',
                    description: '上传视频分析',
                    color: AppTheme.successColor,
                    route: '/football',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              '最近训练',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildRecentTrainingList(jumpRopeRecords, footballRecords),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildWelcomeSection(String nickname) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '嗨，$nickname',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '今天也要加油训练哦！',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuestSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.login_outlined,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                '开启你的运动之旅',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleMockLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    ),
                  ),
                  child: const Text(
                    '快速体验',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSportCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              ),
              child: Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTrainingList(
    List<JumpRopeRecord> jumpRopeRecords,
    List<FootballRecord> footballRecords,
  ) {
    final allRecords = <dynamic>[];
    
    for (final record in jumpRopeRecords) {
      allRecords.add({'type': 'jump_rope', 'data': record});
    }
    for (final record in footballRecords) {
      allRecords.add({'type': 'football', 'data': record});
    }
    
    allRecords.sort((a, b) {
      return b['data'].createdAt.compareTo(a['data'].createdAt);
    });
    
    if (allRecords.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Icon(
              Icons.history_outlined,
              size: 48,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 16),
            const Text(
              '还没有训练记录',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.push('/jump-rope'),
              child: const Text('开始第一次训练'),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: allRecords.take(5).map((record) {
        if (record['type'] == 'jump_rope') {
          final data = record['data'] as JumpRopeRecord;
          return _buildJumpRopeItem(data);
        } else {
          final data = record['data'] as FootballRecord;
          return _buildFootballItem(data);
        }
      }).toList(),
    );
  }

  Widget _buildJumpRopeItem(JumpRopeRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 24,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '跳绳训练',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.duration}秒 · ${record.count}次 · BPM ${record.bpm}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatDate(record.createdAt),
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFootballItem(FootballRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            child: const Icon(
              Icons.sports_soccer,
              size: 24,
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '足球训练',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_getSceneType(record.sceneType)} · 颠球${record.actionCounts.balance}次 · 带球${record.actionCounts.dribble}次',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatDate(record.createdAt),
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  String _getSceneType(String type) {
    switch (type) {
      case 'training':
        return '训练';
      case 'match':
        return '比赛';
      case 'play':
        return '玩耍';
      default:
        return type;
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);
      
      if (diff.inDays == 0) {
        return '今天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else if (diff.inDays == 1) {
        return '昨天';
      } else if (diff.inDays < 7) {
        return '${diff.inDays}天前';
      } else {
        return '${date.month}/${date.day}';
      }
    } catch (_) {
      return dateStr;
    }
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