import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentintel_ai/features/hrd_dashboard/domain/entities/dashboard_entities.dart';
import 'package:talentintel_ai/features/hrd_dashboard/domain/repositories/dashboard_repository.dart';

// ═══════════════════════════════════════════════════════════════
// Events
// ═══════════════════════════════════════════════════════════════

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the dashboard page is first loaded.
class DashboardLoadRequested extends DashboardEvent {
  const DashboardLoadRequested();
}

// ═══════════════════════════════════════════════════════════════
// State
// ═══════════════════════════════════════════════════════════════

class DashboardState extends Equatable {
  final bool isLoading;
  final DashboardStats? stats;
  final List<EmployeeCandidate> topCandidates;
  final List<DepartmentPerformance> departments;
  final String? error;

  const DashboardState({
    this.isLoading = false,
    this.stats,
    this.topCandidates = const [],
    this.departments = const [],
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    DashboardStats? stats,
    List<EmployeeCandidate>? topCandidates,
    List<DepartmentPerformance>? departments,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      stats: stats ?? this.stats,
      topCandidates: topCandidates ?? this.topCandidates,
      departments: departments ?? this.departments,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, stats, topCandidates, departments, error];
}

// ═══════════════════════════════════════════════════════════════
// BLoC
// ═══════════════════════════════════════════════════════════════

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc({required DashboardRepository repository})
      : _repository = repository,
        super(const DashboardState()) {
    on<DashboardLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      // Fetch all data concurrently for faster loading.
      final results = await Future.wait([
        _repository.getStats(),
        _repository.getTopCandidates(),
        _repository.getDepartmentPerformance(),
      ]);

      emit(state.copyWith(
        isLoading: false,
        stats: results[0] as DashboardStats,
        topCandidates: results[1] as List<EmployeeCandidate>,
        departments: results[2] as List<DepartmentPerformance>,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
