import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/focus_session.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class FocusProvider extends ChangeNotifier {
  final StorageService _storageService;
  final NotificationService _notificationService;
  Timer? _timer;
  Timer? _reminderTimer;

  FocusSession _session = FocusSession(
    id: '',
    taskId: '',
    taskTitle: '',
    startedAt: DateTime.now(),
    duration: Duration.zero,
  );

  bool _showConfetti = false;

  FocusProvider(this._storageService, this._notificationService);

  FocusSession get session => _session;
  bool get showConfetti => _showConfetti;
  bool get isActive => _session.state == FocusState.running || _session.state == FocusState.paused;
  bool get isRunning => _session.state == FocusState.running;
  bool get isPaused => _session.state == FocusState.paused;

  void startCommitment(String taskId, String taskTitle) {
    _session = FocusSession(
      id: 'focus_${DateTime.now().millisecondsSinceEpoch}',
      taskId: taskId,
      taskTitle: taskTitle,
      startedAt: DateTime.now(),
      duration: const Duration(minutes: 25),
      remaining: const Duration(minutes: 25),
      state: FocusState.committed,
    );
    notifyListeners();
  }

  void setCommitmentText(String text) {
    _session = _session.copyWith(commitmentText: text);
    notifyListeners();
  }

  void setDuration(Duration duration) {
    _session = _session.copyWith(duration: duration, remaining: duration);
    notifyListeners();
  }

  void startFocus() {
    _session = _session.copyWith(
      startedAt: DateTime.now(),
      state: FocusState.running,
    );
    _startTimer();
    notifyListeners();
  }

  void pauseFocus() {
    _timer?.cancel();
    _reminderTimer?.cancel();
    _session = _session.copyWith(state: FocusState.paused);
    notifyListeners();
  }

  void resumeFocus() {
    _session = _session.copyWith(state: FocusState.running);
    _startTimer();
    notifyListeners();
  }

  void stopFocus() {
    _timer?.cancel();
    _reminderTimer?.cancel();
    _session = _session.copyWith(
      state: FocusState.cancelled,
      endedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void completeFocus() {
    _timer?.cancel();
    _reminderTimer?.cancel();
    _showConfetti = true;
    _session = _session.copyWith(
      state: FocusState.completed,
      remaining: Duration.zero,
      endedAt: DateTime.now(),
    );
    notifyListeners();
    
    // Hide confetti after animation
    Future.delayed(const Duration(seconds: 3), () {
      _showConfetti = false;
      notifyListeners();
    });
  }

  void reset() {
    _timer?.cancel();
    _reminderTimer?.cancel();
    _session = FocusSession(
      id: '',
      taskId: '',
      taskTitle: '',
      startedAt: DateTime.now(),
      duration: Duration.zero,
    );
    _showConfetti = false;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _reminderTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_session.remaining.inSeconds <= 0) {
        completeFocus();
        return;
      }

      _session = _session.copyWith(
        remaining: _session.remaining - const Duration(seconds: 1),
      );
      notifyListeners();
    });

    // Send periodic reminders during focus
    _reminderTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (_session.state == FocusState.running) {
        _notificationService.showFocusReminder();
      }
    });
  }

  // Motivational quotes
  final List<Map<String, String>> _motivationalQuotes = [
    {
      'text': 'إنما الأعمال بالنيات',
      'source': 'حديث شريف',
    },
    {
      'text': 'من أحيا سنتي فقد أحبني',
      'source': 'النبي ﷺ',
    },
    {
      'text': 'خيركم من تعلم القرآن وعلمه',
      'source': 'النبي ﷺ',
    },
    {
      'text': 'الدنيا سجن المؤمن وجنة الكافر',
      'source': 'النبي ﷺ',
    },
    {
      'text': 'من يتق الله يجعل له مخرجا',
      'source': 'القرآن الكريم',
    },
    {
      'text': 'إن مع العسر يسرا',
      'source': 'القرآن الكريم',
    },
    {
      'text': ' واصبر لحكم ربك فإنك بأعيننا',
      'source': 'القرآن الكريم',
    },
    {
      'text': 'من توكل على الله فهو حسبه',
      'source': 'القرآن الكريم',
    },
  ];

  Map<String, String> getRandomQuote() {
    final random = Random();
    return _motivationalQuotes[random.nextInt(_motivationalQuotes.length)];
  }

  @override
  void dispose() {
    _timer?.cancel();
    _reminderTimer?.cancel();
    super.dispose();
  }
}
