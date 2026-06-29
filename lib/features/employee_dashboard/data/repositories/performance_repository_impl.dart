import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talentintel_ai/features/employee_dashboard/domain/entities/performance_entities.dart';
import 'package:talentintel_ai/features/employee_dashboard/domain/repositories/performance_repository.dart';

class PerformanceRepositoryImpl implements PerformanceRepository {
  @override
  Future<EmployeePerformance> getMyPerformance() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return _defaultPerformance();
    }

    final qs = await FirebaseFirestore.instance
        .collection('employees')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (qs.docs.isEmpty) {
      return _defaultPerformance();
    }

    final data = qs.docs.first.data();
    final score = (data['overall_score'] ?? 0.0 as num).toDouble();
    final rating = data['performance_rating'] as String? ?? 'No Rating';

    return EmployeePerformance(
      exemplaryProbability: score,
      targetThisMonth: 90.0,
      statusLabel: rating,
      attendancePercent: 100.0,
      tasksCompleted: 0,
      totalTasks: 0,
    );
  }

  EmployeePerformance _defaultPerformance() {
    return const EmployeePerformance(
      exemplaryProbability: 0.0,
      targetThisMonth: 90.0,
      statusLabel: 'Pending Evaluation',
      attendancePercent: 0.0,
      tasksCompleted: 0,
      totalTasks: 0,
    );
  }

  @override
  Future<List<TrendPoint>> getPerformanceTrend() async {
    final currentPerf = await getMyPerformance();
    final currentScore = currentPerf.exemplaryProbability;
    
    // If there's no real score yet, return a flat or empty trend
    if (currentScore == 0) {
      return const [
        TrendPoint(month: 'Jan', score: 0),
        TrendPoint(month: 'Feb', score: 0),
        TrendPoint(month: 'Mar', score: 0),
        TrendPoint(month: 'Apr', score: 0),
        TrendPoint(month: 'May', score: 0),
        TrendPoint(month: 'Jun', score: 0),
      ];
    }

    // Generate a realistic simulated trend leading up to current score
    // e.g. currentScore - 15, currentScore - 10, etc.
    return [
      TrendPoint(month: 'Jan', score: (currentScore - 12).clamp(0, 100)),
      TrendPoint(month: 'Feb', score: (currentScore - 8).clamp(0, 100)),
      TrendPoint(month: 'Mar', score: (currentScore - 10).clamp(0, 100)),
      TrendPoint(month: 'Apr', score: (currentScore - 5).clamp(0, 100)),
      TrendPoint(month: 'May', score: (currentScore - 2).clamp(0, 100)),
      TrendPoint(month: 'Jun', score: currentScore),
    ];
  }
}
