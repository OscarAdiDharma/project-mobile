import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/widgets/section_header.dart';
import 'package:talentintel_ai/features/ml_evaluation/presentation/bloc/ml_evaluation_bloc.dart';

class MlEvaluationPage extends StatefulWidget {
  const MlEvaluationPage({super.key});

  @override
  State<MlEvaluationPage> createState() => _MlEvaluationPageState();
}

class _MlEvaluationPageState extends State<MlEvaluationPage> {
  @override
  void initState() {
    super.initState();
    context.read<MlEvaluationBloc>().add(CheckDatasetInfoRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MlEvaluationBloc, MlEvaluationState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
          );
        }
      },
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'AI Model Evaluation',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Pipeline & Model Performance Metrics',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            _buildControls(context, state),
            const SizedBox(height: 24),

            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              if (state.evaluationResult != null) ...[
                _buildConfusionMatrix(context, state.evaluationResult!.classification['confusion_matrix']),
                const SizedBox(height: 24),
                _buildClassificationMetrics(context, state.evaluationResult!.classification),
                const SizedBox(height: 24),
                _buildRegressionMetrics(context, state.evaluationResult!.regression),
              ] else if (state.datasetInfo != null) ...[
                _buildDatasetInfo(context, state.datasetInfo!),
              ],
            ]
          ],
        );
      },
    );
  }

  Widget _buildControls(BuildContext context, MlEvaluationState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Pipeline Controls'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: state.isLoading ? null : () => context.read<MlEvaluationBloc>().add(PreprocessingRequested()),
                    child: const Text('1. Run Preprocessing'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: state.preprocessingInfo == null || state.isLoading
                        ? null
                        : () => context.read<MlEvaluationBloc>().add(ModelTrainingRequested()),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
                    child: const Text('2. Train Model'),
                  ),
                ),
              ],
            ),
            if (state.preprocessingInfo != null) ...[
              const SizedBox(height: 12),
              Text(
                'Data split: ${state.preprocessingInfo!['train_size']} Train / ${state.preprocessingInfo!['val_size']} Val / ${state.preprocessingInfo!['test_size']} Test',
                style: const TextStyle(fontSize: 12, color: AppColors.success),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDatasetInfo(BuildContext context, Map<String, dynamic> info) {
    final dist = info['class_distribution'] as Map<String, dynamic>;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Dataset Overview'),
            const SizedBox(height: 12),
            Text('Total Records: ${info['total_records']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Class Distribution:'),
            ...dist.entries.map((e) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Text('• ${e.key}: ${e.value} records'),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildConfusionMatrix(BuildContext context, List<dynamic> cmList) {
    final labels = ['Low', 'Medium', 'High'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Confusion Matrix 3x3'),
            const SizedBox(height: 12),
            Table(
              border: TableBorder.all(color: AppColors.divider),
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: AppColors.lightBlue),
                  children: [
                    const Padding(padding: EdgeInsets.all(8), child: Text('Actual \\ Pred', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ...labels.map((l) => Padding(padding: const EdgeInsets.all(8), child: Text(l, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
                  ],
                ),
                ...List.generate(3, (i) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8), 
                      child: Text(labels[i], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                    ),
                    ...List.generate(3, (j) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${cmList[i][j]}', 
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: i == j ? AppColors.success : AppColors.textPrimary,
                          fontWeight: i == j ? FontWeight.bold : FontWeight.normal,
                        ),
                      )
                    )),
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassificationMetrics(BuildContext context, Map<String, dynamic> metrics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Classification Metrics'),
            const SizedBox(height: 12),
            Text('Overall Accuracy: ${(metrics['accuracy'] * 100).toStringAsFixed(2)}%', 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
            const SizedBox(height: 16),
            const Text('Macro Average:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _metricBox('Precision', metrics['macro_avg']['precision']),
                _metricBox('Recall', metrics['macro_avg']['recall']),
                _metricBox('F1-Score', metrics['macro_avg']['f1_score']),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRegressionMetrics(BuildContext context, Map<String, dynamic> metrics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Regression Performance (Overall Score)'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _metricBox('MSE', metrics['mse'], isPercentage: false),
                _metricBox('RMSE', metrics['rmse'], isPercentage: false),
                _metricBox('MAE', metrics['mae'], isPercentage: false),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _metricBox(String label, double value, {bool isPercentage = true}) {
    final displayValue = isPercentage ? '${(value * 100).toStringAsFixed(1)}%' : value.toStringAsFixed(2);
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(displayValue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
