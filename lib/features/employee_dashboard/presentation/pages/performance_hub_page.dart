import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/features/employee_dashboard/presentation/bloc/performance_bloc.dart';

/// Employee's personal performance hub.
///
/// Layout:
/// 1. Large circular gauge — exemplary probability
/// 2. Target / status row
/// 3. Performance trend line chart
/// 4. Attendance & tasks completed cards
class PerformanceHubPage extends StatelessWidget {
  const PerformanceHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerformanceBloc, PerformanceState>(
      builder: (context, state) {
        if (state.isLoading && state.performance == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final perf = state.performance;
        if (perf == null) return const SizedBox();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Header ────────────────────────────────
            Text(
              AppStrings.myPerformance,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            // ── Circular Gauge ────────────────────────
            Center(
              child: CircularPercentIndicator(
                radius: 100,
                lineWidth: 14,
                percent: perf.exemplaryProbability / 100,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${perf.exemplaryProbability.toInt()}%',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      AppStrings.exemplaryChance,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                progressColor: AppColors.primaryBlue,
                backgroundColor: AppColors.lightBlue,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                animationDuration: 1200,
              ),
            ),
            const SizedBox(height: 24),

            // ── Target & Status ───────────────────────
            Row(
              children: [
                Expanded(
                  child: _infoChip(
                    context,
                    '${AppStrings.currentTarget}: ${perf.targetThisMonth.toInt()}%',
                    AppColors.lightBlue,
                    AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoChip(
                    context,
                    '${AppStrings.currentStatus}: ${perf.statusLabel}',
                    AppColors.successLight,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Trend Chart ───────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.performanceTrend,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Last 6 Months',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 180,
                      child: _buildTrendChart(state.trend),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Bottom Stats ──────────────────────────
            Row(
              children: [
                Expanded(
                  child: _bottomStatCard(
                    context,
                    Icons.calendar_today_rounded,
                    AppStrings.attendance,
                    '${perf.attendancePercent.toInt()}%',
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _bottomStatCard(
                    context,
                    Icons.task_alt_rounded,
                    AppStrings.tasksCompleted,
                    '${perf.tasksCompleted}/${perf.totalTasks}',
                    AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _infoChip(
    BuildContext context,
    String text,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTrendChart(List trend) {
    if (trend.isEmpty) return const SizedBox();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.divider,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < trend.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      trend[index].month,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
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
        borderData: FlBorderData(show: false),
        minY: 50,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: trend
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.score))
                .toList(),
            isCurved: true,
            color: AppColors.primaryBlue,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.white,
                  strokeWidth: 2,
                  strokeColor: AppColors.primaryBlue,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)}%',
                  const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _bottomStatCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
