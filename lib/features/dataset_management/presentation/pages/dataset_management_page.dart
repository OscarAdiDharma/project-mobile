import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/core/widgets/section_header.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talentintel_ai/core/widgets/status_badge.dart';

/// HRD Dataset Management page.
///
/// Shows:
/// 1. Upload area with drag-drop style
/// 2. Active AI Pipeline status
/// 3. Dataset history table
class DatasetManagementPage extends StatefulWidget {
  const DatasetManagementPage({super.key});

  @override
  State<DatasetManagementPage> createState() => _DatasetManagementPageState();
}

class _DatasetManagementPageState extends State<DatasetManagementPage> {
  // Simulated pipeline state
  int _pipelineStep = 0; // 0 = not started, 1-4 = steps
  bool _autoValidation = true;
  bool _dataEncryption = true;
  String? _pickedFileName;
  String? _pickedFileSize;
  String? _pickedFilePath;

  Future<void> _startProcessing() async {
    if (_pickedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a file first')),
      );
      return;
    }
    
    setState(() => _pipelineStep = 1);
    
    try {
      // 1. Upload Dataset
      setState(() => _pipelineStep = 2);
      
      String baseUrl = Platform.isAndroid ? 'http://127.0.0.1:5000/api' : 'http://127.0.0.1:5000/api';
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/dataset/upload'));
      request.files.add(await http.MultipartFile.fromPath('file', _pickedFilePath!));
      
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      
      if (response.statusCode != 200) {
        String errMsg = 'Unknown Error';
        try {
          var errJson = jsonDecode(responseData);
          errMsg = errJson['error'] ?? 'Unknown error';
        } catch (_) {
          errMsg = responseData;
        }
        throw Exception('Backend Error (400): $errMsg');
      }
      
      // 2. Running AI Model
      setState(() => _pipelineStep = 3);
      var jsonResponse = jsonDecode(responseData);
      
      if (jsonResponse['status'] != 'success') {
        throw Exception(jsonResponse['error'] ?? 'Unknown error');
      }
      
      List<dynamic> predictions = jsonResponse['data'];
      
      // 3. Save to Firestore
      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();
      
      for (var pred in predictions) {
        final docRef = firestore.collection('employees').doc(pred['employee_id']);
        
        Map<String, dynamic> dataToMerge = {
          'employee_id': pred['employee_id'],
          'performance_rating': pred['performance_rating'],
          'overall_score': pred['overall_score'],
          'status': pred['status'],
          'probabilities': pred['probabilities'],
          'updated_at': FieldValue.serverTimestamp(),
        };

        if (pred['name'] != null) dataToMerge['name'] = pred['name'];
        if (pred['department'] != null) dataToMerge['department'] = pred['department'];
        if (pred['position'] != null) dataToMerge['position'] = pred['position'];

        batch.set(docRef, dataToMerge, SetOptions(merge: true));
      }
      
      await batch.commit();
      
      // Save to SharedPreferences history
      final prefs = await SharedPreferences.getInstance();
      final String? historyStr = prefs.getString('dataset_history');
      List<dynamic> historyList = [];
      if (historyStr != null) {
        try {
          historyList = jsonDecode(historyStr);
        } catch (_) {}
      }
      
      final now = DateTime.now();
      final dateStr = '${now.day} ${_getMonth(now.month)} ${now.year}';
      
      historyList.insert(0, {
        'name': _pickedFileName ?? 'Unknown_Dataset',
        'date': dateStr,
        'status': 'Success',
        'rows': predictions.length,
      });
      
      await prefs.setString('dataset_history', jsonEncode(historyList));

      // Complete
      setState(() => _pipelineStep = 4);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data processed and saved to Firestore successfully!'), backgroundColor: AppColors.success),
        );
      }
      
    } catch (e) {
      setState(() => _pipelineStep = 0);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _pickedFileName = file.name;
          _pickedFileSize = _formatFileSize(file.size);
          _pickedFilePath = file.path;
          _pipelineStep = 0; // Reset pipeline for new file
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File selected: ${file.name}'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes >= 1048576) {
      return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Header ──────────────────────────────────
        Text(
          AppStrings.datasetManagement,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.datasetSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),

        // ── Upload Area ─────────────────────────────
        _buildUploadArea(context),
        const SizedBox(height: 16),

        // ── Options ─────────────────────────────────
        Row(
          children: [
            _buildCheckOption(
              AppStrings.autoValidation,
              _autoValidation,
              (val) => setState(() => _autoValidation = val ?? true),
            ),
            const SizedBox(width: 24),
            _buildCheckOption(
              AppStrings.dataEncryption,
              _dataEncryption,
              (val) => setState(() => _dataEncryption = val ?? true),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── AI Pipeline ─────────────────────────────
        _buildPipelineCard(context),
        const SizedBox(height: 24),

        // ── Dataset History ─────────────────────────
        SectionHeader(
          title: AppStrings.datasetHistory,
          actionLabel: 'Export Log',
          onAction: () {},
        ),
        const SizedBox(height: 4),
        Text(
          'Uploads from the last 30 days',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        _buildDatasetList(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildUploadArea(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _pickFile,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: _pickedFileName != null
                  ? AppColors.success.withValues(alpha: 0.5)
                  : AppColors.primaryBlue.withValues(alpha: 0.3),
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                _pickedFileName != null
                    ? Icons.check_circle_rounded
                    : Icons.cloud_upload_outlined,
                size: 48,
                color: _pickedFileName != null
                    ? AppColors.success
                    : AppColors.primaryBlue.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 12),
              Text(
                _pickedFileName != null
                    ? _pickedFileName!
                    : AppStrings.dragDropHint,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _pickedFileName != null
                          ? AppColors.success
                          : null,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                _pickedFileName != null
                    ? 'File size: $_pickedFileSize'
                    : AppStrings.fileFormatHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.folder_open_rounded, size: 18),
                label: Text(
                  _pickedFileName != null
                      ? 'Change File'
                      : AppStrings.pickFile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckOption(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: Checkbox(value: value, onChanged: onChanged),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildPipelineCard(BuildContext context) {
    final steps = [
      'Upload Dataset',
      'Cleaning & Preprocessing',
      'Running AI Model',
      'Complete',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.activePipeline,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final stepLabel = entry.value;
              final isCompleted = _pipelineStep > index + 1;
              final isActive = _pipelineStep == index + 1;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    // Step indicator circle
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? AppColors.success
                            : isActive
                                ? AppColors.primaryBlue
                                : AppColors.divider,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check, size: 16, color: AppColors.white)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isActive
                                      ? AppColors.white
                                      : AppColors.textHint,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        stepLabel,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                          color: isActive || isCompleted
                              ? AppColors.textPrimary
                              : AppColors.textHint,
                        ),
                      ),
                    ),
                    if (isActive)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    if (isCompleted)
                      const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pipelineStep == 0 ? _startProcessing : null,
                child: Text(
                  _pipelineStep == 0
                      ? AppStrings.startProcessing
                      : _pipelineStep == 4
                          ? 'Processing Complete'
                          : 'Processing...',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatasetList() {
    return FutureBuilder<List<_DatasetRow>>(
      future: _loadDatasetHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final datasets = snapshot.data!;

        if (datasets.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'No dataset history yet. Run the AI pipeline to see results here.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textHint,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Column(
          children: datasets.map((ds) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(
                  ds.name.endsWith('.csv')
                      ? Icons.description_rounded
                      : Icons.table_chart_rounded,
                  color: AppColors.primaryBlue,
                ),
                title: Text(
                  ds.name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  ds.date,
                  style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (ds.rows > 0)
                      Text(
                        '${_formatNumber(ds.rows)} rows',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    const SizedBox(width: 8),
                    StatusBadge(
                      label: ds.status,
                      type: ds.status == 'Success'
                          ? StatusType.success
                          : ds.status == 'Warning'
                              ? StatusType.warning
                              : StatusType.error,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<List<_DatasetRow>> _loadDatasetHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString('dataset_history');
    if (historyJson == null) return [];

    try {
      final List<dynamic> list = jsonDecode(historyJson);
      return list.map((e) => _DatasetRow(
            e['name'] as String,
            e['date'] as String,
            e['status'] as String,
            e['rows'] as int,
          )).toList();
    } catch (_) {
      return [];
    }
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}

class _DatasetRow {
  final String name;
  final String date;
  final String status;
  final int rows;

  const _DatasetRow(this.name, this.date, this.status, this.rows);
}
