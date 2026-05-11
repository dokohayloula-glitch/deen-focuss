import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/islamic_task.dart';
import '../models/user_stats.dart';

class StorageService {
  static const String _tasksKey = 'islamic_tasks';
  static const String _statsKey = 'user_stats';
  static const String _firstLaunchKey = 'first_launch';
  static const String _locationKey = 'user_location';
  static const String _settingsKey = 'app_settings';
  
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Initialize example data on first launch
    final isFirstLaunch = _prefs?.getBool(_firstLaunchKey) ?? true;
    if (isFirstLaunch) {
      await _initializeExampleData();
      await _prefs?.setBool(_firstLaunchKey, false);
    }
  }

  Future<void> _initializeExampleData() async {
    final now = DateTime.now();
    final exampleTasks = [
      IslamicTask(
        id: 'task_1',
        title: 'قراءة سورة البقرة',
        description: 'قراءة سورة البقرة كاملة بعد صلاة الفجر',
        time: '05:30',
        repeat: RepeatOption.daily,
        category: TaskCategory.quran,
        rewardPoints: 50,
        streakDays: 7,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      IslamicTask(
        id: 'task_2',
        title: 'أذكار الصباح',
        description: 'قراءة أذكار الصباح بعد صلاة الفجر',
        time: '05:45',
        repeat: RepeatOption.daily,
        category: TaskCategory.dhikr,
        rewardPoints: 20,
        streakDays: 15,
        createdAt: now.subtract(const Duration(days: 20)),
      ),
      IslamicTask(
        id: 'task_3',
        title: 'قيام الليل',
        description: 'صلاة قيام الليل - ركعتان على الأقل',
        time: '03:30',
        repeat: RepeatOption.daily,
        category: TaskCategory.qiyam,
        rewardPoints: 100,
        streakDays: 3,
        createdAt: now.subtract(const Duration(days: 15)),
      ),
      IslamicTask(
        id: 'task_4',
        title: 'ورد يومي من القرآن',
        description: 'قراءة 5 صفحات من القرآن الكريم',
        time: '07:00',
        repeat: RepeatOption.daily,
        category: TaskCategory.quran,
        rewardPoints: 30,
        streakDays: 12,
        createdAt: now.subtract(const Duration(days: 25)),
      ),
      IslamicTask(
        id: 'task_5',
        title: 'الصدقة اليومية',
        description: 'التصدق ولو بشيء يسير',
        time: '10:00',
        repeat: RepeatOption.daily,
        category: TaskCategory.sadaqah,
        rewardPoints: 25,
        streakDays: 5,
        createdAt: now.subtract(const Duration(days: 10)),
      ),
      IslamicTask(
        id: 'task_6',
        title: 'صلاة الضحى',
        description: 'صلاة الضحى - ركعتان إلى ثمانٍ',
        time: '08:30',
        repeat: RepeatOption.daily,
        category: TaskCategory.prayer,
        rewardPoints: 40,
        streakDays: 8,
        createdAt: now.subtract(const Duration(days: 18)),
      ),
      IslamicTask(
        id: 'task_7',
        title: 'أذكار المساء',
        description: 'قراءة أذكار المساء قبل المغرب',
        time: '17:30',
        repeat: RepeatOption.daily,
        category: TaskCategory.dhikr,
        rewardPoints: 20,
        streakDays: 20,
        createdAt: now.subtract(const Duration(days: 22)),
      ),
      IslamicTask(
        id: 'task_8',
        title: 'صيام الإثنين',
        description: 'صيام يوم الإثنين (سنة النبي ﷺ)',
        time: '04:30',
        repeat: RepeatOption.weekly,
        category: TaskCategory.fasting,
        rewardPoints: 80,
        streakDays: 2,
        createdAt: now.subtract(const Duration(days: 14)),
      ),
    ];

    await saveTasks(exampleTasks);

    // Initialize example stats
    final exampleStats = UserStats(
      totalPoints: 2450,
      currentStreak: 15,
      longestStreak: 45,
      streakLastUpdated: now.subtract(const Duration(days: 1)),
      totalFocusMinutes: 1200,
      totalTasksCompleted: 320,
      dailyHistory: _generateExampleDailyHistory(),
    );

    await saveStats(exampleStats);
  }

  List<DailyStats> _generateExampleDailyHistory() {
    final List<DailyStats> history = [];
    final now = DateTime.now();
    final random = Random(42);

    for (int i = 29; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final totalTasks = 5 + random.nextInt(4);
      final completedTasks = random.nextInt(totalTasks + 1);
      final focusMinutes = 20 + random.nextInt(60);
      
      history.add(DailyStats(
        date: date,
        completedTasks: completedTasks,
        totalTasks: totalTasks,
        pointsEarned: completedTasks * (10 + random.nextInt(40)),
        focusMinutes: focusMinutes,
      ));
    }

    return history;
  }

  // Tasks
  Future<List<IslamicTask>> getTasks() async {
    final tasksJson = _prefs?.getStringList(_tasksKey) ?? [];
    return tasksJson
        .map((json) => IslamicTask.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveTasks(List<IslamicTask> tasks) async {
    final tasksJson = tasks
        .map((task) => jsonEncode(task.toJson()))
        .toList();
    await _prefs?.setStringList(_tasksKey, tasksJson);
  }

  Future<void> addTask(IslamicTask task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTask(IslamicTask updatedTask) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == taskId);
    await saveTasks(tasks);
  }

  // Stats
  Future<UserStats> getStats() async {
    final statsJson = _prefs?.getString(_statsKey);
    if (statsJson != null) {
      return UserStats.fromJson(jsonDecode(statsJson));
    }
    return const UserStats();
  }

  Future<void> saveStats(UserStats stats) async {
    await _prefs?.setString(_statsKey, jsonEncode(stats.toJson()));
  }

  // Location
  Future<Map<String, double>?> getLocation() async {
    final lat = _prefs?.getDouble('${_locationKey}_lat');
    final lng = _prefs?.getDouble('${_locationKey}_lng');
    if (lat != null && lng != null) {
      return {'latitude': lat, 'longitude': lng};
    }
    return null;
  }

  Future<void> saveLocation(double latitude, double longitude) async {
    await _prefs?.setDouble('${_locationKey}_lat', latitude);
    await _prefs?.setDouble('${_locationKey}_lng', longitude);
  }

  // Settings
  Future<Map<String, dynamic>> getSettings() async {
    final settingsJson = _prefs?.getString(_settingsKey);
    if (settingsJson != null) {
      return jsonDecode(settingsJson) as Map<String, dynamic>;
    }
    return {};
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _prefs?.setString(_settingsKey, jsonEncode(settings));
  }

  // Reset
  Future<void> resetAllData() async {
    await _prefs?.remove(_tasksKey);
    await _prefs?.remove(_statsKey);
    await _prefs?.setBool(_firstLaunchKey, true);
    await _initializeExampleData();
    await _prefs?.setBool(_firstLaunchKey, false);
  }
}
