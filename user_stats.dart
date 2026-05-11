import 'package:equatable/equatable.dart';

class DailyStats extends Equatable {
  final DateTime date;
  final int completedTasks;
  final int totalTasks;
  final int pointsEarned;
  final int focusMinutes;

  const DailyStats({
    required this.date,
    this.completedTasks = 0,
    this.totalTasks = 0,
    this.pointsEarned = 0,
    this.focusMinutes = 0,
  });

  double get completionRate {
    if (totalTasks == 0) return 0.0;
    return completedTasks / totalTasks;
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
      'pointsEarned': pointsEarned,
      'focusMinutes': focusMinutes,
    };
  }

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: DateTime.parse(json['date'] as String),
      completedTasks: json['completedTasks'] as int,
      totalTasks: json['totalTasks'] as int,
      pointsEarned: json['pointsEarned'] as int,
      focusMinutes: json['focusMinutes'] as int,
    );
  }

  @override
  List<Object?> get props => [date, completedTasks, totalTasks, pointsEarned, focusMinutes];
}

class UserStats extends Equatable {
  final int totalPoints;
  final int currentStreak;
  final int longestStreak;
  final DateTime? streakLastUpdated;
  final int totalFocusMinutes;
  final int totalTasksCompleted;
  final List<DailyStats> dailyHistory;

  const UserStats({
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.streakLastUpdated,
    this.totalFocusMinutes = 0,
    this.totalTasksCompleted = 0,
    this.dailyHistory = const [],
  });

  UserStats copyWith({
    int? totalPoints,
    int? currentStreak,
    int? longestStreak,
    DateTime? streakLastUpdated,
    int? totalFocusMinutes,
    int? totalTasksCompleted,
    List<DailyStats>? dailyHistory,
  }) {
    return UserStats(
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      streakLastUpdated: streakLastUpdated ?? this.streakLastUpdated,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      totalTasksCompleted: totalTasksCompleted ?? this.totalTasksCompleted,
      dailyHistory: dailyHistory ?? this.dailyHistory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'streakLastUpdated': streakLastUpdated?.toIso8601String(),
      'totalFocusMinutes': totalFocusMinutes,
      'totalTasksCompleted': totalTasksCompleted,
      'dailyHistory': dailyHistory.map((e) => e.toJson()).toList(),
    };
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalPoints: json['totalPoints'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      streakLastUpdated: json['streakLastUpdated'] != null
          ? DateTime.parse(json['streakLastUpdated'] as String)
          : null,
      totalFocusMinutes: json['totalFocusMinutes'] as int? ?? 0,
      totalTasksCompleted: json['totalTasksCompleted'] as int? ?? 0,
      dailyHistory: (json['dailyHistory'] as List<dynamic>? ?? [])
          .map((e) => DailyStats.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        totalPoints, currentStreak, longestStreak,
        streakLastUpdated, totalFocusMinutes, totalTasksCompleted, dailyHistory,
      ];
}
