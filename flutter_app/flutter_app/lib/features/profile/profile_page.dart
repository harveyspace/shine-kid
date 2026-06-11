import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers/user_provider.dart';
import '../../core/providers/record_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final jumpRopeRecords = ref.watch(jumpRopeRecordsProvider);
    final footballRecords = ref.watch(footballRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // 用户信息卡片
            _buildUserCard(user),
            
            const SizedBox(height: 32),
            
            // 统计数据
            _buildStatsCard(jumpRopeRecords.length, footballRecords.length),
            
            const SizedBox(height: 32),
            
            // 功能菜单
            _buildMenuList(),
            
            const SizedBox(height: 32),
            
            // 登出按钮
            if (user != null)
              ElevatedButton(
                onPressed: () => _handleLogout(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.surface,
                  foregroundColor: AppTheme.errorColor,
                  side: const BorderSide(color: AppTheme.border),
                ),
                child: const Text('退出登录'),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildUserCard(user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            child: Icon(
              Icons.person_outline,
              size: 48,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.nickname ?? '未登录',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.phone ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    opacity: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(int jumpRopeCount, int footballCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
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
          Expanded(
            child: Column(
              children: [
                Text(
                  '$jumpRopeCount',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '跳绳次数',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            color: AppTheme.border,
            width: 1,
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '$footballCount',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.successColor,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '足球次数',
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
    );
  }

  Widget _buildMenuList() {
    final menuItems = [
      {
        'icon': Icons.settings_outlined,
        'title': '设置',
        'subtitle': '账号与隐私',
      },
      {
        'icon': Icons.help_outline,
        'title': '帮助与反馈',
        'subtitle': '常见问题解答',
      },
      {
        'icon': Icons.info_outline,
        'title': '关于我们',
        'subtitle': '版本 1.0.0',
      },
    ];

    return Column(
      children: menuItems
          .map((item) => _buildMenuItem(
                item['icon']!,
                item['title']!,
                item['subtitle']!,
              ))
          .toList(),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title 功能开发中')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.divider)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.medium,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() async {
    await ref.read(userProvider.notifier).logout();
    ref.read(jumpRopeRecordsProvider.notifier).clearRecords();
    ref.read(footballRecordsProvider.notifier).clearRecords();
    context.go('/');
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 2,
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