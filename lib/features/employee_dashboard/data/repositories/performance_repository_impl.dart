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
    // Currently returns static trend data until historical tracking is implemented in backend
    await Future.delayed(const Duration(milliseconds: 300));
    // For now, return an empty list if there's no real historical data yet.
    return const [];
  }
}
