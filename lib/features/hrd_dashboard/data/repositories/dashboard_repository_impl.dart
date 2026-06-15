import 'package:talentintel_ai/features/hrd_dashboard/domain/entities/dashboard_entities.dart';
import 'package:talentintel_ai/features/hrd_dashboard/domain/repositories/dashboard_repository.dart';

/// Mock implementation with realistic demo data.
///
/// The values here match the numbers shown in the mockup screenshots
/// so the app looks identical to the design.
class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<DashboardStats> getStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const DashboardStats(
      activeEmployees: 1284,
      avgPredictionScore: 89.4,
      exemplaryCandidates: 42,
      highEligibilityTarget: 91.0,
    );
  }

  @override
  Future<List<EmployeeCandidate>> getTopCandidates() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      EmployeeCandidate(
        id: 'emp-001',
        name: 'Sarah K.',
        department: 'IT',
        position: 'Dept. IT',
        score: 98.2,
        status: 'Highly Eligible',
      ),
      EmployeeCandidate(
        id: 'emp-002',
        name: 'Budi Santoso',
        department: 'Engineering',
        position: 'Lead Developer',
        score: 96.5,
        status: 'Highly Eligible',
      ),
      EmployeeCandidate(
        id: 'emp-003',
        name: 'Citra Lestari',
        department: 'Marketing',
        position: 'Marketing Specialist',
        score: 94.8,
        status: 'Highly Eligible',
      ),
      EmployeeCandidate(
        id: 'emp-004',
        name: 'Adi Nugroho',
        department: 'Operations',
        position: 'Dept. Ops',
        score: 93.1,
        status: 'Eligible',
      ),
      EmployeeCandidate(
        id: 'emp-005',
        name: 'Siska A.',
        department: 'Sales',
        position: 'Sales Analyst',
        score: 91.7,
        status: 'Eligible',
      ),
    ];
  }

  @override
  Future<List<DepartmentPerformance>> getDepartmentPerformance() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      DepartmentPerformance(
        department: 'IT',
        meetTarget: 45,
        needsImprovement: 12,
        belowExpectation: 3,
      ),
      DepartmentPerformance(
        department: 'Sales',
        meetTarget: 38,
        needsImprovement: 18,
        belowExpectation: 6,
      ),
      DepartmentPerformance(
        department: 'Ops',
        meetTarget: 30,
        needsImprovement: 15,
        belowExpectation: 5,
      ),
      DepartmentPerformance(
        department: 'HR',
        meetTarget: 22,
        needsImprovement: 8,
        belowExpectation: 2,
      ),
    ];
  }
}
