import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

class SurveyService {
  SurveyService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();
  final ApiClient _api;

  Future<List<QuestionModel>> getActiveQuestions() async {
    final token = await _getToken();
    final res = await _api.getJson('/api/surveys/questions/active', headers: _bearer(token));
    final List<dynamic> list = res is Map<String, dynamic> ? (res['data'] as List<dynamic>? ?? []) : (res as List<dynamic>);
    return list.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> submitAnswers(List<AnswerItem> answers) async {
    final payload = {
      'answers': answers.map((e) => {'questionId': e.questionId, 'optionId': e.optionId}).toList()
    };
    final token = await _getToken();
    await _api.postJson('/api/surveys/answers', body: payload, headers: _bearer(token));
  }

  Future<PlanModel> generatePlan() async {
    final token = await _getToken();
    final data = await _api.postJson('/api/surveys/plan/generate', headers: _bearer(token));
    return PlanModel.fromJson(data);
  }

  Map<String, String> _bearer(String? token) => token == null ? {} : {'Authorization': 'Bearer $token'};

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}

class QuestionModel {
  QuestionModel({required this.id, required this.content, required this.options});
  final int id;
  final String content;
  final List<OptionModel> options;

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: (json['id'] as num).toInt(),
        content: json['content'] as String,
        options: (json['options'] as List<dynamic>).map((e) => OptionModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
}

class OptionModel {
  OptionModel({required this.id, required this.label});
  final int id;
  final String label;

  factory OptionModel.fromJson(Map<String, dynamic> json) => OptionModel(
        id: (json['id'] as num).toInt(),
        label: json['label'] as String,
      );
}

class AnswerItem {
  AnswerItem({required this.questionId, required this.optionId});
  final int questionId;
  final int optionId;
}

class PlanModel {
  PlanModel({required this.goal, required this.content});
  final String goal;
  final String content;

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        goal: json['goal'] as String,
        content: json['content'] as String,
      );
}


