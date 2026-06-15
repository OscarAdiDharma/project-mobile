import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talentintel_ai/features/employee_dashboard/presentation/bloc/performance_bloc.dart';
import 'package:talentintel_ai/features/employee_dashboard/presentation/pages/performance_hub_page.dart';
import 'package:talentintel_ai/features/ncf_insights/presentation/pages/ncf_insights_page.dart';
import 'package:talentintel_ai/features/profile/presentation/pages/profile_page.dart';
import 'package:talentintel_ai/injection.dart';

/// Shell page for the Employee portal.
///
/// Bottom nav: Home (Performance Hub), Recommendations (NCF Insights),
/// History (placeholder), Profile.
class EmployeeShellPage extends StatefulWidget {
  const EmployeeShellPage({super.key});

  @override
  State<EmployeeShellPage> createState() => _EmployeeShellPageState();
}

class _EmployeeShellPageState extends State<EmployeeShellPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<PerformanceBloc>()..add(const PerformanceLoadRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Performance AI',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_rounded),
              label: AppStrings.recommendations,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: AppStrings.history,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: AppStrings.profile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const PerformanceHubPage();
      case 1:
        return const NcfInsightsPage();
      case 2:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history_rounded,
                  size: 64, color: AppColors.textHint),
              const SizedBox(height: 16),
              Text(
                'Performance History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your historical performance data will appear here.',
                style: TextStyle(color: AppColors.textHint),
              ),
            ],
          ),
        );
      case 3:
        return ProfilePage(
          onLogout: () {
            context.read<AuthBloc>().add(const LogoutRequested());
          },
        );
      default:
        return const PerformanceHubPage();
    }
  }
}
