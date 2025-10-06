import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

//các api về survey
class SurveyService {
  SurveyService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();
  final ApiClient _api;

  Future<List<Map<String, dynamic>>?> getSurveyQuestions() async {
    try {
      final token = await _getToken();
      final res = await _api.getJson('/api/surveys/questions/active', headers: _bearer(token));
      if (res is List) {
        return res.cast<Map<String, dynamic>>();
      } else if (res is Map<String, dynamic> && res['data'] is List) {
        return (res['data'] as List).cast<Map<String, dynamic>>();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool?> submitSurveyAnswers(List<Map<String, dynamic>> answers) async {
    try {
      final payload = {
        'answers': answers,
      };
      final token = await _getToken();
      await _api.postJson('/api/surveys/answers', body: payload, headers: _bearer(token));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> generateHealthPlan() async {
    try {
      final token = await _getToken();
      final data = await _api.postJson('/api/surveys/plan/generate', headers: _bearer(token));
      return data;
    } catch (e) {
      return null;
    }
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


