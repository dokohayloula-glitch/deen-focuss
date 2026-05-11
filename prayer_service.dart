import 'dart:async';
import 'package:adhan/adhan.dart';
import '../models/prayer_time.dart';

class PrayerService {
  Coordinates? _coordinates;
  CalculationParameters? _params;
  DateTime _lastCalculated = DateTime(2000);
  List<PrayerTime> _cachedTimes = [];

  void setLocation(double latitude, double longitude) {
    _coordinates = Coordinates(latitude, longitude);
    _params = CalculationMethod.muslimWorldLeague.getParameters();
    _params!.madhab = Madhab.shafi;
    _cachedTimes.clear();
    _lastCalculated = DateTime(2000);
  }

  void useDefaultLocation() {
    // Default to Makkah
    setLocation(21.4225, 39.8262);
  }

  List<PrayerTime> getTodayPrayerTimes() {
    if (_coordinates == null || _params == null) {
      useDefaultLocation();
    }

    final now = DateTime.now();
    // Recalculate if date changed or first time
    if (now.day != _lastCalculated.day || _cachedTimes.isEmpty) {
      _cachedTimes = _calculatePrayerTimes(now);
      _lastCalculated = now;
    }

    // Update which prayer is next
    return _updateNextPrayer(_cachedTimes);
  }

  List<PrayerTime> _calculatePrayerTimes(DateTime date) {
    final prayerTimes = PrayerTimes(_coordinates!, DateComponents(date.year, date.month, date.day), _params!);

    final times = [
      _createPrayerTime('fajr', prayerTimes.fajr),
      _createPrayerTime('sunrise', prayerTimes.sunrise),
      _createPrayerTime('dhuhr', prayerTimes.dhuhr),
      _createPrayerTime('asr', prayerTimes.asr),
      _createPrayerTime('maghrib', prayerTimes.maghrib),
      _createPrayerTime('isha', prayerTimes.isha),
    ];

    return times;
  }

  PrayerTime _createPrayerTime(String key, DateTime time) {
    final names = PrayerNames.prayers[key]!;
    return PrayerTime(
      nameAr: names['ar']!,
      nameEn: names['en']!,
      time: time,
    );
  }

  List<PrayerTime> _updateNextPrayer(List<PrayerTime> times) {
    final now = DateTime.now();
    PrayerTime? nextPrayer;
    Duration shortestDuration = const Duration(days: 1);

    for (final prayer in times) {
      var diff = prayer.time.difference(now);
      // Handle case where prayer time has passed today
      if (diff.isNegative) {
        diff = diff + const Duration(days: 1);
      }
      
      if (diff < shortestDuration && diff > Duration.zero) {
        shortestDuration = diff;
        nextPrayer = prayer;
      }
    }

    return times.map((p) => p.copyWith(isNext: p == nextPrayer)).toList();
  }

  PrayerTime? getNextPrayer() {
    final times = getTodayPrayerTimes();
    try {
      return times.firstWhere((p) => p.isNext);
    } catch (_) {
      return times.isNotEmpty ? times.first : null;
    }
  }

  String getHijriDate() {
    final now = DateTime.now();
    // Hijri date formatting - simplified
    final hijriMonths = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
    ];
    
    // Approximate conversion for display
    final hijriYear = now.year - 579;
    final hijriMonth = hijriMonths[(now.month + 1) % 12];
    final hijriDay = now.day;
    
    return '$hijriDay $hijriMonth $hijriYear هـ';
  }

  String getFormattedGregorianDate() {
    final now = DateTime.now();
    final months = [
      'يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    final days = [
      'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس',
      'الجمعة', 'السبت', 'الأحد'
    ];
    
    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];
    
    return '$dayName، ${now.day} $monthName ${now.year}';
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'صباح الخير';
    } else if (hour >= 12 && hour < 17) {
      return 'مساء الخير';
    } else if (hour >= 17 && hour < 21) {
      return 'مساء النور';
    } else {
      return 'تصبح على خير';
    }
  }
}
