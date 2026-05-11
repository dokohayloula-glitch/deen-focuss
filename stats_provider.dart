import 'package:flutter/material.dart';
import '../models/user_stats.dart';
import '../models/daily_stats.dart';
import '../services/storage_service.dart';

class StatsProvider extends ChangeNotifier {
  final StorageService _storageService;

  UserStats _stats = const UserStats();
  bool _isLoading = true;

  StatsProvider(this._storageService) {
    _loadStats();
  }

  Future<void> _loadStats() async {
    _isLoading = true;
    notifyListeners();

    _stats = await _storageService.getStats();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTaskCompletion(int points, int focusMinutes) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Update daily history
    var history = List<DailyStats>.from(_stats.dailyHistory);
    final todayIndex = history.indexWhere(
      (d) => d.date.year == today.year && d.date.month == today.month && d.date.day == today.day,
    );

    if (todayIndex != -1) {
      final todayStats = history[todayIndex];
      history[todayIndex] = DailyStats(
        date: today,
        completedTasks: todayStats.completedTasks + 1,
        totalTasks: todayStats.totalTasks + 1,
        pointsEarned: todayStats.pointsEarned + points,
        focusMinutes: todayStats.focusMinutes + focusMinutes,
      );
    } else {
      history.add(DailyStats(
        date: today,
        completedTasks: 1,
        totalTasks: 1,
        pointsEarned: points,
        focusMinutes: focusMinutes,
      ));
    }

    // Update streak
    final lastUpdated = _stats.streakLastUpdated;
    int currentStreak = _stats.currentStreak;
    
    if (lastUpdated != null) {
      final lastDate = DateTime(lastUpdated.year, lastUpdated.month, lastUpdated.day);
      final difference = today.difference(lastDate).inDays;
      
      if (difference == 1) {
        currentStreak += 1;
      } else if (difference > 1) {
        currentStreak = 1; // Reset streak
      }
    } else {
      currentStreak = 1;
    }

    _stats = _stats.copyWith(
      totalPoints: _stats.totalPoints + points,
      currentStreak: currentStreak,
      longestStreak: currentStreak > _stats.longestStreak ? currentStreak : _stats.longestStreak,
      streakLastUpdated: now,
      totalFocusMinutes: _stats.totalFocusMinutes + focusMinutes,
      totalTasksCompleted: _stats.totalTasksCompleted + 1,
      dailyHistory: history,
    );

    await _storageService.saveStats(_stats);
    notifyListeners();
  }

  Future<void> addFocusMinutes(int minutes) async {
    _stats = _stats.copyWith(
      totalFocusMinutes: _stats.totalFocusMinutes + minutes,
    );
    await _storageService.saveStats(_stats);
    notifyListeners();
  }

  // Getters
  UserStats get stats => _stats;
  bool get isLoading => _isLoading;

  int get totalPoints => _stats.totalPoints;
  int get currentStreak => _stats.currentStreak;
  int get longestStreak => _stats.longestStreak;
  int get totalFocusMinutes => _stats.totalFocusMinutes;
  int get totalTasksCompleted => _stats.totalTasksCompleted;

  // Weekly data for charts
  List<DailyStats> get last7Days {
    final now = DateTime.now();
    final List<DailyStats> result = [];
    
    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final dayStats = _stats.dailyHistory.firstWhere(
        (d) => d.date.year == date.year && d.date.month == date.month && d.date.day == date.day,
        orElse: () => DailyStats(date: date),
      );
      result.add(dayStats);
    }
    
    return result;
  }

  // Category breakdown
  Map<String, int> get weeklyPointsByDay {
    final days = last7Days;
    return {
      'الأحد': days[0].pointsEarned,
      'الإثنين': days[1].pointsEarned,
      'الثلاثاء': days[2].pointsEarned,
      'الأربعاء': days[3].pointsEarned,
      'الخميس': days[4].pointsEarned,
      'الجمعة': days[5].pointsEarned,
      'السبت': days[6].pointsEarned,
    };
  }
}
