import 'package:flutter/material.dart';
import '../models/islamic_task.dart';
import '../services/storage_service.dart';

class TaskProvider extends ChangeNotifier {
  final StorageService _storageService;

  List<IslamicTask> _tasks = [];
  bool _isLoading = true;

  TaskProvider(this._storageService) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _storageService.getTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(IslamicTask task) async {
    await _storageService.addTask(task);
    await _loadTasks();
  }

  Future<void> updateTask(IslamicTask task) async {
    await _storageService.updateTask(task);
    await _loadTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await _storageService.deleteTask(taskId);
    await _loadTasks();
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
        completedAt: !task.isCompleted ? DateTime.now() : null,
        streakDays: !task.isCompleted ? task.streakDays + 1 : task.streakDays,
      );
      await _storageService.updateTask(updatedTask);
      await _loadTasks();
    }
  }

  Future<void> completeTask(String taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      if (!task.isCompleted) {
        final updatedTask = task.copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
          streakDays: task.streakDays + 1,
        );
        await _storageService.updateTask(updatedTask);
        await _loadTasks();
      }
    }
  }

  List<IslamicTask> get tasks => _tasks;
  List<IslamicTask> get pendingTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<IslamicTask> get completedTasks => _tasks.where((t) => t.isCompleted).toList();
  List<IslamicTask> get todayTasks => _tasks.where((t) => t.repeat == RepeatOption.daily).toList();
  
  int get totalTasks => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;
  double get completionPercentage => totalTasks > 0 ? (completedCount / totalTasks) * 100 : 0;
  
  int get todayPoints => _tasks
      .where((t) => t.isCompleted)
      .fold(0, (sum, t) => sum + t.rewardPoints);

  bool get isLoading => _isLoading;

  // Get tasks by category
  List<IslamicTask> getTasksByCategory(TaskCategory category) {
    return _tasks.where((t) => t.category == category).toList();
  }

  // Get next upcoming task
  IslamicTask? getNextUpcomingTask() {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;
    final currentTime = currentHour * 60 + currentMinute;

    final pending = pendingTasks.toList();
    pending.sort((a, b) {
      final aParts = a.time.split(':');
      final bParts = b.time.split(':');
      final aMinutes = int.parse(aParts[0]) * 60 + int.parse(aParts[1]);
      final bMinutes = int.parse(bParts[0]) * 60 + int.parse(bParts[1]);
      
      // Prefer tasks that are coming up soon
      final aDiff = (aMinutes - currentTime + 1440) % 1440;
      final bDiff = (bMinutes - currentTime + 1440) % 1440;
      return aDiff.compareTo(bDiff);
    });

    return pending.isNotEmpty ? pending.first : null;
  }
}
