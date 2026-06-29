import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/core/widgets/stat_card.dart';
import 'package:talentintel_ai/core/widgets/section_header.dart';
import 'package:talentintel_ai/core/widgets/status_badge.dart';
import 'package:talentintel_ai/features/hrd_dashboard/domain/entities/dashboard_entities.dart';
import 'package:talentintel_ai/features/hrd_dashboard/presentation/bloc/dashboard_bloc.dart';

/// HRD Executive Summary dashboard.
///
/// Layout:
/// 1. Stat cards row (employees, score, exemplary count)
/// 2. Department performance bar chart
/// 3. Top 5 candidates leaderboard
/// 4. AI Insight card (gradient)
class HrdDashboardPage extends StatelessWidget {
  const HrdDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.isLoading && state.stats == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<DashboardBloc>()
                .add(const DashboardLoadRequested());
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Header ────────────────────────────────────
              Text(
                AppStrings.executiveSummary,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.executiveSummarySubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              // ── Stat Cards ────────────────────────────────
              if (state.stats != null) _buildStatCards(state.stats!),
              const SizedBox(height: 20),

              // ── Department Performance Chart ──────────────
              if (state.departments.isNotEmpty) ...[
                SectionHeader(
                  title: AppStrings.departmentPerformance,
                ),
                const SizedBox(height: 8),
                Text(
                  'Based on effective performance per Q3 2023',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                _buildDepartmentChart(context, state.departments),
                const SizedBox(height: 12),
                _buildChartLegend(),
                const SizedBox(height: 20),
              ],

              // ── Top 5 Candidates ──────────────────────────
              if (state.topCandidates.isNotEmpty) ...[
                SectionHeader(
                  title: AppStrings.topCandidates,
                  actionLabel: AppStrings.viewAll,
                  onAction: () {},
                ),
                const SizedBox(height: 12),
                ...state.topCandidates
                    .take(5)
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) => _buildCandidateRow(
                          context,
                          entry.key + 1,
                          entry.value,
                        )),
                const SizedBox(height: 20),
              ],

              // ── AI Insight Card ───────────────────────────
              _buildAiInsightCard(context),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCards(DashboardStats stats) {
    return Column(
      children: [
        StatCard(
          title: AppStrings.activeEmployees,
          value: '${stats.activeEmployees}',
          trend: '+3.5% from total data',
          isTrendPositive: true,
          icon: Icons.people_alt_rounded,
          iconColor: AppColors.primaryBlue,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: AppStrings.avgPredictionScore,
                value: '${stats.avgPredictionScore}%',
                subtitle: 'High Eligibility Score (>85)',
                icon: Icons.analytics_rounded,
                iconColor: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: AppStrings.exemplaryThisMonth,
                value: '${stats.exemplaryCandidates}',
                subtitle: 'Target reached by 91% department',
                icon: Icons.emoji_events_rounded,
                iconColor: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Horizontal stacked bar chart for department performance.
  Widget _buildDepartmentChart(BuildContext context, List<DepartmentPerformance> departments) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 220, // slightly taller to give room for text
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              // dynamically set width based on number of departments
              width: departments.length > 4 
                  ? departments.length * 80.0 
                  : MediaQuery.of(context).size.width - 64,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: departments
                      .map((d) => d.total.toDouble())
                      .reduce((a, b) => a > b ? a : b),
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < departments.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                departments[index].department,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: departments.asMap().entries.map((entry) {
                    final dept = entry.value;
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: dept.total.toDouble(),
                          width: 28,
                          borderRadius: BorderRadius.circular(6),
                          rodStackItems: [
                            BarChartRodStackItem(
                              0,
                              dept.meetTarget.toDouble(),
                              AppColors.primaryBlue,
                            ),
                            BarChartRodStackItem(
                              dept.meetTarget.toDouble(),
                              (dept.meetTarget + dept.needsImprovement).toDouble(),
                              AppColors.warning,
                            ),
                            BarChartRodStackItem(
                              (dept.meetTarget + dept.needsImprovement).toDouble(),
                              dept.total.toDouble(),
                              AppColors.error,
                            ),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendDot(AppColors.primaryBlue, 'Meets Target'),
        const SizedBox(width: 16),
        _legendDot(AppColors.warning, 'Needs Improvement'),
        const SizedBox(width: 16),
        _legendDot(AppColors.error, 'Below Expectation'),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  /// A single row in the top-candidates leaderboard.
  Widget _buildCandidateRow(
    BuildContext context,
    int rank,
    EmployeeCandidate candidate,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
          child: Text(
            '$rank',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
        title: Text(
          candidate.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          candidate.position,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${candidate.score.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge(
              label: candidate.status,
              type: candidate.score >= 95
                  ? StatusType.success
                  : StatusType.info,
            ),
          ],
        ),
      ),
    );
  }

  /// Gradient card with today's AI insight, matching the mockup.
  Widget _buildAiInsightCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                AppStrings.aiInsightTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'The IT Department shows a 12% productivity improvement trend. '
            'Based on NCF pattern analysis, 5 candidates in the Sales department '
            'have high potential for quarterly promotion.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to NCF insights tab on the employee shell, or
              // show a detailed recommendations dialog.
              _showRecommendationsDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primaryBlue,
            ),
            child: const Text('View Recommendations'),
          ),
        ],
      ),
    );
  }

  void _showRecommendationsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.auto_awesome,
                      color: AppColors.primaryBlue, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'AI Recommendations',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Based on NCF pattern analysis and latest performance data',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 20),

              _recommendationTile(
                context,
                icon: Icons.trending_up_rounded,
                color: AppColors.success,
                title: 'IT Department Improvement',
                subtitle:
                    'The IT Department shows a 12% productivity improvement trend. '
                    'Recommend maintaining current workload and training schedule.',
                priority: 'HIGH',
              ),
              const SizedBox(height: 12),
              _recommendationTile(
                context,
                icon: Icons.star_rounded,
                color: AppColors.warning,
                title: 'Promotion Candidates',
                subtitle:
                    '5 candidates in the Sales department have high potential '
                    'for quarterly promotion based on consistent performance above 90%.',
                priority: 'MEDIUM',
              ),
              const SizedBox(height: 12),
              _recommendationTile(
                context,
                icon: Icons.school_rounded,
                color: AppColors.primaryBlue,
                title: 'Training Recommendation',
                subtitle:
                    'Finance team members would benefit from advanced data analytics '
                    'training to improve their KPI scores by an estimated 8-15%.',
                priority: 'MEDIUM',
              ),
              const SizedBox(height: 12),
              _recommendationTile(
                context,
                icon: Icons.warning_amber_rounded,
                color: AppColors.error,
                title: 'Attention Required',
                subtitle:
                    '3 employees in Operations have shown declining performance '
                    'over the last 2 months. Schedule one-on-one reviews.',
                priority: 'URGENT',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recommendationTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String priority,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: priority == 'URGENT'
                              ? AppColors.error.withValues(alpha: 0.1)
                              : priority == 'HIGH'
                                  ? AppColors.success.withValues(alpha: 0.1)
                                  : AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          priority,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: priority == 'URGENT'
                                ? AppColors.error
                                : priority == 'HIGH'
                                    ? AppColors.success
                                    : AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
