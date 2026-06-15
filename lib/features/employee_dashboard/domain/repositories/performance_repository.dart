import 'package:talentintel_ai/features/employee_dashboard/domain/entities/performance_entities.dart';

/// Contract for employee performance data.
abstract class PerformanceRepository {
  Future<EmployeePerformance> getMyPerformance();
  Future<List<TrendPoint>> getPerformanceTrend();
}
