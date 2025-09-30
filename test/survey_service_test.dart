import 'package:flutter_test/flutter_test.dart';
import 'package:demo_01/services/survey_service.dart';
import 'package:demo_01/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mock_api_client.dart';

void main() {
  group('SurveyService Tests', () {
    late SurveyService surveyService;
    late MockApiClient mockApiClient;

    setUp(() {
      mockApiClient = MockApiClient();
      surveyService = SurveyService(apiClient: mockApiClient);
      mockApiClient.reset();
    });

    testWidgets('getActiveQuestions should return list of questions', (tester) async {
      // Arrange
      const token = 'test-token';
      SharedPreferences.setMockInitialValues({'auth_token': token});
      
      final mockQuestions = [
        {
          'id': 1,
          'content': 'What is your age?',
          'options': [
            {'id': 1, 'label': '18-25'},
            {'id': 2, 'label': '26-35'},
          ]
        },
        {
          'id': 2,
          'content': 'What is your fitness level?',
          'options': [
            {'id': 3, 'label': 'Beginner'},
            {'id': 4, 'label': 'Intermediate'},
          ]
        }
      ];
      
      mockApiClient.setMockGetResponse({'data': mockQuestions});

      // Act
      final result = await surveyService.getActiveQuestions();

      // Assert
      expect(result.length, equals(2));
      expect(result[0].id, equals(1));
      expect(result[0].content, equals('What is your age?'));
      expect(result[0].options.length, equals(2));
      expect(result[0].options[0].label, equals('18-25'));
      
      expect(mockApiClient.lastGetPath, equals('/api/surveys/questions/active'));
      expect(mockApiClient.lastGetHeaders?['Authorization'], equals('Bearer $token'));
    });

    testWidgets('submitAnswers should call API with correct parameters', (tester) async {
      // Arrange
      const token = 'test-token';
      SharedPreferences.setMockInitialValues({'auth_token': token});
      
      final answers = [
        AnswerItem(questionId: 1, optionId: 1),
        AnswerItem(questionId: 2, optionId: 3),
      ];
      
      mockApiClient.setMockPostResponse({});

      // Act
      await surveyService.submitAnswers(answers);

      // Assert
      expect(mockApiClient.lastPostPath, equals('/api/surveys/answers'));
      expect(mockApiClient.lastPostBody, equals({
        'answers': [
          {'questionId': 1, 'optionId': 1},
          {'questionId': 2, 'optionId': 3},
        ]
      }));
      expect(mockApiClient.lastPostHeaders?['Authorization'], equals('Bearer $token'));
    });

    testWidgets('generatePlan should return plan model', (tester) async {
      // Arrange
      const token = 'test-token';
      SharedPreferences.setMockInitialValues({'auth_token': token});
      
      final mockPlan = {
        'goal': 'Lose weight',
        'content': 'Follow this plan to lose 5kg in 3 months'
      };
      
      mockApiClient.setMockPostResponse(mockPlan);

      // Act
      final result = await surveyService.generatePlan();

      // Assert
      expect(result.goal, equals('Lose weight'));
      expect(result.content, equals('Follow this plan to lose 5kg in 3 months'));
      expect(mockApiClient.lastPostPath, equals('/api/surveys/plan/generate'));
      expect(mockApiClient.lastPostHeaders?['Authorization'], equals('Bearer $token'));
    });

    testWidgets('should handle API errors gracefully', (tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({'auth_token': 'test-token'});
      mockApiClient.setMockError('API Error');

      // Act & Assert
      expect(
        () => surveyService.getActiveQuestions(),
        throwsA(isA<Exception>()),
      );
    });
  });
}

