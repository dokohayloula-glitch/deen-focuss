import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../models/islamic_task.dart';

class TaskCard extends StatelessWidget {
  final IslamicTask task;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onComplete,
  });

  Color _getCategoryColor() {
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
    return colors[task.category] ?? AppTheme.surfaceGrayLight;
  }

  IconData _getCategoryIcon() {
    switch (task.category) {
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

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();

    return GestureDetector(
      onTap: onTap,
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
                _getCategoryIcon(),
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
                  if (task.description.isNotEmpty)
                    Text(
                      task.description,
                      style: AppTheme.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: AppTheme.tertiaryText),
                      const SizedBox(width: 4),
                      Text(task.time, style: AppTheme.caption),
                      const SizedBox(width: 12),
                      Icon(Icons.star, size: 14, color: AppTheme.islamicGold.withOpacity(0.6)),
                      const SizedBox(width: 4),
                      Text(
                        '${task.rewardPoints} نقطة',
                        style: AppTheme.caption.copyWith(
                          color: AppTheme.islamicGold.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onComplete != null && !task.isCompleted)
              GestureDetector(
                onTap: onComplete,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.deepEmerald.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppTheme.deepEmerald,
                    size: 20,
                  ),
                ),
              )
            else if (task.isCompleted)
              const Icon(
                Icons.check_circle,
                color: AppTheme.deepEmerald,
              ),
          ],
        ),
      ),
    );
  }
}
