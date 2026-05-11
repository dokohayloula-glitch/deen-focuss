import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Request notification permissions
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    _initialized = true;
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap
  }

  Future<void> showPrayerReminder(String prayerName, DateTime prayerTime) async {
    final scheduledTime = prayerTime.subtract(const Duration(minutes: 15));
    if (scheduledTime.isBefore(DateTime.now())) return;

    await _notifications.zonedSchedule(
      _notificationId('prayer', prayerName),
      'تذكير بالصلاة',
      'حان وقت صلاة $prayerName',
      tz.TZDateTime.from(scheduledTime, tz.local),
      _notificationDetails('prayer_reminders', 'تذكيرات الصلاة'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showTaskReminder(String taskTitle, DateTime taskTime) async {
    if (taskTime.isBefore(DateTime.now())) return;

    await _notifications.zonedSchedule(
      _notificationId('task', taskTitle),
      'تذكير بالمهمة',
      'حان وقت: $taskTitle',
      tz.TZDateTime.from(taskTime, tz.local),
      _notificationDetails('task_reminders', 'تذكيرات المهام'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showFocusReminder() async {
    await _notifications.show(
      9999,
      'وضع التركيز نشط',
      'تذكر أنك في وضع التركيز. استمر في عبادتك!',
      _notificationDetails('focus_mode', 'وضع التركيز'),
    );
  }

  Future<void> showIncompleteTasksReminder(int incompleteCount) async {
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, 20, 0);
    
    if (scheduledTime.isBefore(now)) return;

    await _notifications.zonedSchedule(
      8888,
      'مهام غير مكتملة',
      'لديك $incompleteCount مهام غير مكتملة لهذا اليوم. أكملها قبل النوم!',
      tz.TZDateTime.from(scheduledTime, tz.local),
      _notificationDetails('task_reminders', 'تذكيرات المهام'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelPrayerReminders() async {
    await _notifications.cancelAll();
  }

  NotificationDetails _notificationDetails(String channelId, String channelName) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: 'Deen Focus notifications',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        enableLights: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      ),
    );
  }

  int _notificationId(String type, String key) {
    return '$type:$key'.hashCode;
  }
}
