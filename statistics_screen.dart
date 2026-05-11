import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../themes/app_theme.dart';
import '../providers/stats_provider.dart';
import '../providers/task_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.carbonBlack,
      body: SafeArea(
        child: Consumer2<StatsProvider, TaskProvider>(
          builder: (context, statsProvider, taskProvider, child) {
            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),

                // Stats cards
                SliverToBoxAdapter(
                  child: _buildStatsCards(statsProvider),
                ),

                // Weekly chart
                SliverToBoxAdapter(
                  child: _buildWeeklyChart(statsProvider),
                ),

                // Streak info
                SliverToBoxAdapter(
                  child: _buildStreakInfo(statsProvider),
                ),

                // Recent completed tasks
                SliverToBoxAdapter(
                  child: _buildSectionHeader('آخر المهام المكتملة'),
                ),

                if (taskProvider.completedTasks.isEmpty)
                  SliverToBoxAdapter(
                    child: _buildEmptyCompleted(),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final task = taskProvider.completedTasks[index];
                        return _buildCompletedTaskCard(task);
                      },
                      childCount: taskProvider.completedTasks.take(10).length,
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائياتك',
            style: AppTheme.displayMedium.copyWith(
              color: AppTheme.islamicGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تتبع تقدمك في عباداتك ومهامك اليومية',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(StatsProvider statsProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'النقاط الإجمالية',
                  '${statsProvider.totalPoints}',
                  Icons.star,
                  AppTheme.islamicGold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'السلسلة الحالية',
                  '${statsProvider.currentStreak} يوم',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'أطول سلسلة',
                  '${statsProvider.longestStreak} يوم',
                  Icons.emoji_events,
                  AppTheme.deepEmerald,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'دقائق التركيز',
                  '${statsProvider.totalFocusMinutes}',
                  Icons.timer,
                  AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTheme.headlineLarge.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(StatsProvider statsProvider) {
    final weeklyData = statsProvider.last7Days;
    final daysAr = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];

    final maxPoints = weeklyData
        .map((d) => d.pointsEarned)
        .fold<int>(0, (max, p) => p > max ? p : max);

    final barGroups = weeklyData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.pointsEarned.toDouble(),
            color: data.pointsEarned > 0 ? AppTheme.islamicGold : AppTheme.surfaceGray,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxPoints > 0 ? maxPoints.toDouble() : 100,
              color: AppTheme.surfaceGray.withOpacity(0.3),
            ),
          ),
        ],
      );
    }).toList();

    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الأسبوع الحالي',
            style: AppTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'النقاط المكتسبة يومياً',
            style: AppTheme.caption,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (maxPoints > 0 ? maxPoints : 100).toDouble() * 1.2,
                barGroups: barGroups,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxPoints > 0 ? maxPoints / 4 : 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.surfaceGray.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final dayIndex = value.toInt();
                        if (dayIndex >= 0 && dayIndex < 7) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              daysAr[dayIndex],
                              style: AppTheme.caption.copyWith(fontSize: 11),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: AppTheme.surfaceGray,
                    tooltipRoundedRadius: 12,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} نقطة',
                        AppTheme.bodySmall.copyWith(
                          color: AppTheme.islamicGold,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakInfo(StatsProvider statsProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.islamicGold.withOpacity(0.15),
            AppTheme.deepEmerald.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.islamicGold.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'سلسلة الإنجاز',
                style: AppTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStreakItem('الحالية', '${statsProvider.currentStreak}', Colors.orange),
              Container(
                width: 1,
                height: 40,
                color: AppTheme.surfaceGray,
              ),
              _buildStreakItem('الأطول', '${statsProvider.longestStreak}', AppTheme.deepEmerald),
              Container(
                width: 1,
                height: 40,
                color: AppTheme.surfaceGray,
              ),
              _buildStreakItem('المهام', '${statsProvider.totalTasksCompleted}', AppTheme.primaryBlue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.headlineLarge.copyWith(
            color: color,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.caption,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        title,
        style: AppTheme.headlineMedium,
      ),
    );
  }

  Widget _buildCompletedTaskCard(dynamic task) {
    final categoryColors = {
      'quran': const Color(0xFF2E8B57),
      'dhikr': const Color(0xFFD4AF37),
      'prayer': const Color(0xFF007AFF),
      'qiyam': const Color(0xFF9B59B6),
      'fasting': const Color(0xFFE67E22),
      'sadaqah': const Color(0xFF1ABC9C),
      'dawah': const Color(0xFF3498DB),
      'other': AppTheme.surfaceGrayLight,
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.deepEmerald.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppTheme.deepEmerald,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.lineThrough,
                    color: AppTheme.secondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+${task.rewardPoints} نقطة',
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.islamicGold.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          if (task.streakDays > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    '${task.streakDays}',
                    style: AppTheme.caption.copyWith(color: Colors.orange),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyCompleted() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: AppTheme.tertiaryText,
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد مهام مكتملة بعد',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.secondaryText),
          ),
        ],
      ),
    );
  }
}
