import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';

/// Employee Performance History page.
///
/// Shows monthly performance scores in a chart and a list view.
class PerformanceHistoryPage extends StatelessWidget {
  const PerformanceHistoryPage({super.key});

  static const _historyData = [
    _MonthData('Jan', 78, 'Good'),
    _MonthData('Feb', 82, 'Good'),
    _MonthData('Mar', 75, 'Average'),
    _MonthData('Apr', 88, 'Excellent'),
    _MonthData('May', 91, 'Excellent'),
    _MonthData('Jun', 85, 'Good'),
    _MonthData('Jul', 79, 'Good'),
    _MonthData('Aug', 92, 'Excellent'),
    _MonthData('Sep', 87, 'Good'),
    _MonthData('Oct', 94, 'Excellent'),
    _MonthData('Nov', 89, 'Excellent'),
    _MonthData('Dec', 93, 'Excellent'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Header ──
        Text(
          AppStrings.performanceHistory,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.performanceHistorySubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),

        // ── Overall Stats Row ──
        Row(
          children: [
            Expanded(child: _statCard('Average Score', '86.1', Icons.trending_up_rounded, AppColors.success)),
            const SizedBox(width: 12),
            Expanded(child: _statCard('Best Month', 'Oct', Icons.emoji_events_rounded, AppColors.warning)),
            const SizedBox(width: 12),
            Expanded(child: _statCard('Trend', '↑ 12%', Icons.show_chart_rounded, AppColors.primaryBlue)),
          ],
        ),
        const SizedBox(height: 24),

        // ── Performance Trend Chart ──
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.overallTrend,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '2024 Monthly Performance Scores',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 10,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: AppColors.divider,
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            interval: 10,
                            getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textHint,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= _historyData.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  _historyData[idx].month,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      minY: 60,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: _historyData
                              .asMap()
                              .entries
                              .map((e) => FlSpot(
                                  e.key.toDouble(), e.value.score.toDouble()))
                              .toList(),
                          isCurved: true,
                          gradient: AppColors.primaryGradient,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, bar, index) =>
                                FlDotCirclePainter(
                              radius: 3,
                              color: AppColors.white,
                              strokeWidth: 2,
                              strokeColor: AppColors.primaryBlue,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryBlue.withValues(alpha: 0.15),
                                AppColors.primaryBlue.withValues(alpha: 0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ── Monthly List ──
        Text(
          AppStrings.monthlyScore.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(_historyData.length, (index) {
          final data = _historyData[_historyData.length - 1 - index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _scoreColor(data.score).withValues(alpha: 0.1),
                  child: Text(
                    data.score.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _scoreColor(data.score),
                    ),
                  ),
                ),
                title: Text(
                  '${data.month} 2024',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(data.rating),
                trailing: Icon(
                  data.score >= 85
                      ? Icons.trending_up_rounded
                      : data.score >= 75
                          ? Icons.trending_flat_rounded
                          : Icons.trending_down_rounded,
                  color: _scoreColor(data.score),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  Color _scoreColor(int score) {
    if (score >= 85) return AppColors.success;
    if (score >= 75) return AppColors.warning;
    return AppColors.error;
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthData {
  final String month;
  final int score;
  final String rating;

  const _MonthData(this.month, this.score, this.rating);
}
