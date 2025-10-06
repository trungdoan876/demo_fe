import '../services/survey_service.dart';
import '../../domain/models/survey_question.dart';
import '../../domain/models/survey_answer.dart';
//class này quản lý về Survey
//Lấy câu hỏi từ API và convert thành Domain models
class SurveyRepository {
  final SurveyService _surveyService;

  SurveyRepository(this._surveyService);

  Future<List<SurveyQuestion>> getSurveyQuestions() async {
    try {
      final response = await _surveyService.getSurveyQuestions();
      if (response != null) {
        return (response as List)
            .map((json) => SurveyQuestion.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Get survey questions failed: $e');
    }
  }

  Future<bool> submitSurveyAnswers(List<SurveyAnswer> answers) async {
    try {
      final response = await _surveyService.submitSurveyAnswers(
        answers.map((answer) => answer.toJson()).toList(),
      );
      return response ?? false;
    } catch (e) {
      throw Exception('Submit survey answers failed: $e');
    }
  }

  Future<Map<String, dynamic>?> generateHealthPlan() async {
    try {
      final response = await _surveyService.generateHealthPlan();
      return response;
    } catch (e) {
      throw Exception('Generate health plan failed: $e');
    }
  }
}
