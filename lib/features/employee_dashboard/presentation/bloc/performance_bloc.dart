import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentintel_ai/features/employee_dashboard/domain/entities/performance_entities.dart';
import 'package:talentintel_ai/features/employee_dashboard/domain/repositories/performance_repository.dart';

// ═══════════════════════════════════════════════════════════════
// Events
// ═══════════════════════════════════════════════════════════════

abstract class PerformanceEvent extends Equatable {
  const PerformanceEvent();

  @override
  List<Object?> get props => [];
}

class PerformanceLoadRequested extends PerformanceEvent {
  const PerformanceLoadRequested();
}

// ═══════════════════════════════════════════════════════════════
// State
// ═══════════════════════════════════════════════════════════════

class PerformanceState extends Equatable {
  final bool isLoading;
  final EmployeePerformance? performance;
  final List<TrendPoint> trend;
  final String? error;

  const PerformanceState({
    this.isLoading = false,
    this.performance,
    this.trend = const [],
    this.error,
  });

  PerformanceState copyWith({
    bool? isLoading,
    EmployeePerformance? performance,
    List<TrendPoint>? trend,
    String? error,
  }) {
    return PerformanceState(
      isLoading: isLoading ?? this.isLoading,
      performance: performance ?? this.performance,
      trend: trend ?? this.trend,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, performance, trend, error];
}

// ═══════════════════════════════════════════════════════════════
// BLoC
// ═══════════════════════════════════════════════════════════════

class PerformanceBloc extends Bloc<PerformanceEvent, PerformanceState> {
  final PerformanceRepository _repository;

  PerformanceBloc({required PerformanceRepository repository})
      : _repository = repository,
        super(const PerformanceState()) {
    on<PerformanceLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    PerformanceLoadRequested event,
    Emitter<PerformanceState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final results = await Future.wait([
        _repository.getMyPerformance(),
        _repository.getPerformanceTrend(),
      ]);
      emit(state.copyWith(
        isLoading: false,
        performance: results[0] as EmployeePerformance,
        trend: results[1] as List<TrendPoint>,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
