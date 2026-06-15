import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talentintel_ai/features/hrd_dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:talentintel_ai/features/hrd_dashboard/presentation/pages/hrd_dashboard_page.dart';
import 'package:talentintel_ai/features/dataset_management/presentation/pages/dataset_management_page.dart';
import 'package:talentintel_ai/features/employee_analysis/presentation/pages/employee_detail_page.dart';
import 'package:talentintel_ai/injection.dart';

/// Shell page for the HRD portal.
///
/// Contains a bottom navigation bar with three tabs:
/// Dashboard, Datasets, and Leaderboard.
/// The sidebar from the desktop mockup is adapted to bottom nav for mobile.
class HrdShellPage extends StatefulWidget {
  const HrdShellPage({super.key});

  @override
  State<HrdShellPage> createState() => _HrdShellPageState();
}

class _HrdShellPageState extends State<HrdShellPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()..add(const DashboardLoadRequested()),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    AppStrings.appEdition,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: AppColors.textHint,
                        ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () {
                context.read<AuthBloc>().add(const LogoutRequested());
              },
            ),
          ],
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: AppStrings.dashboard,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storage_rounded),
              label: AppStrings.datasets,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard_rounded),
              label: AppStrings.leaderboard,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: AppStrings.settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const HrdDashboardPage();
      case 1:
        return const DatasetManagementPage();
      case 2:
        return const EmployeeDetailPage();
      case 3:
        return const Center(child: Text('Settings'));
      default:
        return const HrdDashboardPage();
    }
  }
}
