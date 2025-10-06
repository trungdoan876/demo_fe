// Domain Layer trong Clean Architecture: 
// chứa các logic nghiệp vụ
class SurveyAnswer {
  final String questionId;
  final String answer;
  final DateTime answeredAt;

  const SurveyAnswer({
    required this.questionId,
    required this.answer,
    required this.answeredAt,
  });
  //factory constructor từ JSON
  factory SurveyAnswer.fromJson(Map<String, dynamic> json) {
    return SurveyAnswer(
      questionId: json['questionId'] as String,
      answer: json['answer'] as String,
      answeredAt: DateTime.parse(json['answeredAt'] as String),
    );
  }
  //convert thành JSON
  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answer': answer,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SurveyAnswer &&
        other.questionId == questionId &&
        other.answer == answer;
  }

  @override
  int get hashCode {
    return questionId.hashCode ^ answer.hashCode;
  }

  @override
  String toString() {
    return 'SurveyAnswer(questionId: $questionId, answer: $answer)';
  }
}
