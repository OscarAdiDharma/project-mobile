import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';

/// HRD Settings page.
///
/// Sections: Appearance, Notifications, About, Logout.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? true;
    });
  }

  Future<void> _savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Title ──
        Text(
          AppStrings.settingsTitle,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'Customize your app experience',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),

        // ── Notifications ──
        _sectionLabel(AppStrings.notifications),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.notifications_active_rounded,
                      color: AppColors.success, size: 20),
                ),
                title: const Text(AppStrings.pushNotifications),
                subtitle: const Text(AppStrings.pushNotificationsDesc),
                value: _pushNotifications,
                activeThumbColor: AppColors.primaryBlue,
                onChanged: (val) {
                  setState(() => _pushNotifications = val);
                  _savePreference('push_notifications', val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Push notifications ${val ? 'enabled' : 'disabled'}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.email_rounded,
                      color: AppColors.warning, size: 20),
                ),
                title: const Text(AppStrings.emailNotifications),
                subtitle: const Text(AppStrings.emailNotificationsDesc),
                value: _emailNotifications,
                activeThumbColor: AppColors.primaryBlue,
                onChanged: (val) {
                  setState(() => _emailNotifications = val);
                  _savePreference('email_notifications', val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Email notifications ${val ? 'enabled' : 'disabled'}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── About ──
        _sectionLabel(AppStrings.aboutApp),
        const SizedBox(height: 8),
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
                  child: const Icon(Icons.info_outline_rounded,
                      color: AppColors.primaryBlue, size: 20),
                ),
                title: const Text(AppStrings.version),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    AppStrings.appVersion,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.description_outlined,
                      color: AppColors.success, size: 20),
                ),
                title: const Text(AppStrings.termsOfService),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary),
                onTap: () => _showTermsOfService(),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.privacy_tip_outlined,
                      color: AppColors.warning, size: 20),
                ),
                title: const Text(AppStrings.privacyPolicy),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary),
                onTap: () => _showPrivacyPolicy(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── Logout ──
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            key: const ValueKey('settings_logout_button'),
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            label: const Text(
              AppStrings.logout,
              style: TextStyle(color: AppColors.error),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
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

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.termsOfService),
        content: const SingleChildScrollView(
          child: Text(
            'TERMS OF SERVICE\n\n'
            'Last Updated: June 2026\n\n'
            '1. ACCEPTANCE OF TERMS\n'
            'By accessing and using the Talent Achive application ("App"), you accept and agree to be bound by these Terms of Service. If you do not agree, do not use the App.\n\n'
            '2. DESCRIPTION OF SERVICE\n'
            'Talent Achive is an AI-powered employee performance prediction and management system designed for Human Resource Department (HRD) administrators and employees. The App uses Neural Collaborative Filtering (NCF) algorithms to analyze and predict employee performance.\n\n'
            '3. USER ACCOUNTS\n'
            'Accounts are created exclusively by authorized HRD administrators. Users are responsible for maintaining the confidentiality of their login credentials. Any unauthorized use of accounts must be reported immediately.\n\n'
            '4. DATA USAGE\n'
            'The App collects and processes employee performance data, KPI scores, attendance records, and related metrics for the purpose of performance analysis and prediction. All data is processed in accordance with our Privacy Policy.\n\n'
            '5. INTELLECTUAL PROPERTY\n'
            'All content, features, and functionality of the App are owned by Talent Achive and are protected by international copyright, trademark, and other intellectual property laws.\n\n'
            '6. USER RESPONSIBILITIES\n'
            '- Provide accurate and up-to-date information\n'
            '- Use the App only for its intended purpose\n'
            '- Not attempt to reverse engineer the AI models\n'
            '- Not share confidential employee data outside the App\n\n'
            '7. LIMITATION OF LIABILITY\n'
            'AI predictions and recommendations are provided as decision-support tools and should not be the sole basis for employment decisions. The App does not guarantee the accuracy of AI predictions.\n\n'
            '8. MODIFICATIONS\n'
            'We reserve the right to modify these Terms at any time. Continued use of the App after changes constitutes acceptance of the modified Terms.\n\n'
            '9. CONTACT\n'
            'For questions about these Terms, contact us at support@talentachive.com.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.privacyPolicy),
        content: const SingleChildScrollView(
          child: Text(
            'PRIVACY POLICY\n\n'
            'Last Updated: June 2026\n\n'
            '1. INFORMATION WE COLLECT\n'
            'We collect the following categories of information:\n'
            '- Account Information: Name, email address, department, and role.\n'
            '- Performance Data: KPI scores, attendance records, task completion rates, and related metrics uploaded by HRD administrators.\n'
            '- Usage Data: App interaction logs, feature usage patterns, and device information.\n\n'
            '2. HOW WE USE YOUR INFORMATION\n'
            'Your information is used to:\n'
            '- Provide AI-powered performance analysis and predictions\n'
            '- Generate personalized development recommendations\n'
            '- Create performance reports and dashboards\n'
            '- Improve the accuracy of our NCF prediction models\n'
            '- Send notifications about performance updates\n\n'
            '3. DATA STORAGE & SECURITY\n'
            'All data is stored securely using Firebase Cloud Firestore with encryption at rest and in transit. We implement industry-standard security measures including:\n'
            '- TLS/SSL encryption for data transmission\n'
            '- Firebase Authentication for access control\n'
            '- Role-based access control (HRD vs Employee)\n'
            '- Regular security audits\n\n'
            '4. DATA SHARING\n'
            'We do not sell, trade, or transfer your personal information to third parties. Data may be shared only:\n'
            '- Within your organization (HRD to Employee relationship)\n'
            '- When required by law or legal process\n'
            '- To protect the rights and safety of users\n\n'
            '5. DATA RETENTION\n'
            'Performance data is retained for the duration of employment plus 2 years. Account data is deleted upon request by the HRD administrator.\n\n'
            '6. YOUR RIGHTS\n'
            'You have the right to:\n'
            '- Access your personal data\n'
            '- Request correction of inaccurate data\n'
            '- Request deletion of your data (via HRD)\n'
            '- Opt out of non-essential notifications\n\n'
            '7. COOKIES & TRACKING\n'
            'The App uses Firebase Analytics for usage tracking. You can disable analytics through the App settings.\n\n'
            '8. CHANGES TO THIS POLICY\n'
            'We may update this Privacy Policy from time to time. We will notify you of any changes through the App.\n\n'
            '9. CONTACT US\n'
            'For privacy-related inquiries, contact our Data Protection Officer at privacy@talentachive.com.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// InheritedWidget to propagate ThemeMode changes across the app.
class ThemeModeNotifier extends InheritedNotifier<ValueNotifier<ThemeMode>> {
  const ThemeModeNotifier({
    super.key,
    required ValueNotifier<ThemeMode> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ThemeModeNotifier? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeModeNotifier>();
  }

  static ThemeModeNotifier? read(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<ThemeModeNotifier>();
    return element?.widget as ThemeModeNotifier?;
  }

  void setThemeMode(ThemeMode mode) {
    notifier!.value = mode;
  }
}
