import 'package:equatable/equatable.dart';

class EvaluationResult extends Equatable {
  final Map<String, dynamic> classification;
  final Map<String, dynamic> regression;

  const EvaluationResult({
    required this.classification,
    required this.regression,
  });

  @override
  List<Object?> get props => [classification, regression];
}

class PredictionResult extends Equatable {
  final String performanceRating;
  final double overallScore;
  final Map<String, double> probabilities;

  const PredictionResult({
    required this.performanceRating,
    required this.overallScore,
    required this.probabilities,
  });

  @override
  List<Object?> get props => [performanceRating, overallScore, probabilities];
}
