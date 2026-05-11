import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import '../providers/prayer_provider.dart';
import '../providers/task_provider.dart';
import '../providers/stats_provider.dart';
import '../providers/settings_provider.dart';
import '../models/islamic_task.dart';
import 'task_detail_screen.dart';
import 'add_task_screen.dart';
import 'focus_session_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.carbonBlack,
      body: SafeArea(
        child: Consumer4<PrayerProvider, TaskProvider, StatsProvider, SettingsProvider>(
          builder: (context, prayerProvider, taskProvider, statsProvider, settingsProvider, child) {
            return CustomScrollView(
              slivers: [
                // Header with greeting
                SliverToBoxAdapter(
                  child: _buildHeader(settingsProvider.userName, prayerProvider),
                ),

                // Prayer countdown card
                SliverToBoxAdapter(
                  child: _buildPrayerCountdown(prayerProvider),
                ),

                // Daily progress
                SliverToBoxAdapter(
                  child: _buildDailyProgress(taskProvider, statsProvider),
                ),

                // Quick actions
                SliverToBoxAdapter(
                  child: _buildQuickActions(context),
                ),

                // Upcoming tasks header
                SliverToBoxAdapter(
                  child: _buildSectionHeader('المهام القادمة', taskProvider.pendingCount),
                ),

                // Tasks list
                if (taskProvider.isLoading)
                  const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (taskProvider.pendingTasks.isEmpty)
                  SliverToBoxAdapter(
                    child: _buildEmptyTasks(),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final task = taskProvider.pendingTasks[index];
                        return _buildTaskCard(task, index);
                      },
                      childCount: taskProvider.pendingTasks.take(5).length,
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(String userName, PrayerProvider prayerProvider) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${prayerProvider.greeting}،',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName,
                    style: AppTheme.headlineLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.goldGlow,
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    color: AppTheme.carbonBlack,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            prayerProvider.gregorianDate,
            style: AppTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            prayerProvider.hijriDate,
            style: AppTheme.caption.copyWith(
              color: AppTheme.islamicGold.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCountdown(PrayerProvider prayerProvider) {
    final nextPrayer = prayerProvider.nextPrayer;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: _animController, curve: const Interval(0, 0.5)),
          ),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
              CurvedAnimation(parent: _animController, curve: const Interval(0, 0.5, curve: Curves.easeOut)),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.islamicGold.withOpacity(0.2),
                    AppTheme.islamicGold.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.islamicGold.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppTheme.islamicGold,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'الصلاة القادمة',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.islamicGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (nextPrayer != null)
                    Text(
                      nextPrayer.nameAr,
                      style: AppTheme.headlineLarge.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    prayerProvider.formattedCountdown,
                    style: AppTheme.displayLarge.copyWith(
                      fontSize: 48,
                      color: AppTheme.islamicGold,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (nextPrayer != null)
                    Text(
                      'وقت الصلاة: ${nextPrayer.formattedTime}',
                      style: AppTheme.caption,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyProgress(TaskProvider taskProvider, StatsProvider statsProvider) {
    final completionRate = taskProvider.completionPercentage / 100;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: _animController, curve: const Interval(0.2, 0.6)),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.deepCharcoal,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تقدم اليوم',
                      style: AppTheme.headlineMedium,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.deepEmerald.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${taskProvider.completedCount}/${taskProvider.totalTasks}',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.deepEmerald,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: completionRate,
                    backgroundColor: AppTheme.surfaceGray,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.deepEmerald,
                    ),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('النقاط', '${statsProvider.totalPoints}', Icons.star),
                    _buildStatItem('السلسلة', '${statsProvider.currentStreak}', Icons.local_fire_department),
                    _buildStatItem('التركيز', '${statsProvider.totalFocusMinutes} د', Icons.timer),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.islamicGold, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTheme.caption,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: _animController, curve: const Interval(0.3, 0.7)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إجراءات سريعة',
                  style: AppTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildQuickActionCard(
                        'وضع التركيز',
                        Icons.self_improvement,
                        AppTheme.emeraldGradient,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FocusSessionScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionCard(
                        'مهمة جديدة',
                        Icons.add_task,
                        LinearGradient(
                          colors: [
                            AppTheme.islamicGold.withOpacity(0.8),
                            AppTheme.islamicGold.withOpacity(0.5),
                          ],
                        ),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddTaskScreen()),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Gradient gradient,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTheme.headlineMedium,
          ),
          if (count > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.islamicGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.islamicGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(IslamicTask task, int index) {
    final categoryColors = {
      TaskCategory.quran: const Color(0xFF2E8B57),
      TaskCategory.dhikr: const Color(0xFFD4AF37),
      TaskCategory.prayer: const Color(0xFF007AFF),
      TaskCategory.qiyam: const Color(0xFF9B59B6),
      TaskCategory.fasting: const Color(0xFFE67E22),
      TaskCategory.sadaqah: const Color(0xFF1ABC9C),
      TaskCategory.dawah: const Color(0xFF3498DB),
      TaskCategory.other: AppTheme.surfaceGrayLight,
    };

    final categoryColor = categoryColors[task.category] ?? AppTheme.surfaceGrayLight;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: _animController,
              curve: Interval(0.4 + (index * 0.05), 0.8, curve: Curves.easeOut),
            ),
          ),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(
              CurvedAnimation(
                parent: _animController,
                curve: Interval(0.4 + (index * 0.05), 0.8, curve: Curves.easeOut),
              ),
            ),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.deepCharcoal,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: categoryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _getCategoryIcon(task.category),
                        color: categoryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.description.isNotEmpty ? task.description : task.category.labelAr,
                            style: AppTheme.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 14, color: AppTheme.tertiaryText),
                              const SizedBox(width: 4),
                              Text(
                                task.time,
                                style: AppTheme.caption,
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.star, size: 14, color: AppTheme.islamicGold.withOpacity(0.6)),
                              const SizedBox(width: 4),
                              Text(
                                '${task.rewardPoints} نقطة',
                                style: AppTheme.caption.copyWith(
                                  color: AppTheme.islamicGold.withOpacity(0.6),
                                ),
                              ),
                              if (task.streakDays > 0) ...[
                                const SizedBox(width: 12),
                                Icon(Icons.local_fire_department, size: 14, color: Colors.orange.withOpacity(0.6)),
                                const SizedBox(width: 4),
                                Text(
                                  '${task.streakDays} يوم',
                                  style: AppTheme.caption.copyWith(
                                    color: Colors.orange.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_back_ios,
                      color: AppTheme.secondaryText,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyTasks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: AppTheme.deepEmerald.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'جميع المهام مكتملة!',
            style: AppTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'بارك الله فيك، أكملت جميع مهامك لهذا اليوم',
            style: AppTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(TaskCategory category) {
    switch (category) {
      case TaskCategory.quran:
        return Icons.menu_book;
      case TaskCategory.dhikr:
        return Icons.favorite;
      case TaskCategory.prayer:
        return Icons.mosque;
      case TaskCategory.qiyam:
        return Icons.nights_stay;
      case TaskCategory.fasting:
        return Icons.no_food;
      case TaskCategory.sadaqah:
        return Icons.volunteer_activism;
      case TaskCategory.dawah:
        return Icons.record_voice_over;
      case TaskCategory.other:
        return Icons.task_alt;
    }
  }
}
