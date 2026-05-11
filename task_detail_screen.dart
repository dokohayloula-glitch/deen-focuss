import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import '../models/islamic_task.dart';
import '../providers/task_provider.dart';
import '../providers/stats_provider.dart';
import 'focus_session_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final IslamicTask task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.carbonBlack,
      body: SafeArea(
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            // Get updated task
            final currentTask = taskProvider.tasks.firstWhere(
              (t) => t.id == task.id,
              orElse: () => task,
            );

            return CustomScrollView(
              slivers: [
                // App bar
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppTheme.carbonBlack,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            _getCategoryColor(currentTask.category).withOpacity(0.3),
                            AppTheme.carbonBlack,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: _getCategoryColor(currentTask.category).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(
                                _getCategoryIcon(currentTask.category),
                                color: _getCategoryColor(currentTask.category),
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppTheme.alertRed),
                      onPressed: () => _showDeleteDialog(context, taskProvider),
                    ),
                  ],
                ),

                // Task info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          currentTask.title,
                          style: AppTheme.displayMedium.copyWith(fontSize: 28),
                        ),
                        const SizedBox(height: 8),

                        // Category badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(currentTask.category).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            currentTask.category.labelAr,
                            style: AppTheme.bodySmall.copyWith(
                              color: _getCategoryColor(currentTask.category),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Description
                        if (currentTask.description.isNotEmpty) ...[
                          Text(
                            'الوصف',
                            style: AppTheme.caption,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentTask.description,
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppTheme.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Details grid
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.deepCharcoal,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                Icons.access_time,
                                'الوقت',
                                currentTask.time,
                              ),
                              const Divider(height: 24, color: AppTheme.surfaceGray),
                              _buildDetailRow(
                                Icons.repeat,
                                'التكرار',
                                currentTask.repeat.labelAr,
                              ),
                              const Divider(height: 24, color: AppTheme.surfaceGray),
                              _buildDetailRow(
                                Icons.star,
                                'النقاط',
                                '${currentTask.rewardPoints} نقطة',
                              ),
                              const Divider(height: 24, color: AppTheme.surfaceGray),
                              _buildDetailRow(
                                Icons.local_fire_department,
                                'السلسلة',
                                '${currentTask.streakDays} يوم',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Action buttons
                        if (!currentTask.isCompleted) ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FocusSessionScreen(
                                    taskId: currentTask.id,
                                    taskTitle: currentTask.title,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                gradient: AppTheme.emeraldGradient,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.self_improvement, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    'بدء وضع التركيز',
                                    style: AppTheme.bodyLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Complete button
                        GestureDetector(
                          onTap: () {
                            taskProvider.toggleTaskCompletion(currentTask.id);
                            if (!currentTask.isCompleted) {
                              context.read<StatsProvider>().addTaskCompletion(
                                currentTask.rewardPoints,
                                0,
                              );
                            }
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: currentTask.isCompleted
                                  ? AppTheme.alertRed.withOpacity(0.2)
                                  : AppTheme.deepEmerald.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: currentTask.isCompleted
                                    ? AppTheme.alertRed
                                    : AppTheme.deepEmerald,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  currentTask.isCompleted
                                      ? Icons.close
                                      : Icons.check_circle,
                                  color: currentTask.isCompleted
                                      ? AppTheme.alertRed
                                      : AppTheme.deepEmerald,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  currentTask.isCompleted
                                      ? 'إلغاء الإكمال'
                                      : 'تم الإكمال',
                                  style: AppTheme.bodyLarge.copyWith(
                                    color: currentTask.isCompleted
                                        ? AppTheme.alertRed
                                        : AppTheme.deepEmerald,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.secondaryText, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.secondaryText),
          ),
        ),
        Text(
          value,
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Color _getCategoryColor(TaskCategory category) {
    final colors = {
      TaskCategory.quran: const Color(0xFF2E8B57),
      TaskCategory.dhikr: const Color(0xFFD4AF37),
      TaskCategory.prayer: const Color(0xFF007AFF),
      TaskCategory.qiyam: const Color(0xFF9B59B6),
      TaskCategory.fasting: const Color(0xFFE67E22),
      TaskCategory.sadaqah: const Color(0xFF1ABC9C),
      TaskCategory.dawah: const Color(0xFF3498DB),
      TaskCategory.other: AppTheme.surfaceGrayLight,
    };
    return colors[category] ?? AppTheme.surfaceGrayLight;
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

  void _showDeleteDialog(BuildContext context, TaskProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('حذف المهمة', style: AppTheme.headlineMedium),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف هذه المهمة؟',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: AppTheme.secondaryText)),
          ),
          TextButton(
            onPressed: () {
              provider.deleteTask(task.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('حذف', style: TextStyle(color: AppTheme.alertRed)),
          ),
        ],
      ),
    );
  }
}
