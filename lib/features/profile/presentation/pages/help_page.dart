import 'package:flutter/material.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';

/// Help & Support page.
///
/// FAQ accordion + Contact support section.
class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  static const _faqItems = [
    _FaqItem(
      'How do I check my KPI score?',
      'Go to the Home tab in your Employee Dashboard. Your current KPI score '
          'is displayed at the top of the Performance Hub page along with your '
          'exemplary employee probability percentage.',
    ),
    _FaqItem(
      'What does the NCF AI prediction mean?',
      'NCF (Neural Collaborative Filtering) uses AI to analyze your performance '
          'patterns and predict your likelihood of achieving Exemplary Employee '
          'status. The model considers your KPI scores, attendance, task completion '
          'rate, and historical data.',
    ),
    _FaqItem(
      'How often is the data updated?',
      'Performance data is updated in real-time as your manager inputs KPI data. '
          'AI predictions are recalculated every 24 hours using the latest available '
          'data from all departments.',
    ),
    _FaqItem(
      'Can I download my performance report?',
      'Yes! Navigate to the Recommendations tab to see your detailed analysis. '
          'You can download a PDF report using the "Download PDF Report" button '
          'at the bottom of your individual analysis page.',
    ),
    _FaqItem(
      'How do I change my password?',
      'Go to Profile → Security → Change Password. Enter your current password, '
          'then enter and confirm your new password. Your password must be at least '
          '6 characters long.',
    ),
    _FaqItem(
      'Who can see my performance data?',
      'Your individual performance data is visible to you and authorized HRD '
          'personnel. Department-level aggregated data may be visible in the '
          'HRD dashboard, but individual details are only accessible to users '
          'with appropriate permissions.',
    ),
  ];

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.helpCenter),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.support_agent_rounded,
                    color: AppColors.white, size: 48),
                const SizedBox(height: 12),
                Text(
                  'How can we help you?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find answers to common questions below',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── FAQ ──
          _sectionLabel(AppStrings.faq),
          const SizedBox(height: 12),
          ...List.generate(_faqItems.length, (index) {
            final item = _faqItems[index];
            final isExpanded = _expandedIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isExpanded
                        ? AppColors.primaryBlue
                        : AppColors.divider,
                    width: isExpanded ? 1.5 : 0.5,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _expandedIndex = isExpanded ? null : index;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.question,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isExpanded
                                          ? AppColors.primaryBlue
                                          : AppColors.textPrimary,
                                    ),
                              ),
                            ),
                            AnimatedRotation(
                              turns: isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.expand_more_rounded,
                                color: isExpanded
                                    ? AppColors.primaryBlue
                                    : AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              item.answer,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(height: 1.5),
                            ),
                          ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 200),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 24),

          // ── Contact Support ──
          _sectionLabel(AppStrings.contactSupport),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.email_outlined,
                        color: AppColors.primaryBlue, size: 20),
                  ),
                  title: const Text('Email Support'),
                  subtitle: const Text(AppStrings.supportEmail),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textSecondary),
                  onTap: () => _showComingSoon(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.phone_outlined,
                        color: AppColors.success, size: 20),
                  ),
                  title: const Text('Phone Support'),
                  subtitle: const Text(AppStrings.supportPhone),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textSecondary),
                  onTap: () => _showComingSoon(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chat_bubble_outline_rounded,
                        color: AppColors.warning, size: 20),
                  ),
                  title: const Text('Live Chat'),
                  subtitle: const Text('Available Mon-Fri, 9am-5pm'),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textSecondary),
                  onTap: () => _showComingSoon(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact method coming soon!'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem(this.question, this.answer);
}
