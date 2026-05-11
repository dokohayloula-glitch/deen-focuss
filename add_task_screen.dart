import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../themes/app_theme.dart';
import '../models/islamic_task.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _uuid = const Uuid();

  TimeOfDay _selectedTime = const TimeOfDay(hour: 7, minute: 0);
  TaskCategory _selectedCategory = TaskCategory.quran;
  RepeatOption _selectedRepeat = RepeatOption.daily;
  int _rewardPoints = 10;

  final List<TaskCategory> _categories = TaskCategory.values.toList();
  final List<RepeatOption> _repeatOptions = RepeatOption.values.toList();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الرجاء إدخال عنوان المهمة', style: AppTheme.bodyMedium),
          backgroundColor: AppTheme.alertRed,
        ),
      );
      return;
    }

    final task = IslamicTask(
      id: 'task_${_uuid.v4()}',
      title: _titleController.text,
      description: _descriptionController.text,
      time: '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      category: _selectedCategory,
      repeat: _selectedRepeat,
      rewardPoints: _rewardPoints,
      createdAt: DateTime.now(),
    );

    context.read<TaskProvider>().addTask(task);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إضافة المهمة بنجاح', style: AppTheme.bodyMedium),
        backgroundColor: AppTheme.deepEmerald,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.carbonBlack,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              floating: true,
              backgroundColor: AppTheme.carbonBlack,
              title: Text('مهمة جديدة', style: AppTheme.headlineLarge),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text('العنوان', style: AppTheme.caption),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      style: AppTheme.bodyLarge,
                      textAlign: TextAlign.right,
                      decoration: AppTheme.inputDecoration.copyWith(
                        hintText: 'مثال: قراءة سورة البقرة',
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description
                    Text('الوصف (اختياري)', style: AppTheme.caption),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      style: AppTheme.bodyLarge,
                      textAlign: TextAlign.right,
                      maxLines: 3,
                      decoration: AppTheme.inputDecoration.copyWith(
                        hintText: 'وصف المهمة...',
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Time picker
                    Text('الوقت', style: AppTheme.caption),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                timePickerTheme: TimePickerThemeData(
                                  backgroundColor: AppTheme.deepCharcoal,
                                  hourMinuteTextColor: AppTheme.primaryText,
                                  dialHandColor: AppTheme.islamicGold,
                                  dialBackgroundColor: AppTheme.surfaceGray,
                                  dialTextColor: AppTheme.primaryText,
                                  entryModeIconColor: AppTheme.islamicGold,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (time != null) {
                          setState(() {
                            _selectedTime = time;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceGray,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time, color: AppTheme.islamicGold),
                            const SizedBox(width: 12),
                            Text(
                              '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                              style: AppTheme.headlineLarge.copyWith(fontSize: 28),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Category
                    Text('الفئة', style: AppTheme.caption),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = category),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _getCategoryColor(category).withOpacity(0.3)
                                  : AppTheme.surfaceGray,
                              borderRadius: BorderRadius.circular(14),
                              border: isSelected
                                  ? Border.all(
                                      color: _getCategoryColor(category),
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getCategoryIcon(category),
                                  size: 18,
                                  color: isSelected
                                      ? _getCategoryColor(category)
                                      : AppTheme.secondaryText,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  category.labelAr,
                                  style: AppTheme.bodySmall.copyWith(
                                    color: isSelected
                                        ? _getCategoryColor(category)
                                        : AppTheme.secondaryText,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Repeat
                    Text('التكرار', style: AppTheme.caption),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _repeatOptions.map((repeat) {
                        final isSelected = _selectedRepeat == repeat;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedRepeat = repeat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.islamicGold.withOpacity(0.2)
                                  : AppTheme.surfaceGray,
                              borderRadius: BorderRadius.circular(14),
                              border: isSelected
                                  ? Border.all(color: AppTheme.islamicGold, width: 2)
                                  : null,
                            ),
                            child: Text(
                              repeat.labelAr,
                              style: AppTheme.bodySmall.copyWith(
                                color: isSelected ? AppTheme.islamicGold : AppTheme.secondaryText,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Reward points
                    Text('النقاط', style: AppTheme.caption),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _rewardPoints > 5
                              ? () => setState(() => _rewardPoints -= 5)
                              : null,
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: _rewardPoints > 5 ? AppTheme.secondaryText : AppTheme.tertiaryText,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceGray,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star, color: AppTheme.islamicGold, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '$_rewardPoints',
                                  style: AppTheme.headlineLarge.copyWith(fontSize: 24),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'نقطة',
                                  style: AppTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _rewardPoints < 200
                              ? () => setState(() => _rewardPoints += 5)
                              : null,
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: _rewardPoints < 200 ? AppTheme.islamicGold : AppTheme.tertiaryText,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Save button
                    GestureDetector(
                      onTap: _saveTask,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: AppTheme.goldGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppTheme.goldGlow,
                        ),
                        child: Text(
                          'حفظ المهمة',
                          style: AppTheme.bodyLarge.copyWith(
                            color: AppTheme.carbonBlack,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
}
