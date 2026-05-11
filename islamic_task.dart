import 'package:equatable/equatable.dart';

enum TaskCategory {
  quran('قراءة القرآن', 'Quran Reading'),
  dhikr('الذكر', 'Dhikr'),
  prayer('الصلاة', 'Prayer'),
  qiyam('قيام الليل', 'Qiyam al-Layl'),
  fasting('الصيام', 'Fasting'),
  sadaqah('الصدقة', 'Charity'),
  dawah('الدعوة', 'Dawah'),
  other('أخرى', 'Other');

  final String labelAr;
  final String labelEn;

  const TaskCategory(this.labelAr, this.labelEn);
}

enum RepeatOption {
  once('مرة واحدة', 'Once'),
  daily('يومي', 'Daily'),
  weekly('أسبوعي', 'Weekly'),
  mondayToFriday('من الإثنين إلى الجمعة', 'Mon-Fri'),
  weekends('عطلة نهاية الأسبوع', 'Weekends');

  final String labelAr;
  final String labelEn;

  const RepeatOption(this.labelAr, this.labelEn);
}

class IslamicTask extends Equatable {
  final String id;
  final String title;
  final String description;
  final String time;
  final RepeatOption repeat;
  final bool isCompleted;
  final int streakDays;
  final int rewardPoints;
  final TaskCategory category;
  final DateTime createdAt;
  final DateTime? completedAt;

  const IslamicTask({
    required this.id,
    required this.title,
    this.description = '',
    required this.time,
    this.repeat = RepeatOption.daily,
    this.isCompleted = false,
    this.streakDays = 0,
    this.rewardPoints = 10,
    this.category = TaskCategory.other,
    required this.createdAt,
    this.completedAt,
  });

  IslamicTask copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    RepeatOption? repeat,
    bool? isCompleted,
    int? streakDays,
    int? rewardPoints,
    TaskCategory? category,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return IslamicTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      repeat: repeat ?? this.repeat,
      isCompleted: isCompleted ?? this.isCompleted,
      streakDays: streakDays ?? this.streakDays,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'repeat': repeat.index,
      'isCompleted': isCompleted,
      'streakDays': streakDays,
      'rewardPoints': rewardPoints,
      'category': category.index,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory IslamicTask.fromJson(Map<String, dynamic> json) {
    return IslamicTask(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      time: json['time'] as String,
      repeat: RepeatOption.values[json['repeat'] as int],
      isCompleted: json['isCompleted'] as bool,
      streakDays: json['streakDays'] as int,
      rewardPoints: json['rewardPoints'] as int,
      category: TaskCategory.values[json['category'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id, title, description, time, repeat, isCompleted,
        streakDays, rewardPoints, category, createdAt, completedAt,
      ];
}
