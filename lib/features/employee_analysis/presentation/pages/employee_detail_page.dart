import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'dart:math' as math;

/// Employee detail analysis page (viewed by HRD).
///
/// Shows employee profile, radar chart of KPI scores,
/// individual score cards, and development recommendations.
class EmployeeDetailPage extends StatelessWidget {
  const EmployeeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.individualAnalysis),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Employee Header ──────────────────────────
          _buildEmployeeHeader(context),
          const SizedBox(height: 24),

          // ── KPI Radar Chart ─────────────────────────
          Text(
            AppStrings.kpiDetails,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Period: Q3 2024',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          _buildRadarChart(),
          const SizedBox(height: 24),

          // ── Score Cards ─────────────────────────────
          _buildScoreGrid(context),
          const SizedBox(height: 24),

          // ── Development Recommendations ─────────────
          Text(
            AppStrings.developmentRecommendations,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          _buildRecommendationCard(
            context,
            icon: Icons.schedule_rounded,
            title: 'Optimize Punctuality',
            description:
                'Improve meeting attendance and deadline compliance by 15% '
                'to raise the overall performance score rapidly.',
            color: AppColors.warning,
          ),
          const SizedBox(height: 12),
          _buildRecommendationCard(
            context,
            icon: Icons.groups_rounded,
            title: 'Mentorship Program',
            description:
                'With a strong Teamwork score, Budi is highly recommended '
                'to mentor junior developers in the department.',
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: 24),

          // ── Download PDF ────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PDF report would be generated here')),
                );
              },
              icon: const Icon(Icons.picture_as_pdf_rounded),
              label: const Text(AppStrings.downloadPdf),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmployeeHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.lightBlue,
              child: Icon(Icons.person, size: 32, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Budi Santoso',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Information Technology',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'NCF: Highly Eligible',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadarChart() {
    final scores = [96.0, 90.0, 82.0, 86.0, 70.0]; // Quality, Attendance, Punctuality, Teamwork, Stability
    final labels = ['Quality', 'Attendance', 'Punctuality', 'Teamwork', 'Stability'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 240,
          child: RadarChart(
            RadarChartData(
              radarShape: RadarShape.polygon,
              dataSets: [
                RadarDataSet(
                  fillColor: AppColors.primaryBlue.withValues(alpha: 0.2),
                  borderColor: AppColors.primaryBlue,
                  borderWidth: 2,
                  dataEntries: scores
                      .map((s) => RadarEntry(value: s))
                      .toList(),
                ),
              ],
              radarBorderData: const BorderSide(color: AppColors.divider),
              tickBorderData: const BorderSide(color: AppColors.divider, width: 0.5),
              gridBorderData: const BorderSide(color: AppColors.divider, width: 0.5),
              titlePositionPercentageOffset: 0.2,
              titleTextStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              getTitle: (index, angle) {
                return RadarChartTitle(
                  text: '${labels[index]}\n${scores[index].toInt()}',
                  angle: angle,
                );
              },
              tickCount: 4,
              ticksTextStyle: const TextStyle(
                fontSize: 9,
                color: AppColors.textHint,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreGrid(BuildContext context) {
    final items = [
      _ScoreItem('Quality', 96, AppColors.success),
      _ScoreItem('Stability', 70, AppColors.warning),
      _ScoreItem('Punctuality', 82, AppColors.primaryBlue),
      _ScoreItem('Attendance', 90, AppColors.success),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.0,
      children: items.map((item) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.score}/100',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: item.color,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
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
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
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

class _ScoreItem {
  final String label;
  final int score;
  final Color color;

  const _ScoreItem(this.label, this.score, this.color);
}
