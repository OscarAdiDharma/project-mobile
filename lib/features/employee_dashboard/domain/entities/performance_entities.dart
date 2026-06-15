import 'package:equatable/equatable.dart';

/// Current performance snapshot for an employee.
class EmployeePerformance extends Equatable {
  final double exemplaryProbability; // 0–100%
  final double targetThisMonth;
  final String statusLabel; // e.g. "Very Good"
  final double attendancePercent;
  final int tasksCompleted;
  final int totalTasks;

  const EmployeePerformance({
    required this.exemplaryProbability,
    required this.targetThisMonth,
    required this.statusLabel,
    required this.attendancePercent,
    required this.tasksCompleted,
    required this.totalTasks,
  });

  @override
  List<Object?> get props => [
        exemplaryProbability,
        targetThisMonth,
        statusLabel,
        attendancePercent,
        tasksCompleted,
        totalTasks,
      ];
}

/// A single data point in the performance trend line chart.
class TrendPoint extends Equatable {
  final String month; // e.g. "Jan"
  final double score;

  const TrendPoint({required this.month, required this.score});

  @override
  List<Object?> get props => [month, score];
}
