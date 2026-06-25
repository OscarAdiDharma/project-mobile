import 'package:talentintel_ai/features/hrd_dashboard/domain/entities/dashboard_entities.dart';
import 'package:talentintel_ai/features/hrd_dashboard/domain/repositories/dashboard_repository.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<DashboardStats> getStats() async {
    final snapshot = await firestore.collection('employees').get();
    
    if (snapshot.docs.isEmpty) {
      return const DashboardStats(
        activeEmployees: 0,
        avgPredictionScore: 0.0,
        exemplaryCandidates: 0,
        highEligibilityTarget: 90.0,
      );
    }

    int activeEmployees = snapshot.docs.length;
    double totalScore = 0;
    int exemplaryCandidates = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final score = (data['overall_score'] ?? 0.0) as num;
      totalScore += score.toDouble();
      
      final rating = data['performance_rating'] as String?;
      if (rating == 'High') {
        exemplaryCandidates++;
      }
    }

    double avgPredictionScore = totalScore / activeEmployees;

    return DashboardStats(
      activeEmployees: activeEmployees,
      avgPredictionScore: double.parse(avgPredictionScore.toStringAsFixed(1)),
      exemplaryCandidates: exemplaryCandidates,
      highEligibilityTarget: 90.0,
    );
  }

  @override
  Future<List<EmployeeCandidate>> getTopCandidates() async {
    final snapshot = await firestore
        .collection('employees')
        .orderBy('overall_score', descending: true)
        .limit(5)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return EmployeeCandidate(
        id: data['employee_id']?.toString() ?? doc.id,
        name: data['name'] ?? 'Unknown',
        department: data['department'] ?? 'Unknown',
        position: data['position'] ?? 'Unknown',
        score: (data['overall_score'] ?? 0.0 as num).toDouble(),
        status: data['status'] ?? 'Unknown',
      );
    }).toList();
  }

  @override
  Future<List<DepartmentPerformance>> getDepartmentPerformance() async {
    final snapshot = await firestore.collection('employees').get();
    
    // Map to group by department
    // departmentName -> {'High': x, 'Medium': y, 'Low': z}
    final Map<String, Map<String, int>> deptStats = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final dept = data['department'] as String? ?? 'Unknown';
      final rating = data['performance_rating'] as String? ?? 'Low';
      
      deptStats.putIfAbsent(dept, () => {'High': 0, 'Medium': 0, 'Low': 0});
      
      if (rating == 'High') deptStats[dept]!['High'] = deptStats[dept]!['High']! + 1;
      else if (rating == 'Medium') deptStats[dept]!['Medium'] = deptStats[dept]!['Medium']! + 1;
      else deptStats[dept]!['Low'] = deptStats[dept]!['Low']! + 1;
    }

    return deptStats.entries.map((entry) {
      return DepartmentPerformance(
        department: entry.key,
        meetTarget: entry.value['High']!,
        needsImprovement: entry.value['Medium']!,
        belowExpectation: entry.value['Low']!,
      );
    }).toList();
  }
}
