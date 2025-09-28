import 'package:demo_01/screens/survey_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SurveyFlowScreen advances and pops at end', (tester) async {
    final questions = [
      const SurveyQuestion(question: 'Q1', options: ['A', 'B']),
      const SurveyQuestion(question: 'Q2', options: ['A', 'B']),
    ];

    await tester.pumpWidget(MaterialApp(
      home: SurveyFlowScreen(appTitle: 'W', questions: questions),
    ));

    expect(find.text('Q1'), findsOneWidget);

    // Tap NEXT to go to Q2
    await tester.tap(find.byKey(const Key('survey_next_button')));
    await tester.pumpAndSettle();
    expect(find.text('Q2'), findsOneWidget);

    // Tap NEXT to finish (maybePop). Vì không có route trước đó, màn vẫn giữ nguyên.
    await tester.tap(find.byKey(const Key('survey_next_button')));
    await tester.pumpAndSettle();
    // Vẫn đang ở câu hỏi cuối cùng
    expect(find.text('Q2'), findsOneWidget);
  });
}


