import 'package:talentintel_ai/features/ml_evaluation/domain/entities/evaluation_result.dart';

abstract class MlRepository {
  Future<Map<String, dynamic>> checkDatasetInfo();
  Future<Map<String, dynamic>> runPreprocessing();
  Future<Map<String, dynamic>> trainModel();
  Future<EvaluationResult> evaluateModel();
  Future<PredictionResult> predict(Map<String, dynamic> data);
}
