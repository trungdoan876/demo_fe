# Checklist E2E Testing Wello App

## 📋 Mục tiêu
Thực hiện End-to-End testing cho toàn bộ user journey của ứng dụng Wello từ onboarding đến hoàn thành survey và tạo kế hoạch sức khỏe.

## ✅ Checklist Chi tiết

### 1. Chuẩn bị môi trường E2E test
- [x] Kiểm tra Flutter environment và version
- [x] Cài đặt dependencies: `flutter pub get`
- [x] Cài đặt E2E testing tools (integration_test package)
- [x] Setup test data và mock API endpoints
- [x] Build app cho testing: `flutter build apk --debug`
- [x] **Tiêu chí Done**: Môi trường E2E test sẵn sàng

### 2. E2E Test Onboarding → Login Flow
- [x] App khởi động và hiển thị Onboarding Screen
- [x] Verify logo Wello với animation float hoạt động
- [x] Verify text mô tả app hiển thị đúng
- [x] Tap button "Let's Start" và verify navigation đến Login Screen
- [x] **Tiêu chí Done**: Complete onboarding → login navigation flow

### 3. E2E Test Login Authentication Flow
- [x] Verify Login Screen hiển thị với form đăng nhập
- [x] Input valid email và password
- [x] Tap "Đăng nhập" và verify loading state
- [x] Verify successful login và navigation đến Survey Screen
- [x] Test invalid credentials và verify error message
- [x] Test "Tạo tài khoản" navigation đến Register Screen
- [x] **Tiêu chí Done**: Complete authentication flow với success/error cases

### 4. E2E Test Registration Flow
- [x] Navigate từ Login đến Register Screen
- [x] Input valid registration data (email, password, confirm password)
- [x] Tap register button và verify success
- [x] Verify navigation về Login Screen sau successful registration
- [x] Test validation errors (invalid email, password mismatch)
- [x] **Tiêu chí Done**: Complete registration flow với validation

### 5. E2E Test Complete Survey Flow
- [ ] Navigate từ Login đến Survey Screen sau successful authentication
- [ ] Verify API call để load questions
- [ ] Test navigation qua từng câu hỏi (Next/Previous)
- [ ] Select answers cho từng câu hỏi
- [ ] Verify progress tracking
- [ ] Submit all answers và verify API call
- [ ] Verify plan generation và display
- [ ] **Tiêu chí Done**: Complete survey flow từ start đến finish

### 6. E2E Test Error Handling & Edge Cases
- [ ] Test network connectivity issues
- [ ] Test API timeout scenarios
- [ ] Test invalid API responses
- [ ] Test app state persistence (background/foreground)
- [ ] Test memory và performance under load
- [ ] **Tiêu chí Done**: App handles errors gracefully

### 7. E2E Test Cross-platform Compatibility
- [ ] Android E2E test execution
- [ ] iOS E2E test execution (nếu có)
- [ ] Web E2E test execution
- [ ] Verify consistent behavior across platforms
- [ ] **Tiêu chí Done**: E2E tests pass trên tất cả target platforms

### 8. E2E Test Data & API Integration
- [ ] Test với real API endpoints
- [ ] Test với mock data
- [ ] Verify data persistence (SharedPreferences)
- [ ] Test offline/online scenarios
- [ ] **Tiêu chí Done**: Complete data flow và API integration

### 9. Ghi log E2E Test Results
- [x] Tạo file log E2E test trong `/reports/e2e_test_results.md`
- [x] Ghi danh sách bug tìm được
- [x] Ghi lỗi vào `issues/issues.md` nếu có
- [x] **Tiêu chí Done**: Danh sách bug đầy đủ và có thể trace lại

## 🎯 Tiêu chí Hoàn thành E2E Testing
- [ ] Complete user journey từ onboarding đến survey completion
- [ ] All API integrations working correctly
- [ ] Error handling robust và user-friendly
- [ ] Cross-platform compatibility verified
- [ ] Performance metrics within acceptable limits
- [ ] Comprehensive test documentation

## 📝 E2E Testing Notes
- Sử dụng integration_test package cho Flutter E2E
- Test trên thiết bị thật để có kết quả chính xác nhất
- Ghi danh sách bug chi tiết khi tìm thấy
- Test với both real và mock API data
- Verify data persistence across app sessions
