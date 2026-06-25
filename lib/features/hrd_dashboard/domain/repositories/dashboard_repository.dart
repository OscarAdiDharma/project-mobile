import 'package:talentintel_ai/features/hrd_dashboard/domain/entities/dashboard_entities.dart';

/// Contract for fetching HRD dashboard data.
abstract class DashboardRepository {
  Future<DashboardStats> getStats();
  Future<List<EmployeeCandidate>> getTopCandidates();
  Future<List<DepartmentPerformance>> getDepartmentPerformance();
  Future<void> deleteEmployee(String id);
}
