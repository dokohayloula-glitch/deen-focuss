import 'dart:async';
import 'package:flutter/material.dart';
import '../models/prayer_time.dart';
import '../services/prayer_service.dart';
import '../services/storage_service.dart';

class PrayerProvider extends ChangeNotifier {
  final PrayerService _prayerService;
  final StorageService _storageService;
  Timer? _timer;

  List<PrayerTime> _prayerTimes = [];
  PrayerTime? _nextPrayer;
  Duration _timeRemaining = Duration.zero;
  bool _isLoading = true;
  String? _error;

  PrayerProvider(this._prayerService, this._storageService) {
    _init();
  }

  Future<void> _init() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Try to load saved location
      final location = await _storageService.getLocation();
      if (location != null) {
        _prayerService.setLocation(location['latitude']!, location['longitude']!);
      } else {
        _prayerService.useDefaultLocation();
      }

      _loadPrayerTimes();
      
      // Start countdown timer
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadPrayerTimes() {
    _prayerTimes = _prayerService.getTodayPrayerTimes();
    _nextPrayer = _prayerService.getNextPrayer();
    if (_nextPrayer != null) {
      _timeRemaining = _nextPrayer!.timeRemaining;
    }
  }

  void _updateCountdown() {
    if (_nextPrayer != null) {
      _timeRemaining = _nextPrayer!.timeRemaining;
      
      // Check if prayer time has passed
      if (_timeRemaining.inSeconds <= 0) {
        _loadPrayerTimes();
      }
      
      notifyListeners();
    }
  }

  void setLocation(double latitude, double longitude) {
    _prayerService.setLocation(latitude, longitude);
    _storageService.saveLocation(latitude, longitude);
    _loadPrayerTimes();
    notifyListeners();
  }

  // Getters
  List<PrayerTime> get prayerTimes => _prayerTimes;
  PrayerTime? get nextPrayer => _nextPrayer;
  Duration get timeRemaining => _timeRemaining;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String get greeting => _prayerService.getGreeting();
  String get hijriDate => _prayerService.getHijriDate();
  String get gregorianDate => _prayerService.getFormattedGregorianDate();

  String get formattedCountdown {
    final hours = _timeRemaining.inHours;
    final minutes = _timeRemaining.inMinutes.remainder(60);
    final seconds = _timeRemaining.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
