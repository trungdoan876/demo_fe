class SurveyQuestion {
  final String id;
  final String question;
  final String type; // 'single_choice', 'multiple_choice', 'text', 'scale'
  final List<String>? options;
  final bool isRequired;
  final int order;

  const SurveyQuestion({
    required this.id,
    required this.question,
    required this.type,
    this.options,
    this.isRequired = true,
    required this.order,
  });
  //factory constructor từ JSON
  factory SurveyQuestion.fromJson(Map<String, dynamic> json) {
    return SurveyQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      type: json['type'] as String,
      options: json['options'] != null 
          ? List<String>.from(json['options'] as List)
          : null,
      isRequired: json['isRequired'] as bool? ?? true,
      order: json['order'] as int,
    );
  }
  //convert thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type,
      'options': options,
      'isRequired': isRequired,
      'order': order,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SurveyQuestion &&
        other.id == id &&
        other.question == question &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^ question.hashCode ^ type.hashCode;
  }

  @override
  String toString() {
    return 'SurveyQuestion(id: $id, question: $question, type: $type)';
  }
}
