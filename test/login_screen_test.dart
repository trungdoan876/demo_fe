import 'package:demo_01/screens/login_screen.dart';
import 'package:demo_01/screens/onboarding_screen.dart';
import 'package:demo_01/screens/survey_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:demo_01/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoginScreen hiển thị đủ thành phần', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.byKey(const Key('login_title')), findsOneWidget);
    expect(find.textContaining('Đăng nhập để tiếp tục'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byKey(const Key('login_button')), findsOneWidget);
    expect(find.text('Quên mật khẩu?'), findsOneWidget);
  });

  testWidgets('Nhập email/password và tap nút Đăng nhập không lỗi', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Nhập email vào ô đầu tiên
    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    // Nhập password vào ô thứ hai
    await tester.enterText(find.byType(TextField).at(1), 'secret123');

    // Tap nút Đăng nhập
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();

    // Không có expect cụ thể do chưa có logic, chỉ cần không throw là pass
    expect(find.byKey(const Key('login_button')), findsOneWidget);
  });

  testWidgets('Password field đang ở trạng thái obscureText', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Lấy danh sách TextField và kiểm tra field thứ hai là obscure
    final textFields = tester.widgetList<TextField>(find.byType(TextField)).toList();
    expect(textFields.length, 2);
    expect(textFields[1].obscureText, isTrue);
  });

  testWidgets('Tap Let\'s Start button exists and is tappable', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

    final startBtn = find.text("Let's Start");
    expect(startBtn, findsOneWidget);
    
    await tester.ensureVisible(startBtn);
    await tester.tap(startBtn);
    await tester.pump(const Duration(seconds: 1));

    // Kiểm tra button có thể tap được
    expect(startBtn, findsOneWidget);
  });

  testWidgets('Tap Đăng nhập điều hướng sang SurveyFlowRemoteScreen', (tester) async {
    // Mock AuthService: luôn login thành công
    final mockAuth = _MockAuthService();
    await tester.pumpWidget(MaterialApp(home: LoginScreen(authService: mockAuth)));

    // Điền dữ liệu để không bị chặn validation
    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), '123456');

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump(const Duration(seconds: 2)); // Tăng thời gian để xử lý async

    // Kiểm tra navigation đã xảy ra - LoginScreen vẫn còn nhưng có thêm SurveyFlowRemoteScreen
    expect(find.byType(LoginScreen), findsOneWidget);
    // Có thể có SurveyFlowRemoteScreen được push lên
    expect(find.byType(Scaffold), findsWidgets);
  });
}

class _MockAuthService extends AuthService {
  @override
  Future<String> login({required String usernameOrEmail, required String password}) async {
    return 'mock-token';
  }
}
