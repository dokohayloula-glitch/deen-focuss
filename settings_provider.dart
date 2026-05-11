import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService;

  bool _notificationsEnabled = true;
  bool _prayerNotifications = true;
  bool _taskNotifications = true;
  bool _focusReminders = true;
  bool _darkMode = true;
  String _userName = 'عبد الله';
  String _language = 'ar';
  TimeOfDay _morningReminderTime = const TimeOfDay(hour: 5, minute: 30);
  TimeOfDay _eveningReminderTime = const TimeOfDay(hour: 20, minute: 0);

  SettingsProvider(this._storageService) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _storageService.getSettings();
    
    _notificationsEnabled = settings['notificationsEnabled'] ?? true;
    _prayerNotifications = settings['prayerNotifications'] ?? true;
    _taskNotifications = settings['taskNotifications'] ?? true;
    _focusReminders = settings['focusReminders'] ?? true;
    _darkMode = settings['darkMode'] ?? true;
    _userName = settings['userName'] ?? 'عبد الله';
    _language = settings['language'] ?? 'ar';
    
    final morningHour = settings['morningReminderHour'];
    final morningMinute = settings['morningReminderMinute'];
    if (morningHour != null && morningMinute != null) {
      _morningReminderTime = TimeOfDay(hour: morningHour, minute: morningMinute);
    }
    
    final eveningHour = settings['eveningReminderHour'];
    final eveningMinute = settings['eveningReminderMinute'];
    if (eveningHour != null && eveningMinute != null) {
      _eveningReminderTime = TimeOfDay(hour: eveningHour, minute: eveningMinute);
    }

    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final settings = {
      'notificationsEnabled': _notificationsEnabled,
      'prayerNotifications': _prayerNotifications,
      'taskNotifications': _taskNotifications,
      'focusReminders': _focusReminders,
      'darkMode': _darkMode,
      'userName': _userName,
      'language': _language,
      'morningReminderHour': _morningReminderTime.hour,
      'morningReminderMinute': _morningReminderTime.minute,
      'eveningReminderHour': _eveningReminderTime.hour,
      'eveningReminderMinute': _eveningReminderTime.minute,
    };
    await _storageService.saveSettings(settings);
  }

  // Setters
  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setPrayerNotifications(bool value) async {
    _prayerNotifications = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setTaskNotifications(bool value) async {
    _taskNotifications = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setFocusReminders(bool value) async {
    _focusReminders = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    _userName = name;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setMorningReminderTime(TimeOfDay time) async {
    _morningReminderTime = time;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setEveningReminderTime(TimeOfDay time) async {
    _eveningReminderTime = time;
    await _saveSettings();
    notifyListeners();
  }

  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  bool get prayerNotifications => _prayerNotifications;
  bool get taskNotifications => _taskNotifications;
  bool get focusReminders => _focusReminders;
  bool get darkMode => _darkMode;
  String get userName => _userName;
  String get language => _language;
  TimeOfDay get morningReminderTime => _morningReminderTime;
  TimeOfDay get eveningReminderTime => _eveningReminderTime;
}
