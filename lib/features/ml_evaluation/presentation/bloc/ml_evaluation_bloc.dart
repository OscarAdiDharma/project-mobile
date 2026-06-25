import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentintel_ai/features/ml_evaluation/domain/entities/evaluation_result.dart';
import 'package:talentintel_ai/features/ml_evaluation/domain/repositories/ml_repository.dart';

// ═══════════════════════════════════════════════════════════════
// Events
// ═══════════════════════════════════════════════════════════════

abstract class MlEvaluationEvent extends Equatable {
  const MlEvaluationEvent();

  @override
  List<Object?> get props => [];
}

class CheckDatasetInfoRequested extends MlEvaluationEvent {}
class PreprocessingRequested extends MlEvaluationEvent {}
class ModelTrainingRequested extends MlEvaluationEvent {}
class ModelEvaluationRequested extends MlEvaluationEvent {}

// ═══════════════════════════════════════════════════════════════
// State
// ═══════════════════════════════════════════════════════════════

class MlEvaluationState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? datasetInfo;
  final Map<String, dynamic>? preprocessingInfo;
  final Map<String, dynamic>? trainingInfo;
  final EvaluationResult? evaluationResult;
  final String? error;

  const MlEvaluationState({
    this.isLoading = false,
    this.datasetInfo,
    this.preprocessingInfo,
    this.trainingInfo,
    this.evaluationResult,
    this.error,
  });

  MlEvaluationState copyWith({
    bool? isLoading,
    Map<String, dynamic>? datasetInfo,
    Map<String, dynamic>? preprocessingInfo,
    Map<String, dynamic>? trainingInfo,
    EvaluationResult? evaluationResult,
    String? error,
  }) {
    return MlEvaluationState(
      isLoading: isLoading ?? this.isLoading,
      datasetInfo: datasetInfo ?? this.datasetInfo,
      preprocessingInfo: preprocessingInfo ?? this.preprocessingInfo,
      trainingInfo: trainingInfo ?? this.trainingInfo,
      evaluationResult: evaluationResult ?? this.evaluationResult,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        datasetInfo,
        preprocessingInfo,
        trainingInfo,
        evaluationResult,
        error,
      ];
}

// ═══════════════════════════════════════════════════════════════
// BLoC
// ═══════════════════════════════════════════════════════════════

class MlEvaluationBloc extends Bloc<MlEvaluationEvent, MlEvaluationState> {
  final MlRepository _repository;

  MlEvaluationBloc({required MlRepository repository})
      : _repository = repository,
        super(const MlEvaluationState()) {
    on<CheckDatasetInfoRequested>(_onCheckDataset);
    on<PreprocessingRequested>(_onPreprocess);
    on<ModelTrainingRequested>(_onTrain);
    on<ModelEvaluationRequested>(_onEvaluate);
  }

  Future<void> _onCheckDataset(
      CheckDatasetInfoRequested event, Emitter<MlEvaluationState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final info = await _repository.checkDatasetInfo();
      emit(state.copyWith(isLoading: false, datasetInfo: info));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onPreprocess(
      PreprocessingRequested event, Emitter<MlEvaluationState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final info = await _repository.runPreprocessing();
      emit(state.copyWith(isLoading: false, preprocessingInfo: info));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onTrain(
      ModelTrainingRequested event, Emitter<MlEvaluationState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final info = await _repository.trainModel();
      emit(state.copyWith(isLoading: false, trainingInfo: info));
      
      // Auto trigger evaluation after training
      add(ModelEvaluationRequested());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onEvaluate(
      ModelEvaluationRequested event, Emitter<MlEvaluationState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final result = await _repository.evaluateModel();
      emit(state.copyWith(isLoading: false, evaluationResult: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
