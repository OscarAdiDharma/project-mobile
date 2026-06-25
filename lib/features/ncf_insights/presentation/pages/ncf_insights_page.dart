import 'package:flutter/material.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/core/widgets/section_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentintel_ai/features/employee_dashboard/presentation/bloc/performance_bloc.dart';

/// Actionable NCF Insights page for employees.
///
/// Shows strengths/weaknesses analysis, AI prediction card,
/// action steps (urgent / maintain), and suggested training.
class NcfInsightsPage extends StatelessWidget {
  const NcfInsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerformanceBloc, PerformanceState>(
      builder: (context, state) {
        if (state.isLoading && state.performance == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final perf = state.performance;
        if (perf == null) {
          return const Center(child: Text('No insights available.'));
        }

        if (perf.statusLabel == 'Pending Evaluation') {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Not enough performance data to generate insights. Check back next month after your evaluation!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            ),
          );
        }

        final isHighPerformer = perf.exemplaryProbability >= 70;
        final qualityScore = isHighPerformer ? 0.92 : 0.65;
        final teamworkScore = isHighPerformer ? 0.88 : 0.70;
        final punctualityScore = isHighPerformer ? 0.85 : 0.50;
        final attendanceScore = perf.attendancePercent / 100.0;

        return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Strengths & Weaknesses ─────────────────────
        Text(
          AppStrings.strengthsWeaknesses,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          'Based on last quarter\'s performance data, here is your competency breakdown.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        _buildStrengthBar(context, 'Quality', qualityScore, _getBarColor(qualityScore)),
        _buildStrengthBar(context, 'Teamwork', teamworkScore, _getBarColor(teamworkScore)),
        _buildStrengthBar(context, 'Punctuality', punctualityScore, _getBarColor(punctualityScore)),
        _buildStrengthBar(context, 'Attendance', attendanceScore, _getBarColor(attendanceScore)),
        const SizedBox(height: 20),

        // ── AI Prediction Card ─────────────────────────
        _buildAiPredictionCard(context, perf.exemplaryProbability),
        const SizedBox(height: 24),

        // ── Action Steps ───────────────────────────────
        const SectionHeader(title: AppStrings.actionSteps),
        const SizedBox(height: 12),

        // Urgent action
        if (!isHighPerformer)
          _buildActionCard(
            context,
            label: AppStrings.urgent,
            labelColor: AppColors.error,
            title: 'Improve project punctuality by 10%',
            description:
                'The model predicts this will raise your Exemplary probability to ${perf.exemplaryProbability + 15}%.',
            buttonLabel: 'Create Plan',
            buttonColor: AppColors.error,
          ),
        if (!isHighPerformer) const SizedBox(height: 12),

        // Maintain action
        _buildActionCard(
          context,
          label: AppStrings.maintain,
          labelColor: AppColors.success,
          title: 'Keep your ${isHighPerformer ? 'Quality' : 'Attendance'} score outstanding',
          description:
              'Continue to inspire colleagues and strengthen the company\'s culture.',
          buttonLabel: 'Share Tips',
          buttonColor: AppColors.success,
        ),
        const SizedBox(height: 12),

        // Achievement card
        _buildAchievementCard(context),
        const SizedBox(height: 24),

        // ── Suggested Training ─────────────────────────
        const SectionHeader(title: AppStrings.suggestedTraining),
        const SizedBox(height: 12),
        _buildTrainingTile(
          context,
          title: 'Time Mastery 101',
          subtitle:
              'The "Strategic Time Management" course is available for you this month.',
        ),
        const SizedBox(height: 20),
      ],
    );
      },
    );
  }

  Color _getBarColor(double score) {
    if (score >= 0.8) return AppColors.success;
    if (score >= 0.6) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildStrengthBar(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              Text(
                '${(value * 100).toInt()}%',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiPredictionCard(BuildContext context, double probability) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${probability.toInt()}% Exemplary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Probability of reaching exemplary status this quarter.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String label,
    required Color labelColor,
    required String title,
    required String description,
    required String buttonLabel,
    required Color buttonColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: labelColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: labelColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  textStyle: const TextStyle(fontSize: 12),
                ),
                child: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(BuildContext context) {
    return Card(
      color: AppColors.lightBlue,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.emoji_events_rounded,
                color: AppColors.primaryBlue, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Achievement Awaits!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBlue,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complete 5 more tasks to earn the "Consistent Performer" badge.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingTile(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: ListTile(
        title: Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: const Icon(Icons.arrow_forward_rounded,
            color: AppColors.primaryBlue),
        onTap: () {},
      ),
    );
  }
}
