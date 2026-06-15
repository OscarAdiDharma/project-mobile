import 'package:flutter/material.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/core/widgets/section_header.dart';

/// Actionable NCF Insights page for employees.
///
/// Shows strengths/weaknesses analysis, AI prediction card,
/// action steps (urgent / maintain), and suggested training.
class NcfInsightsPage extends StatelessWidget {
  const NcfInsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        _buildStrengthBar(context, 'Quality', 0.92, AppColors.success),
        _buildStrengthBar(context, 'Teamwork', 0.86, AppColors.primaryBlue),
        _buildStrengthBar(context, 'Punctuality', 0.64, AppColors.warning),
        _buildStrengthBar(context, 'Attendance', 0.72, AppColors.warning),
        const SizedBox(height: 20),

        // ── AI Prediction Card ─────────────────────────
        _buildAiPredictionCard(context),
        const SizedBox(height: 24),

        // ── Action Steps ───────────────────────────────
        const SectionHeader(title: AppStrings.actionSteps),
        const SizedBox(height: 12),

        // Urgent action
        _buildActionCard(
          context,
          label: AppStrings.urgent,
          labelColor: AppColors.error,
          title: 'Improve project punctuality by 10%',
          description:
              'The model predicts this will raise your Exemplary probability to 85%.',
          buttonLabel: 'Create Plan',
          buttonColor: AppColors.error,
        ),
        const SizedBox(height: 12),

        // Maintain action
        _buildActionCard(
          context,
          label: AppStrings.maintain,
          labelColor: AppColors.success,
          title: 'Keep your Teamwork score outstanding',
          description:
              'Continue to inspire colleagues and strengthen the company\'s collaboration culture.',
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

  Widget _buildAiPredictionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology_rounded, color: AppColors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.aiPrediction,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'One step from having a major impact on your career.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
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
