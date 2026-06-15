import 'package:equatable/equatable.dart';

/// A snapshot of the HRD dashboard's key metrics.
class DashboardStats extends Equatable {
  final int activeEmployees;
  final double avgPredictionScore;
  final int exemplaryCandidates;
  final double highEligibilityTarget;

  const DashboardStats({
    required this.activeEmployees,
    required this.avgPredictionScore,
    required this.exemplaryCandidates,
    required this.highEligibilityTarget,
  });

  @override
  List<Object?> get props => [
        activeEmployees,
        avgPredictionScore,
        exemplaryCandidates,
        highEligibilityTarget,
      ];
}

/// A candidate shown in the "Top 5 Exemplary" leaderboard.
class EmployeeCandidate extends Equatable {
  final String id;
  final String name;
  final String department;
  final String position;
  final double score;
  final String status; // e.g. "Highly Eligible"

  const EmployeeCandidate({
    required this.id,
    required this.name,
    required this.department,
    required this.position,
    required this.score,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, department, position, score, status];
}

/// Performance data for a single department.
class DepartmentPerformance extends Equatable {
  final String department;
  final int meetTarget;
  final int needsImprovement;
  final int belowExpectation;

  const DepartmentPerformance({
    required this.department,
    required this.meetTarget,
    required this.needsImprovement,
    required this.belowExpectation,
  });

  int get total => meetTarget + needsImprovement + belowExpectation;

  @override
  List<Object?> get props =>
      [department, meetTarget, needsImprovement, belowExpectation];
}
