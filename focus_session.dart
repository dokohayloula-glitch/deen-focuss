import 'package:equatable/equatable.dart';

enum FocusState {
  idle,
  committed,
  running,
  paused,
  completed,
  cancelled,
}

class FocusSession extends Equatable {
  final String id;
  final String taskId;
  final String taskTitle;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration duration;
  final Duration remaining;
  final FocusState state;
  final String commitmentText;

  const FocusSession({
    required this.id,
    required this.taskId,
    required this.taskTitle,
    required this.startedAt,
    this.endedAt,
    required this.duration,
    this.remaining = Duration.zero,
    this.state = FocusState.idle,
    this.commitmentText = '',
  });

  FocusSession copyWith({
    String? id,
    String? taskId,
    String? taskTitle,
    DateTime? startedAt,
    DateTime? endedAt,
    Duration? duration,
    Duration? remaining,
    FocusState? state,
    String? commitmentText,
  }) {
    return FocusSession(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      taskTitle: taskTitle ?? this.taskTitle,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
      remaining: remaining ?? this.remaining,
      state: state ?? this.state,
      commitmentText: commitmentText ?? this.commitmentText,
    );
  }

  double get progress {
    if (duration.inSeconds == 0) return 0.0;
    final elapsed = duration.inSeconds - remaining.inSeconds;
    return elapsed / duration.inSeconds;
  }

  String get formattedRemaining {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [
        id, taskId, taskTitle, startedAt, endedAt,
        duration, remaining, state, commitmentText,
      ];
}
