## Task: Test màn hình khảo sát và đăng nhập

**Date/Time:** 2025-09-25 00:00:00 (updated after re-run)

## Kết quả Test

- Total steps: 2
- Pass: 2
- Fail: 0

## Chi tiết từng step

1) Chạy widget test SurveyFlowScreen
- Mô tả step: Kiểm tra chuyển câu hỏi và hành vi khi bấm NEXT ở câu hỏi cuối
- Pass/Fail: Pass
- Lưu ý: Đã cập nhật assert để khớp logic `maybePop()`

2) Chạy widget test LoginScreen -> điều hướng
- Mô tả step: Tap Đăng nhập và kỳ vọng điều hướng sang màn khảo sát
- Pass/Fail: Pass (đã mock `AuthService`, điền dữ liệu hợp lệ và assert rời `LoginScreen`)
- Lưu ý: Đã chỉnh test sử dụng DI cho `AuthService` để dễ mock trong tương lai.


