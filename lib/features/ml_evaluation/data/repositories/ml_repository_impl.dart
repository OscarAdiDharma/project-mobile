import 'package:talentintel_ai/features/ml_evaluation/data/datasources/ml_remote_datasource.dart';
import 'package:talentintel_ai/features/ml_evaluation/domain/entities/evaluation_result.dart';
import 'package:talentintel_ai/features/ml_evaluation/domain/repositories/ml_repository.dart';

class MlRepositoryImpl implements MlRepository {
  final MlRemoteDataSource remoteDataSource;

  MlRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> checkDatasetInfo() async {
    return await remoteDataSource.checkDatasetInfo();
  }

  @override
  Future<Map<String, dynamic>> runPreprocessing() async {
    return await remoteDataSource.runPreprocessing();
  }

  @override
  Future<Map<String, dynamic>> trainModel() async {
    return await remoteDataSource.trainModel();
  }

  @override
  Future<EvaluationResult> evaluateModel() async {
    final result = await remoteDataSource.evaluateModel();
    return EvaluationResult(
      classification: result['classification'] as Map<String, dynamic>,
      regression: result['regression'] as Map<String, dynamic>,
    );
  }

  @override
  Future<PredictionResult> predict(Map<String, dynamic> data) async {
    final result = await remoteDataSource.predict(data);
    final prediction = result['prediction'] as Map<String, dynamic>;
    
    // Convert dynamic values to double
    final Map<String, double> probabilities = {};
    (prediction['probabilities'] as Map<String, dynamic>).forEach((key, value) {
      probabilities[key] = (value as num).toDouble();
    });

    return PredictionResult(
      performanceRating: prediction['performance_rating'] as String,
      overallScore: (prediction['overall_score'] as num).toDouble(),
      probabilities: probabilities,
    );
  }
}
