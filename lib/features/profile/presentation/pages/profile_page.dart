import 'package:flutter/material.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/core/widgets/section_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talentintel_ai/features/profile/presentation/pages/security_page.dart';
import 'package:talentintel_ai/features/profile/presentation/pages/help_page.dart';
import 'package:talentintel_ai/features/profile/presentation/pages/edit_profile_page.dart';

/// Employee profile & trophy room page.
///
/// Shows profile header, trophy grid, and menu items.
class ProfilePage extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) return const SizedBox();
        final user = authState.user;
        
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Profile Header ─────────────────────────────
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.lightBlue,
                    child: Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.employeeId,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.department,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

        // ── Trophy Room ────────────────────────────────
        SectionHeader(
          title: AppStrings.trophyRoom,
          actionLabel: AppStrings.viewAll,
          onAction: () {},
        ),
        const SizedBox(height: 12),
        _buildTrophyGrid(context),
        const SizedBox(height: 28),

        // ── Menu Items ─────────────────────────────────
        _menuItem(
          context,
          Icons.person_outline,
          AppStrings.editProfile,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EditProfilePage()),
          ),
        ),
        _menuItem(
          context,
          Icons.shield_outlined,
          AppStrings.security,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SecurityPage()),
          ),
        ),
        _menuItem(
          context,
          Icons.help_outline_rounded,
          AppStrings.help,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HelpPage()),
          ),
        ),
        const SizedBox(height: 16),

        // ── Logout ─────────────────────────────────────
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onLogout,
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
      },
    );
  }

  Widget _buildTrophyGrid(BuildContext context) {
    final trophies = [
      _TrophyData('Exemplary Employee', 'Jan 2024', Icons.emoji_events_rounded,
          true),
      _TrophyData('Exemplary Employee', 'Mar 2024', Icons.emoji_events_rounded,
          true),
      _TrophyData(
          'Young Innovator', 'Coming Soon', Icons.lightbulb_rounded, false),
      _TrophyData(
          'High Achiever', 'Locked', Icons.workspace_premium_rounded, false),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: trophies.length,
      itemBuilder: (context, index) {
        final trophy = trophies[index];
        return Card(
          color: trophy.isUnlocked
              ? AppColors.lightBlue
              : AppColors.background,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  trophy.icon,
                  size: 32,
                  color: trophy.isUnlocked
                      ? AppColors.warning
                      : AppColors.textHint,
                ),
                const SizedBox(height: 8),
                Text(
                  trophy.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: trophy.isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  trophy.subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: trophy.isUnlocked
                        ? AppColors.textSecondary
                        : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label,
      {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textPrimary),
        title: Text(label, style: Theme.of(context).textTheme.titleMedium),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textSecondary,
        ),
        onTap: onTap ?? () {},
      ),
    );
  }
}

class _TrophyData {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isUnlocked;

  const _TrophyData(this.title, this.subtitle, this.icon, this.isUnlocked);
}
