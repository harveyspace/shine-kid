import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers/user_provider.dart';
import '../../core/providers/record_provider.dart';
import '../../core/models/report.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  Report? _currentReport;
  String _sportType = 'jump_rope'; // jump_rope or football
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() => _isLoading = true);
    final user = ref.read(userProvider);
    if (user != null) {
      try {
        // 获取最新的跳绳记录作为报告数据
        final jumpRopeRecords = ref.read(jumpRopeRecordsProvider);
        if (jumpRopeRecords.isNotEmpty) {
          final latestRecord = jumpRopeRecords.first;
          setState(() {
            _currentReport = latestRecord.report;
          });
        }
      } catch (e) {
        debugPrint('Failed to load report: $e');
      }
    }
    setState(() => _isLoading = false);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bar_chart_outlined,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          const Text(
            '暂无训练报告',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '完成训练后即可查看能力报告',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/jump-rope'),
            child: const Text('开始训练'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('能力报告'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _currentReport == null 
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  _buildOverallScore(),
                  
                  const SizedBox(height: 32),
                  
                  _buildSportSelector(),
                  
                  const SizedBox(height: 16),
                  
                  const Text(
                    '能力雷达图',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildRadarChart(),
                  
                  const SizedBox(height: 32),
                  
                  const Text(
                    '能力详情',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildAbilityList(),
                  
                  const SizedBox(height: 32),
                  
                  const Text(
                    '训练建议',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSuggestions(),
                  
                  const SizedBox(height: 32),
                  
                  ElevatedButton(
                    onPressed: () {
                      // 分享报告
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('分享功能开发中')),
                      );
                    },
                    child: const Text('分享报告'),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildSportSelector() {
    return Row(
      children: [
        _buildSportTab('jump_rope', '跳绳'),
        const SizedBox(width: 12),
        _buildSportTab('football', '足球'),
      ],
    );
  }

  Widget _buildSportTab(String type, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _sportType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _sportType == type 
                ? AppTheme.primaryColor.withOpacity(0.1)
                : AppTheme.surface,
            border: Border.all(
              color: _sportType == type 
                  ? AppTheme.primaryColor 
                  : AppTheme.border,
            ),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _sportType == type 
                    ? AppTheme.primaryColor 
                    : AppTheme.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverallScore() {
    final score = _currentReport?.overallScore ?? 82;
    String level;
    if (score >= 90) level = '卓越';
    else if (score >= 80) level = '优秀';
    else if (score >= 70) level = '良好';
    else if (score >= 60) level = '合格';
    else level = '需努力';

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
      child: Column(
        children: [
          const Text(
            '综合评分',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              opacity: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            level,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarChart() {
    final abilities = _sportType == 'jump_rope'
        ? [
            {'name': '爆发力', 'score': _currentReport?.explosivePower ?? 85},
            {'name': '速度', 'score': _currentReport?.speed ?? 80},
            {'name': '耐力', 'score': _currentReport?.endurance ?? 75},
            {'name': '协调性', 'score': _currentReport?.coordination ?? 82},
            {'name': '柔韧性', 'score': _currentReport?.flexibility ?? 70},
            {'name': '稳定性', 'score': _currentReport?.stability ?? 85},
          ]
        : [
            {'name': '爆发力', 'score': _currentReport?.explosivePower ?? 78},
            {'name': '速度', 'score': _currentReport?.speed ?? 82},
            {'name': '精准', 'score': _currentReport?.precision ?? 75},
            {'name': '耐力', 'score': _currentReport?.endurance ?? 80},
            {'name': '柔韧', 'score': _currentReport?.flexibility ?? 72},
            {'name': '球商', 'score': _currentReport?.gameIq ?? 85},
          ];

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
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
      child: RadarChart(
        RadarChartData(
          radarBackgroundColor: AppTheme.background,
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: AppTheme.border),
          titleTextStyle: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
          dataSets: [
            RadarDataSet(
              values: abilities
                  .map((a) => RadarChartValue(value: a['score'] as num))
                  .toList(),
              borderColor: AppTheme.primaryColor,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
              borderWidth: 2,
              entryRadius: 4,
            ),
          ],
          titleAlignment: RadarEntryAlignment.center,
          titles: abilities
              .map((a) => RadarChartTitle(text: a['name'] as String))
              .toList(),
          gridBorderData: const BorderSide(color: AppTheme.border),
          angleStep: 60,
        ),
      ),
    );
  }

  Widget _buildAbilityList() {
    final abilities = _sportType == 'jump_rope'
        ? [
            {'name': '爆发力', 'score': _currentReport?.explosivePower ?? 85, 'color': AppTheme.primaryColor},
            {'name': '速度', 'score': _currentReport?.speed ?? 80, 'color': AppTheme.successColor},
            {'name': '耐力', 'score': _currentReport?.endurance ?? 75, 'color': AppTheme.secondaryColor},
            {'name': '协调性', 'score': _currentReport?.coordination ?? 82, 'color': AppTheme.infoColor},
            {'name': '柔韧性', 'score': _currentReport?.flexibility ?? 70, 'color': AppTheme.warningColor},
            {'name': '稳定性', 'score': _currentReport?.stability ?? 85, 'color': AppTheme.successColor},
          ]
        : [
            {'name': '爆发力', 'score': _currentReport?.explosivePower ?? 78, 'color': AppTheme.primaryColor},
            {'name': '速度', 'score': _currentReport?.speed ?? 82, 'color': AppTheme.successColor},
            {'name': '精准', 'score': _currentReport?.precision ?? 75, 'color': AppTheme.secondaryColor},
            {'name': '耐力', 'score': _currentReport?.endurance ?? 80, 'color': AppTheme.infoColor},
            {'name': '柔韧', 'score': _currentReport?.flexibility ?? 72, 'color': AppTheme.warningColor},
            {'name': '球商', 'score': _currentReport?.gameIq ?? 85, 'color': AppTheme.successColor},
          ];

    return Column(
      children: abilities
          .map((ability) => _buildAbilityItem(
                ability['name']!,
                ability['score']!,
                ability['color']!,
              ))
          .toList(),
    );
  }

  Widget _buildAbilityItem(String name, num score, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.divider)),
      ),
      child: Row(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.medium,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: LinearProgressIndicator(
              value: (score as int) / 100,
              backgroundColor: AppTheme.border,
              color: color,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    final highlights = _currentReport?.highlights ?? [
      '爆发力表现出色，继续保持',
      '协调性很好，动作流畅',
    ];
    final suggestions = _currentReport?.suggestions ?? [
      '耐力有待提升，建议增加训练时长',
      '柔韧性需要加强，可以增加拉伸训练',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '亮点',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(height: 8),
          ...highlights.map((h) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '• $h',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
          )),
          const SizedBox(height: 16),
          const Text(
            '建议',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.warningColor,
            ),
          ),
          const SizedBox(height: 8),
          ...suggestions.map((s) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '• $s',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
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