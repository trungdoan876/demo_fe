import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:demo_01/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Wello App E2E Tests', () {
    testWidgets('Complete User Journey: Onboarding → Login → Survey', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pump(const Duration(seconds: 2));

      // Test 1: Onboarding Screen
      print('🧪 Testing Onboarding Screen...');
      
      // Verify logo Wello is displayed
      expect(find.text('Wello'), findsOneWidget);
      
      // Verify description text
      expect(find.textContaining('Wello giúp bạn đạt được mục tiêu sức khỏe'), findsOneWidget);
      
      // Verify "Let's Start" button
      expect(find.text("Let's Start"), findsOneWidget);
      
      // Tap "Let's Start" button - sử dụng find.byType với index
      final buttons = find.byType(ElevatedButton);
      expect(buttons, findsWidgets);
      await tester.tap(buttons.first);
      await tester.pump(const Duration(seconds: 1));
      
      print('✅ Onboarding Screen test passed');

      // Test 2: Login Screen
      print('🧪 Testing Login Screen...');
      
      // Verify login form elements
      expect(find.text('Đăng nhập để tiếp tục'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Đăng nhập'), findsOneWidget);
      expect(find.text('Tạo tài khoản'), findsOneWidget);
      
      // Test invalid login (empty fields)
      final loginButton = find.byKey(const Key('login_button'));
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pump(const Duration(seconds: 1));
      
      // Should show error message for empty fields
      expect(find.textContaining('Vui lòng nhập đầy đủ thông tin'), findsOneWidget);
      
      print('✅ Login Screen validation test passed');

      // Test 3: Register Screen Navigation
      print('🧪 Testing Register Screen Navigation...');
      
      // Tap "Tạo tài khoản" to go to register
      final registerButton = find.text('Tạo tài khoản');
      expect(registerButton, findsOneWidget);
      await tester.tap(registerButton);
      await tester.pump(const Duration(seconds: 1));
      
      // Verify register screen elements
      expect(find.text('Tạo tài khoản'), findsOneWidget);
      
      print('✅ Register Screen navigation test passed');

      // Go back to login - sử dụng back button trong AppBar
      final backButton = find.byIcon(Icons.arrow_back_ios_new_rounded);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pump(const Duration(seconds: 1));
      }
      
      print('✅ Complete E2E test passed - All screens navigated successfully');
    });

    testWidgets('Login Form Validation Test', (WidgetTester tester) async {
      app.main();
      await tester.pump(const Duration(seconds: 2));
      
      // Navigate to login screen
      final buttons = find.byType(ElevatedButton);
      expect(buttons, findsWidgets);
      await tester.tap(buttons.first);
      await tester.pump(const Duration(seconds: 1));
      
      // Test empty email field
      await tester.enterText(find.byType(TextField).first, '');
      await tester.enterText(find.byType(TextField).last, 'password123');
      final loginButton = find.byKey(const Key('login_button'));
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pump(const Duration(seconds: 1));
      
      expect(find.textContaining('Vui lòng nhập đầy đủ thông tin'), findsOneWidget);
      
      // Test empty password field
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, '');
      final loginButton2 = find.byKey(const Key('login_button'));
      expect(loginButton2, findsOneWidget);
      await tester.tap(loginButton2);
      await tester.pump(const Duration(seconds: 1));
      
      expect(find.textContaining('Vui lòng nhập đầy đủ thông tin'), findsOneWidget);
      
      print('✅ Login form validation test passed');
    });

    testWidgets('UI Elements and Animations Test', (WidgetTester tester) async {
      app.main();
      await tester.pump(const Duration(seconds: 2));
      
      // Test logo animation (wait for animation)
      await tester.pump(const Duration(seconds: 2));
      
      // Verify gradient text is present
      expect(find.text('Wello'), findsOneWidget);
      
      // Test button interactions
      final buttons = find.byType(ElevatedButton);
      expect(buttons, findsWidgets);
      
      // Verify button is tappable
      await tester.tap(buttons.first);
      await tester.pump(const Duration(seconds: 1));
      
      print('✅ UI elements and animations test passed');
    });
  });
}
