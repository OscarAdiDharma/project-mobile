import 'package:talentintel_ai/features/employee_dashboard/domain/entities/performance_entities.dart';
import 'package:talentintel_ai/features/employee_dashboard/domain/repositories/performance_repository.dart';

/// Mock performance data matching the mockup values.
class PerformanceRepositoryImpl implements PerformanceRepository {
  @override
  Future<EmployeePerformance> getMyPerformance() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const EmployeePerformance(
      exemplaryProbability: 78.0,
      targetThisMonth: 85.0,
      statusLabel: 'Very Good',
      attendancePercent: 98.0,
      tasksCompleted: 45,
      totalTasks: 50,
    );
  }

  @override
  Future<List<TrendPoint>> getPerformanceTrend() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      TrendPoint(month: 'Jan', score: 65),
      TrendPoint(month: 'Feb', score: 68),
      TrendPoint(month: 'Mar', score: 72),
      TrendPoint(month: 'Apr', score: 70),
      TrendPoint(month: 'May', score: 75),
      TrendPoint(month: 'Jun', score: 78),
    ];
  }
}
