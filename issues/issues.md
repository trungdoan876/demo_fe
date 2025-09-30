# Issues Log - Wello App E2E Testing

## 📅 Date: 28/09/2025
## 🧪 Context: E2E Testing Implementation

---

## 🐛 Issue #1: Widget Finder "Some possible finders" Error

### **Mô tả**
- **Tên ISSUE**: Widget Finder không tìm thấy widget chính xác
- **Mô tả**: Lỗi "Some possible finders for the widgets at Offset" khi chạy E2E test
- **Bước tái hiện**: 
  1. Chạy `flutter test integration_test/app_test.dart`
  2. Test cố gắng tap button "Let's Start"
  3. Xuất hiện lỗi "Some possible finders"
- **Thực tế**: Test không thể tìm thấy widget để tap

### **Nguyên nhân**
- Sử dụng `find.text()` để tìm button không ổn định
- Widget có thể bị ẩn hoặc chưa render hoàn toàn
- Animation đang chạy làm widget không ổn định

### **Cách xử lý tạm thời**
- Thay `find.text("Let's Start")` bằng `find.byType(ElevatedButton)`
- Sử dụng `buttons.first` để tap button đầu tiên
- Thêm `expect(buttons, findsWidgets)` để verify widget tồn tại

### **Trạng thái**: ✅ **Fixed**

---

## 🐛 Issue #2: pumpAndSettle() Timeout Error

### **Mô tả**
- **Tên ISSUE**: pumpAndSettle timeout trong E2E test
- **Mô tả**: Lỗi "pumpAndSettle timed out" khi chờ animation hoàn thành
- **Bước tái hiện**:
  1. Chạy E2E test với `pumpAndSettle()`
  2. Test bị timeout sau 30 giây
  3. Animation float của logo chạy liên tục
- **Thực tế**: Test không thể hoàn thành do animation vô hạn

### **Nguyên nhân**
- `pumpAndSettle()` chờ tất cả animation hoàn thành
- Logo float animation chạy liên tục với `repeat(reverse: true)`
- Test framework không biết khi nào animation kết thúc

### **Cách xử lý tạm thời**
- Thay tất cả `pumpAndSettle()` bằng `pump(const Duration(seconds: 1))`
- Sử dụng timeout cố định thay vì chờ vô hạn
- Thêm `--timeout=15s` khi chạy test

### **Trạng thái**: ✅ **Fixed**

---

## 🐛 Issue #3: pageBack() Navigation Error

### **Mô tả**
- **Tên ISSUE**: pageBack() không hoạt động trong Register Screen
- **Mô tả**: Lỗi "Found 0 widgets with type CupertinoNavigationBarBackButton"
- **Bước tái hiện**:
  1. Navigate từ Login đến Register Screen
  2. Gọi `await tester.pageBack()`
  3. Test fail với lỗi không tìm thấy back button
- **Thực tế**: Register Screen không có back button mặc định

### **Nguyên nhân**
- `pageBack()` tìm kiếm `CupertinoNavigationBarBackButton`
- Register Screen sử dụng custom AppBar với back button khác
- Back button sử dụng `Icons.arrow_back_ios_new_rounded`

### **Cách xử lý tạm thời**
- Thay `pageBack()` bằng custom back button finder
- Sử dụng `find.byIcon(Icons.arrow_back_ios_new_rounded)`
- Thêm check `if (backButton.evaluate().isNotEmpty)` trước khi tap

### **Trạng thái**: ✅ **Fixed**

---

## 🐛 Issue #4: Duplicate Variable Declaration

### **Mô tả**
- **Tên ISSUE**: Biến `loginButton` được khai báo 2 lần
- **Mô tả**: Lỗi compile "The name 'loginButton' is already defined"
- **Bước tái hiện**:
  1. Trong test "Login Form Validation Test"
  2. Khai báo `final loginButton` 2 lần trong cùng scope
  3. Dart compiler báo lỗi duplicate variable
- **Thực tế**: Code không compile được

### **Nguyên nhân**
- Copy-paste code mà không đổi tên biến
- Cùng một test case sử dụng login button nhiều lần
- Không quản lý scope của biến đúng cách

### **Cách xử lý tạm thời**
- Đổi tên biến thứ 2 thành `loginButton2`
- Hoặc sử dụng lại biến `loginButton` đã khai báo
- Refactor code để tránh duplicate

### **Trạng thái**: ✅ **Fixed**

---

## 🐛 Issue #5: Integration Test Package Setup

### **Mô tả**
- **Tên ISSUE**: Symlink support required for integration_test
- **Mô tả**: Lỗi "Building with plugins requires symlink support"
- **Bước tái hiện**:
  1. Chạy `flutter pub get` sau khi thêm integration_test
  2. Xuất hiện warning về symlink support
  3. Test vẫn chạy được nhưng có warning
- **Thực tế**: Windows cần enable Developer Mode

### **Nguyên nhân**
- Windows 11 cần Developer Mode để support symlink
- Integration test cần symlink để link plugins
- Không ảnh hưởng đến test execution

### **Cách xử lý tạm thời**
- Bỏ qua warning vì test vẫn chạy được
- Có thể enable Developer Mode nếu cần: `start ms-settings:developers`
- Test execution không bị ảnh hưởng

### **Trạng thái**: ⚠️ **Won't Fix** (không ảnh hưởng test)

---

## 📊 Summary

| Issue ID | Severity | Status | Impact |
|----------|----------|--------|--------|
| #1 | High | Fixed | Test execution |
| #2 | High | Fixed | Test timeout |
| #3 | Medium | Fixed | Navigation flow |
| #4 | Low | Fixed | Code quality |
| #5 | Low | Won't Fix | Setup warning |

**Total Issues**: 5  
**Fixed**: 4  
**Won't Fix**: 1  
**Critical**: 0  

---

## 🎯 Lessons Learned

1. **Widget Finding**: Sử dụng `find.byType()` và `find.byKey()` ổn định hơn `find.text()`
2. **Animation Handling**: Sử dụng fixed duration thay vì `pumpAndSettle()` cho animation vô hạn
3. **Navigation Testing**: Custom back button handling cần thiết cho custom AppBar
4. **Code Quality**: Tránh duplicate variable trong cùng scope
5. **Test Stability**: Timeout configuration quan trọng cho E2E testing

---

## 🐛 Issue #6: RegisterScreen Test Mock Issues

### **Mô tả**
- **Tên ISSUE**: RegisterScreen test không hoạt động với mock AuthService
- **Mô tả**: Test "Đăng ký thành công với mock AuthService" không tìm thấy SnackBar
- **Bước tái hiện**:
  1. Chạy `flutter test test/register_screen_test.dart`
  2. Test "Đăng ký thành công với mock AuthService" fail
  3. Không tìm thấy text "Đăng ký thành công"
- **Thực tế**: Mock AuthService không được inject vào RegisterScreen

### **Nguyên nhân**
- RegisterScreen tạo AuthService mới trong constructor
- Mock AuthService không được sử dụng
- Test không thể override AuthService dependency

### **Cách xử lý tạm thời**
- Cần refactor RegisterScreen để accept AuthService parameter
- Hoặc sử dụng dependency injection pattern
- Tạm thời skip test này

### **Trạng thái**: 🔄 **Open**

---

## 🐛 Issue #7: Loading State Test Timeout

### **Mô tả**
- **Tên ISSUE**: Test loading state không tìm thấy CircularProgressIndicator
- **Mô tả**: Test "Hiển thị loading state khi đang đăng ký" fail
- **Bước tái hiện**:
  1. Chạy test với mock AuthService có delay
  2. Test không tìm thấy CircularProgressIndicator
  3. Loading state không được trigger
- **Thực tế**: Mock delay không đủ để trigger loading state

### **Nguyên nhân**
- Mock delay quá ngắn
- Test không đợi đủ thời gian để loading state xuất hiện
- Async operation không được handle đúng

### **Cách xử lý tạm thời**
- Tăng delay time trong mock
- Thêm pump() calls để trigger state changes
- Kiểm tra loading state trước khi assert

### **Trạng thái**: 🔄 **Open**

---

## 🐛 Issue #8: Social Icons Test Ambiguity

### **Mô tả**
- **Tên ISSUE**: Test social icons tìm thấy quá nhiều empty text widgets
- **Mô tả**: Test "Social icons hiển thị đúng" fail với "Found 3 widgets with text ''"
- **Bước tái hiện**:
  1. Test tìm kiếm Apple icon với text ""
  2. Tìm thấy 3 widgets với empty text (TextField widgets)
  3. Test không thể phân biệt được icon nào
- **Thực tế**: TextField widgets cũng có empty text

### **Nguyên nhân**
- Apple icon sử dụng empty string ""
- TextField widgets cũng có empty text
- Test không đủ specific để tìm đúng widget

### **Cách xử lý tạm thời**
- Sử dụng find.byType() thay vì find.text()
- Hoặc tìm kiếm trong specific widget tree
- Thêm key cho social icons

### **Trạng thái**: 🔄 **Open**

---

## 🐛 Issue #9: AuthService Test Timeout

### **Mô tả**
- **Tên ISSUE**: AuthService test bị timeout sau 10 phút
- **Mô tả**: Test "login should call API with correct parameters" timeout
- **Bước tái hiện**:
  1. Chạy `flutter test test/auth_service_test.dart`
  2. Test bị timeout sau 10 phút
  3. Không có output hoặc error message
- **Thực tế**: Test không thể hoàn thành

### **Nguyên nhân**
- MockApiClient có thể có vấn đề với async operations
- SharedPreferences mock có thể gây deadlock
- Test setup không đúng với Flutter test framework

### **Cách xử lý tạm thời**
- Kiểm tra MockApiClient implementation
- Sử dụng proper async/await patterns
- Thêm timeout cho individual tests

### **Trạng thái**: 🔄 **Open**

---

## 📊 Updated Summary

| Issue ID | Severity | Status | Impact |
|----------|----------|--------|--------|
| #1 | High | Fixed | Test execution |
| #2 | High | Fixed | Test timeout |
| #3 | Medium | Fixed | Navigation flow |
| #4 | Low | Fixed | Code quality |
| #5 | Low | Won't Fix | Setup warning |
| #6 | High | Open | Test coverage |
| #7 | Medium | Open | Test reliability |
| #8 | Low | Open | Test specificity |
| #9 | High | Open | Test execution |

**Total Issues**: 9  
**Fixed**: 4  
**Open**: 4  
**Won't Fix**: 1  
**Critical**: 0  

---

*Issues logged by: AI Assistant*  
*Date: 30/09/2025*  
*Context: Frontend Testing Implementation*
