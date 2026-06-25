import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class MlRemoteDataSource {
  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api';
    }
    return 'http://127.0.0.1:5000/api';
  }
  final http.Client client;

  MlRemoteDataSource({required this.client});

  Future<Map<String, dynamic>> checkDatasetInfo() async {
    final response = await client.get(Uri.parse('$baseUrl/dataset/info'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load dataset info');
    }
  }

  Future<Map<String, dynamic>> runPreprocessing() async {
    final response = await client.post(Uri.parse('$baseUrl/preprocessing/run'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to run preprocessing');
    }
  }

  Future<Map<String, dynamic>> trainModel() async {
    final response = await client.post(Uri.parse('$baseUrl/model/train'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to train model');
    }
  }

  Future<Map<String, dynamic>> evaluateModel() async {
    final response = await client.get(Uri.parse('$baseUrl/evaluate'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to evaluate model');
    }
  }

  Future<Map<String, dynamic>> predict(Map<String, dynamic> data) async {
    final response = await client.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to predict');
    }
  }
}
