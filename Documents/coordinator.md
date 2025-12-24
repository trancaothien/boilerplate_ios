# Hướng dẫn sử dụng Coordinator Methods

## 1. Child Coordinator Management (Lines 43-63)

**Khi nào sử dụng:**
- Khi bạn tạo một **Child Coordinator** để quản lý một flow mới
- Dùng để quản lý lifecycle của các coordinator con
- Đảm bảo memory management đúng cách

**Các methods:**
- `addChildCoordinator(_:)` - Thêm coordinator con
- `removeChildCoordinator(_:)` - Xóa coordinator con cụ thể
- `removeAllChildCoordinators()` - Xóa tất cả coordinator con
- `findChildCoordinator<T>(ofType:)` - Tìm coordinator con theo type

**Ví dụ từ codebase:**

```swift
// Trong HomeCoordinator.showDetail()
func showDetail(...) {
    // Tạo child coordinator
    let detailCoordinator = DetailCoordinator(
        navigationController: navigationController,
        parentCoordinator: self,
        itemName: itemName,
        // ... params
    )
    
    // ✅ PHẢI thêm vào child coordinators
    addChildCoordinator(detailCoordinator)
    detailCoordinator.start()
}

// Trong HomeCoordinator.showSettings()
func showSettings() {
    let settingsNavController = UINavigationController()
    let settingsCoordinator = SettingCoordinator(
        navigationController: settingsNavController,
        parentCoordinator: self
    )
    
    // ✅ PHẢI thêm vào child coordinators
    addChildCoordinator(settingsCoordinator)
    settingsCoordinator.start()
    
    present(settingsNavController, configuration: .pageSheet)
}
```

**Lưu ý:**
- ✅ **LUÔN** gọi `addChildCoordinator()` khi tạo coordinator mới
- ✅ Coordinator con sẽ tự động được remove khi gọi `finish()`
- ❌ Không cần gọi khi chỉ push một view đơn giản (không có coordinator riêng)

---

## 2. Navigation Methods (Lines 100-124)

**Khi nào sử dụng:**
- Khi điều hướng trong **cùng một navigation stack**
- Push/pop màn hình trong cùng một flow
- Sử dụng khi màn hình được quản lý bởi cùng một `UINavigationController`

**Các methods:**
- `push(_:animated:)` - Push view/viewController lên stack
- `pop(animated:)` - Pop về màn hình trước
- `popToRoot(animated:)` - Pop về màn hình đầu tiên

**Ví dụ từ codebase:**

```swift
// Trong DetailCoordinator.start()
override func start() {
    let viewModel = DetailViewModel(...)
    viewModel.coordinator = self
    let detailView = DetailView(viewModel: viewModel)
    
    // ✅ Sử dụng push() vì Detail nằm trong cùng navigation stack với Home
    push(detailView)
}

// Trong ProfileCoordinator.start() (nếu có)
override func start() {
    let viewModel = ProfileViewModel()
    viewModel.coordinator = self
    let profileView = ProfileView(viewModel: viewModel)
    
    // ✅ Sử dụng push() vì Profile nằm trong cùng navigation stack
    push(profileView)
}
```

**Khi KHÔNG sử dụng:**
- ❌ Khi màn hình là modal (dùng `present()` thay vì `push()`)
- ❌ Khi màn hình có navigation controller riêng (dùng `present()` với nav controller)

**So sánh:**

| Tình huống | Method | Ví dụ |
|------------|--------|-------|
| Màn hình trong cùng stack | `push()` | Home → Detail |
| Màn hình là modal | `present()` | Home → Settings (modal) |
| Màn hình có nav riêng | `present()` với nav controller | Settings modal |

---

## 3. Modal Presentation Methods (Lines 67-97)

**Khi nào sử dụng:**
- Khi hiển thị màn hình dưới dạng **modal** (bottom sheet, full screen modal)
- Khi màn hình có **navigation controller riêng**
- Khi muốn hiển thị màn hình **độc lập** với navigation stack hiện tại

**Các methods:**
- `present(_:configuration:animated:completion:)` - Present view/viewController modally
- `dismiss(animated:completion:)` - Dismiss modal hiện tại

**Ví dụ từ codebase:**

### Ví dụ 1: Present với Navigation Controller riêng

```swift
// Trong HomeCoordinator.showSettings()
func showSettings() {
    // Tạo navigation controller riêng cho modal
    let settingsNavController = UINavigationController()
    
    let settingsCoordinator = SettingCoordinator(
        navigationController: settingsNavController,
        parentCoordinator: self
    )
    addChildCoordinator(settingsCoordinator)
    settingsCoordinator.start()
    
    // ✅ Sử dụng present() vì Settings là modal với nav controller riêng
    present(settingsNavController, configuration: .pageSheet)
}
```

### Ví dụ 2: Present view đơn giản (không có coordinator)

```swift
// Trong HomeCoordinator.showPageSheetModal()
func showPageSheetModal() {
    let demoView = ModalDemoView(
        title: "Page Sheet Modal",
        description: "...",
        onDismiss: { [weak self] in
            // ✅ Sử dụng dismiss() để đóng modal
            self?.dismiss()
        }
    )
    
    // ✅ Sử dụng present() vì đây là modal đơn giản
    present(demoView, configuration: .pageSheet)
}
```

### Ví dụ 3: Dismiss modal

```swift
// Trong ViewModel hoặc View
func closeModal() {
    coordinator?.dismiss() // ✅ Đóng modal hiện tại
}
```

**Các loại ModalConfiguration:**

```swift
// Bottom sheet (có thể kéo xuống)
present(view, configuration: .pageSheet)

// Full screen
present(view, configuration: .fullScreen)

// Form sheet (thường dùng trên iPad)
present(view, configuration: .formSheet)

// Custom configuration
let config = ModalConfiguration(
    presentationStyle: .pageSheet,
    transitionStyle: .flipHorizontal,
    isModalInPresentation: true
)
present(view, configuration: config)
```

---

## Tóm tắt: Khi nào dùng gì?

### Scenario 1: Màn hình trong cùng navigation stack
```swift
// ✅ Dùng push() + addChildCoordinator()
let detailCoordinator = DetailCoordinator(...)
addChildCoordinator(detailCoordinator)
detailCoordinator.start() // Bên trong start() sẽ gọi push()
```

### Scenario 2: Màn hình modal với nav controller riêng
```swift
// ✅ Dùng present() + addChildCoordinator()
let settingsNavController = UINavigationController()
let settingsCoordinator = SettingCoordinator(
    navigationController: settingsNavController,
    parentCoordinator: self
)
addChildCoordinator(settingsCoordinator)
settingsCoordinator.start()
present(settingsNavController, configuration: .pageSheet)
```

### Scenario 3: Màn hình modal đơn giản (không có coordinator)
```swift
// ✅ Dùng present() (không cần addChildCoordinator)
let modalView = SimpleModalView()
present(modalView, configuration: .pageSheet)
```

### Scenario 4: Đóng modal
```swift
// ✅ Dùng dismiss()
dismiss()
```

---

## Checklist khi tạo navigation mới

- [ ] Màn hình có coordinator riêng? → Dùng `addChildCoordinator()`
- [ ] Màn hình trong cùng stack? → Dùng `push()`
- [ ] Màn hình là modal? → Dùng `present()`
- [ ] Modal có nav controller riêng? → Tạo `UINavigationController` mới
- [ ] Cần đóng modal? → Dùng `dismiss()`
