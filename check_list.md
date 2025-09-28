## Checklist: Viết test UI cho Login

### Mục tiêu
- Đảm bảo màn hình `LoginScreen` hiển thị đúng, nhập liệu được, password bị ẩn, nút Đăng nhập hoạt động (không crash), và điều hướng từ `OnboardingScreen` hoạt động.

### Các bước thực hiện
1. Đọc `README.md` và `rule/rules.md` để nắm quy ước dự án
   - DOD: Đã mở và rà soát nội dung, xác nhận yêu cầu đặc thù của dự án
   - [x] Done

2. Viết test: `LoginScreen hiển thị đủ thành phần`
   - DOD: Test khởi tạo `MaterialApp(home: LoginScreen())` và assert:
     - Tiêu đề có `Key('login_title')`
     - Có 2 `TextField`
     - Có nút `Key('login_button')`
     - Có text "Quên mật khẩu?"
   - [x] Done

3. Viết test: Nhập email/password và tap nút Đăng nhập
   - DOD: Gõ vào 2 `TextField`, tap `login_button`, `tester.pump()` không throw
   - [x] Done

4. Viết test: Password field dùng `obscureText`
   - DOD: Xác nhận `TextField` thứ hai đang `obscureText == true` (qua `EditableText`/`Semantics` hoặc matcher phù hợp)
   - [x] Done

5. Viết test: Từ `OnboardingScreen` tap "Let's Start" điều hướng sang `LoginScreen`
   - DOD: Sau `tap` + `pumpAndSettle()`, tìm thấy `Key('login_title')`
   - [ ] Done

6. Chạy toàn bộ test
   - DOD: `flutter test` chạy thành công, tất cả case Pass
   - [ ] Done

7. Ghi log kết quả test
   - DOD: Tạo file `/reports/test_ui_login.md` theo mẫu ở `rule/rules.md`, điền số lượng Step, Pass/Fail và chi tiết
   - [ ] Done

### Ghi chú
- Không tạo file mới ngoài phạm vi mô tả nếu chưa được đồng ý.
- Nếu phát sinh issue trong quá trình test, ghi vào `rule/issues.md` và sau khi fix, cập nhật `rule/lesson_learn.md`.

---

## Checklist: Điều hướng sau đăng nhập sang màn hình khảo sát giấc ngủ

### Mục tiêu
- Sau khi bấm nút "Đăng nhập" trên `LoginScreen`, điều hướng sang màn hình khảo sát như mockup (tiêu đề Wello, câu hỏi, 4 lựa chọn, nút NEXT).

### Các bước thực hiện

1. Tạo màn hình `SurveyQuestionScreen` (UI generic theo mockup)
   - DOD: Có `AppBar` back, tiêu đề (key `survey_title`), câu hỏi (key `survey_question`), danh sách options, nút `NEXT` (key `survey_next_button`)
   - [x] Done

2. Cập nhật `LoginScreen` để `onPressed` của `login_button` điều hướng đến `SurveyQuestionScreen`
   - DOD: Dùng `Navigator.pushReplacement` hoặc `push`
   - [x] Done

3. Viết test widget: nhấn `login_button` điều hướng sang `SurveyQuestionScreen`
   - DOD: Sau `tap` + `pumpAndSettle()`, tìm thấy `survey_title`, `survey_question`, `survey_next_button`
   - [x] Done

4. Chạy toàn bộ test và ghi log
   - DOD: `flutter test` Pass, ghi `/reports/test_ui_login.md` (bổ sung phần điều hướng)
   - [ ] Done

---

## Checklist: Chỉnh giao diện cho thật đẹp

### Mục tiêu
- Thống nhất phong cách (typography, màu sắc, bo góc, khoảng cách) trên toàn bộ app, tạo cảm giác hiện đại và đồng nhất.

### Các bước thực hiện
1. Khảo sát UI hiện tại, liệt kê điểm cần cải thiện
   - DOD: có danh sách ngắn các điểm cần cải thiện (typo, spacing, màu, nút, input)
   - [x] Done

2. Tạo `lib/theme.dart` với ThemeData dùng GoogleFonts, màu chủ đạo, shape đồng nhất
   - DOD: file được build OK, cấu hình AppBar, Button, TextTheme, InputDecoration, SnackBar
   - [x] Done

3. Áp dụng theme vào `MaterialApp` trong `lib/main.dart`
   - DOD: app chạy, không lỗi, theme áp dụng toàn cục
   - [x] Done

4. Đồng bộ AppBar, ElevatedButton, TextField theo theme ở các màn hình chính
   - DOD: kiểu dáng thống nhất, màu sắc/bo góc/elevation đồng bộ
   - [x] Done (đã cập nhật `survey_question_screen.dart`)

5. Tinh chỉnh Onboarding, Login, Register, Survey cho đồng bộ (spacing, typography)
   - DOD: khoảng cách hợp lý, không tràn layout, tiêu đề và nội dung dùng font đồng bộ
   - [ ] Done

6. Kiểm thử nhanh trên Android emulator và web (nếu có)
   - DOD: không lỗi hiển thị, nút bấm hoạt động, điều hướng ổn định
   - [ ] Done

7. Ghi log test vào `reports/chinh_giao_dien.md`
   - DOD: có file log theo mẫu rule, ghi Pass/Fail từng bước
   - [ ] Done

8. Nếu phát sinh lỗi: cập nhật `rule/issues.md`, sau khi fix bổ sung `rule/lesson_learn.md`
   - DOD: có ghi nhận nếu có lỗi
   - [ ] Done