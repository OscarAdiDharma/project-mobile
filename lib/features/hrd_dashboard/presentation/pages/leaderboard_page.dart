import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/widgets/status_badge.dart';
import 'package:talentintel_ai/features/hrd_dashboard/presentation/bloc/dashboard_bloc.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.isLoading && state.topCandidates.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final candidates = state.topCandidates;

        if (candidates.isEmpty) {
          return const Center(child: Text('No employees found.'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<DashboardBloc>().add(const DashboardLoadRequested());
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: candidates.length,
            itemBuilder: (context, index) {
              final candidate = candidates[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  title: Text(
                    candidate.name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: Text(
                    candidate.position,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${candidate.score}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(
                        label: candidate.status,
                        type: candidate.score >= 95
                            ? StatusType.success
                            : StatusType.info,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Employee'),
                              content: Text('Are you sure you want to delete ${candidate.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<DashboardBloc>().add(DashboardDeleteEmployeeRequested(candidate.id));
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('Delete', style: TextStyle(color: AppColors.error)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    context.go('/employee-detail/${candidate.id}');
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
