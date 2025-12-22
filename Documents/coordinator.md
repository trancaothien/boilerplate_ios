# Hướng dẫn sử dụng Coordinator Pattern

Dự án này sử dụng mô hình **MVVM-C (Model-View-ViewModel-Coordinator)** để quản lý luồng điều hướng của ứng dụng. Tài liệu này hướng dẫn cách tạo màn hình mới và sử dụng các tính năng điều hướng.

## 1. Cấu trúc

Mọi Coordinator trong ứng dụng đều kế thừa từ `BaseCoordinator` (hoặc implement protocol `Coordinator`).
`BaseCoordinator` đã xử lý sẵn việc quản lý `navigationController` và `childCoordinators`.

## 2. Cách tạo một màn hình mới

Để tạo một tính năng/màn hình mới (ví dụ: `Profile`), bạn cần tạo 3 thành phần: View, ViewModel, và Coordinator.

### Bước 1: Tạo Coordinator

Tạo file `ProfileCoordinator.swift` kế thừa từ `BaseCoordinator`.

```swift
import UIKit
import Core

final class ProfileCoordinator: BaseCoordinator {
    
    override func start() {
        // Khởi tạo ViewModel và View
        let viewModel = ProfileViewModel()
        viewModel.coordinator = self // Gán coordinator cho VM để xử lý action
        
        let view = ProfileView(viewModel: viewModel)
        
        // Push màn hình vào stack
        push(view, animated: true)
    }
}
```

### Bước 2: Tạo ViewModel

Tạo file `ProfileViewModel.swift`. ViewModel nên giữ reference `weak` tới Coordinator.

```swift
import Foundation
import Core

final class ProfileViewModel: BaseViewModel {
    // Reference yếu tới Coordinator để tránh retain cycle
    weak var coordinator: ProfileCoordinator?
    
    func openDetail() {
        coordinator?.showDetail()
    }
    
    func goBack() {
        coordinator?.goBack()
    }
}
```

### Bước 3: Tạo View

Tạo file `ProfileView.swift` (SwiftUI).

```swift
import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        Button("Open Detail") {
            viewModel.openDetail()
        }
    }
}
```

## 3. Cách điều hướng (Navigation)

Việc điều hướng **phải** được thực hiện trong class `Coordinator`, không thực hiện trực tiếp trong View hay ViewModel.

### Push một màn hình mới

Có 2 cách để điều hướng sang màn hình mới, tuỳ thuộc vào độ phức tạp của màn hình đó:

#### Cách 1: Màn hình thuộc một Flow phức tạp (Dùng Child Coordinator)
Nếu màn hình mới bắt đầu một luồng chức năng lớn (ví dụ `Profile`, `Settings`), hãy tạo Coordinator riêng:

```swift
func showProfile() {
    let profileCoordinator = ProfileCoordinator(
        navigationController: navigationController,
        parentCoordinator: self
    )
    addChildCoordinator(profileCoordinator)
    profileCoordinator.start() 
    // Bên trong hàm start() của ProfileCoordinator sẽ gọi lệnh push() để hiển thị view
}
```

#### Cách 2: Màn hình đơn giản (Dùng trực tiếp Push)
Nếu màn hình chỉ là xem chi tiết đơn giản (ví dụ `DetailView`), không có nhiều logic điều hướng tiếp, bạn không cần tạo Coordinator mới:

```swift
func showDetail(id: String) {
    let viewModel = DetailViewModel(id: id)
    let view = DetailView(viewModel: viewModel)
    
    // Push trực tiếp trong Coordinator hiện tại
    push(view)
}
```

### Pop (Back) về màn hình trước

```swift
// Trong ProfileCoordinator
func goBack() {
    pop() // Tương đương navigationController.popViewController
    // Nếu màn hình này finish luồng, gọi thêm finish()
    finish()
}
```

## 4. Hiển thị Modal & Bottom Sheet

Sử dụng hàm `present` có sẵn trong `Coordinator`.

### Hiển thị Modal (Bottom Sheet - PageSheet)

Để hiển thị một màn hình dưới dạng modal (ví dụ `Settings`), bạn nên tạo một `UINavigationController` riêng cho nó nếu nó có luồng riêng.

```swift
func showSettings() {
    // Tạo NavController riêng cho modal
    let settingsNavController = UINavigationController()
    
    let settingsCoordinator = SettingCoordinator(
        navigationController: settingsNavController,
        parentCoordinator: self
    )
    
    addChildCoordinator(settingsCoordinator)
    settingsCoordinator.start()
    
    // Present modal với style pageSheet (mặc định của iOS 13+)
    present(settingsNavController, configuration: .pageSheet)
}
```

Cấu hình `configuration` hỗ trợ:
- `.pageSheet`: Dạng thẻ kéo được (mặc định).
- `.fullScreen`: Tràn màn hình.
- `.formSheet`: Dạng form (thường dùng trên iPad).

## 5. Các lệnh điều hướng cơ bản

Base Coordinator cung cấp sẵn các wrapper cho `UINavigationController`:

| Hàm | Mô tả |
| --- | --- |
| `push(view)` | Push một SwiftUI View. |
| `push(viewController)` | Push một UIViewController. |
| `pop()` | Back về màn hình trước đó. |
| `popToRoot()` | Back về màn hình đầu tiên của stack. |
| `replaceAll(with: view)` | Reset stack, đặt view này làm root (dùng cho Splash -> Home). |
| `present(view/vc)` | Hiển thị modal. |
| `dismiss()` | Ẩn modal hiện tại. |

## 6. Xử lý Custom Navigation Bar

Nếu muốn ẩn Navigation Bar mặc định của iOS và dùng Custom Header:

Trong `Coordinator`:
```swift
func start() {
    let view = MyView()
    push(view)
}

func goBack() {
    pop()
}
```

Trong `View`:
```swift
var body: some View {
    VStack {
        // Header tự custom
        HStack {
            Button(action: { viewModel.goBack() }) {
                Image(systemName: "chevron.left")
            }
        }
        // Content
    }
    .navigationBarHidden(true) // Ẩn nav bar mặc định
}
```

## 7. Kết thúc Coordinator

Khi một flow kết thúc (ví dụ đóng Modal Settings), cần gọi hàm `finish()` để:
1. `dismiss` view (nếu cần).
2. Xoá coordinator con khỏi coordinator cha.
3. Xoá tất cả coordinator cháu.

```swift
// Trong SettingCoordinator
override func finish() {
    navigationController.dismiss(animated: true)
    super.finish() // Quan trọng: gọi super để xoá khỏi parent
}
```
