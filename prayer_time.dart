import 'package:equatable/equatable.dart';

class PrayerTime extends Equatable {
  final String nameAr;
  final String nameEn;
  final DateTime time;
  final bool isNext;
  final bool isNotified;

  const PrayerTime({
    required this.nameAr,
    required this.nameEn,
    required this.time,
    this.isNext = false,
    this.isNotified = false,
  });

  PrayerTime copyWith({
    String? nameAr,
    String? nameEn,
    DateTime? time,
    bool? isNext,
    bool? isNotified,
  }) {
    return PrayerTime(
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      time: time ?? this.time,
      isNext: isNext ?? this.isNext,
      isNotified: isNotified ?? this.isNotified,
    );
  }

  String get formattedTime {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Duration get timeRemaining {
    final now = DateTime.now();
    var diff = time.difference(now);
    if (diff.isNegative) {
      diff = diff + const Duration(days: 1);
    }
    return diff;
  }

  @override
  List<Object?> get props => [nameAr, nameEn, time, isNext, isNotified];
}

// Prayer names in Arabic and English
class PrayerNames {
  static const Map<String, Map<String, String>> prayers = {
    'fajr': {'ar': 'الفجر', 'en': 'Fajr'},
    'sunrise': {'ar': 'الشروق', 'en': 'Sunrise'},
    'dhuhr': {'ar': 'الظهر', 'en': 'Dhuhr'},
    'asr': {'ar': 'العصر', 'en': 'Asr'},
    'maghrib': {'ar': 'المغرب', 'en': 'Maghrib'},
    'isha': {'ar': 'العشاء', 'en': 'Isha'},
  };
}
