# Coordinator Pattern Guide

This document provides a guide on how to use the Coordinator Pattern in iOS projects, including how to create Views, ViewModels, Coordinators, and navigation methods.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Creating a New View](#creating-a-new-view)
3. [Creating a New ViewModel](#creating-a-new-viewmodel)
4. [Creating a New Coordinator](#creating-a-new-coordinator)
5. [Starting a Flow from AppDelegate](#starting-a-flow-from-appdelegate)
6. [Screen Navigation](#screen-navigation)
7. [Using Modals](#using-modals)
8. [When to Use Which Methods?](#when-to-use-which-methods)

---

## Architecture Overview

The project uses **MVVM-C (Model-View-ViewModel-Coordinator)** pattern:

- **View**: SwiftUI View, only displays UI and calls ViewModel
- **ViewModel**: Manages business logic, state, and calls NavigationDelegate
- **Coordinator**: Manages navigation flow, creates View/ViewModel and handles navigation
- **NavigationDelegate**: Protocol that defines navigation actions

### Flow:

```
View → ViewModel → NavigationDelegate → Coordinator → Navigation
```

---

## Creating a New View

### Step 1: Create View File

Create file `YourView.swift` in folder `BoilerplateIOS/Sources/Views/YourScreen/`

**Example: HomeView.swift**

```swift
import SwiftUI
import Core

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    // Your content here
                    Text("Home Screen")
                        .font(.title)
                    
                    Button("Show Detail") {
                        viewModel.showDetail()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .loading(viewModel.isLoading)
        .errorAlert(errorMessage: $viewModel.errorMessage)
    }
}

#Preview {
    HomeView()
}
```

### Notes:

- ✅ View only displays UI and calls ViewModel methods
- ✅ Do not call Coordinator directly
- ✅ Use `@ObservedObject` to bind ViewModel
- ✅ Use modifiers from Core: `.loading()`, `.errorAlert()`

---

## Creating a New ViewModel

### Step 1: Create NavigationDelegate Protocol

Create a protocol that defines navigation actions in the ViewModel file.

**Example: HomeViewModel.swift**

```swift
import Foundation
import Core
import Combine

/// Protocol that defines navigation actions for Home screen
protocol HomeNavigationDelegate: AnyObject {
    func showDetail()
    func showSettings()
    func showProfile()
}

final class HomeViewModel: BaseViewModel {
    @Published var items: [String] = []
    
    // MARK: - Navigation Delegate
    weak var navigationDelegate: HomeNavigationDelegate?
    
    override func setupBindings() {
        loadData()
    }
    
    func loadData() {
        setLoading(true)
        // Load data logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.items = ["Item 1", "Item 2", "Item 3"]
            self?.setLoading(false)
        }
    }
    
    // MARK: - Navigation Actions
    
    func showDetail() {
        navigationDelegate?.showDetail()
    }
    
    func showSettings() {
        navigationDelegate?.showSettings()
    }
    
    func showProfile() {
        navigationDelegate?.showProfile()
    }
}
```

### Notes:

- ✅ Protocol must inherit from `AnyObject` to use `weak var`
- ✅ ViewModel has `weak var navigationDelegate` to avoid retain cycle
- ✅ ViewModel calls `navigationDelegate?.method()` instead of calling Coordinator directly
- ✅ Inherit from `BaseViewModel` for loading, error handling

---

## Creating a New Coordinator

### Step 1: Create Coordinator File

Create file `YourCoordinator.swift` in folder `BoilerplateIOS/Sources/Views/YourScreen/`

**Example: HomeCoordinator.swift**

```swift
import UIKit
import SwiftUI
import Core

/// Home Coordinator manages home screen flow
final class HomeCoordinator: BaseCoordinator, HomeNavigationDelegate {
    
    override func start() {
        // 1. Create ViewModel
        let viewModel = HomeViewModel()
        
        // 2. Setup navigation delegate
        viewModel.navigationDelegate = self
        
        // 3. Create View with ViewModel
        let homeView = HomeView(viewModel: viewModel)
        
        // 4. Display View
        replaceAll(with: homeView, animated: true)
    }
    
    // MARK: - HomeNavigationDelegate
    
    func showDetail() {
        // Implementation to show detail screen
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )
        addChildCoordinator(detailCoordinator)
        detailCoordinator.start()
    }
    
    func showSettings() {
        // Implementation to show settings modal
        let settingsNavController = UINavigationController()
        let settingsCoordinator = SettingCoordinator(
            navigationController: settingsNavController,
            parentCoordinator: self
        )
        addChildCoordinator(settingsCoordinator)
        settingsCoordinator.start()
        present(settingsNavController, configuration: .pageSheet)
    }
    
    func showProfile() {
        // Implementation to show profile screen
        let profileCoordinator = ProfileCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )
        addChildCoordinator(profileCoordinator)
        profileCoordinator.start()
    }
}
```

### Notes:

- ✅ Coordinator inherits from `BaseCoordinator`
- ✅ Coordinator conforms to NavigationDelegate protocol
- ✅ In `start()`, setup `viewModel.navigationDelegate = self`
- ✅ Always call `addChildCoordinator()` when creating a new coordinator

---

## Starting a Flow from AppDelegate

### Step 1: Create AppCoordinator

**Example: AppCoordinator.swift**

```swift
import UIKit
import Core

/// Main App Coordinator manages the entire app flow
final class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init(navigationController: UINavigationController())
    }
    
    override func start() {
        // Set navigation controller as root
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // Initialize main app flow
        showMainFlow()
    }
    
    // MARK: - Private Methods
    
    private func showMainFlow() {
        // Start with splash screen
        let splashCoordinator = SplashCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )
        addChildCoordinator(splashCoordinator)
        splashCoordinator.start()
    }
}
```

### Step 2: Initialize in AppDelegate

**Example: AppDelegate.swift**

```swift
import UIKit
import Core

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Create window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Initialize and start AppCoordinator
        guard let window = window else { return false }
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        
        return true
    }
}
```

### Notes:

- ✅ Keep reference to `appCoordinator` in AppDelegate
- ✅ Create window and set rootViewController in AppCoordinator
- ✅ AppCoordinator is the root coordinator, manages the entire flow

---

## Screen Navigation

### 1. Push Screen (within the same navigation stack)

Use when the screen is within the same navigation stack.

**Example: Home → Detail**

```swift
// In HomeCoordinator
func showDetail(for item: Item) {
    // Create DetailCoordinator with params
    let detailCoordinator = DetailCoordinator(
        navigationController: navigationController, // Use same nav controller
        parentCoordinator: self,
        itemName: item.name,
        itemId: item.id
    )
    
    // Add to child coordinators
    addChildCoordinator(detailCoordinator)
    
    // Start coordinator (will call push() inside)
    detailCoordinator.start()
}

// In DetailCoordinator.start()
override func start() {
    let viewModel = DetailViewModel(...)
    viewModel.navigationDelegate = self
    let detailView = DetailView(viewModel: viewModel)
    
    // Push onto navigation stack
    push(detailView)
}
```

### 2. Passing Parameters Between Screens

**Example: Passing params from Home to Detail**

```swift
// 1. In DetailCoordinator - Receive params in init
final class DetailCoordinator: BaseCoordinator {
    private let itemName: String
    private let itemId: Int
    
    init(
        navigationController: UINavigationController,
        parentCoordinator: Coordinator?,
        itemName: String,
        itemId: Int
    ) {
        self.itemName = itemName
        self.itemId = itemId
        super.init(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator
        )
    }
    
    override func start() {
        // 2. Create ViewModel with params
        let viewModel = DetailViewModel(
            itemName: itemName,
            itemId: itemId
        )
        viewModel.navigationDelegate = self
        
        // 3. Create View and push
        let detailView = DetailView(viewModel: viewModel)
        push(detailView)
    }
}

// 4. In HomeCoordinator - Pass params when creating coordinator
func showDetail(for item: Item) {
    let detailCoordinator = DetailCoordinator(
        navigationController: navigationController,
        parentCoordinator: self,
        itemName: item.name,  // ← Pass params
        itemId: item.id       // ← Pass params
    )
    addChildCoordinator(detailCoordinator)
    detailCoordinator.start()
}
```

### 3. Pop to Previous Screen

```swift
// In Coordinator
func goBack() {
    pop() // Pop to previous screen
}

// If you want to finish coordinator when going back
func goBack() {
    pop()
    finish() // Clean up coordinator
}
```

### 4. Pop to Root

```swift
func goToRoot() {
    popToRoot() // Pop to first screen
}
```

---

## Using Modals

### 1. Modal with Separate Navigation Controller

Use when the modal has multiple screens inside (needs navigation).

**Example: Settings Modal**

```swift
// In HomeCoordinator
func showSettings() {
    // 1. Create separate navigation controller for modal
    let settingsNavController = UINavigationController()
    
    // 2. Create coordinator with separate nav controller
    let settingsCoordinator = SettingCoordinator(
        navigationController: settingsNavController,
        parentCoordinator: self
    )
    
    // 3. Add to child coordinators
    addChildCoordinator(settingsCoordinator)
    settingsCoordinator.start()
    
    // 4. Present modal with configuration
    present(settingsNavController, configuration: .pageSheet)
}

// In SettingCoordinator
override func start() {
    let viewModel = SettingViewModel()
    viewModel.navigationDelegate = self
    let settingView = SettingView(viewModel: viewModel)
    
    // Set root view for modal navigation stack
    replaceAll(with: settingView, animated: false)
}

// Dismiss modal
override func finish() {
    dismiss(animated: true) { [weak self] in
        guard let self = self else { return }
        self.removeAllChildCoordinators()
        self.parentCoordinator?.removeChildCoordinator(self)
    }
}
```

### 2. Simple Modal (without coordinator)

Use when the modal is just a simple view, without complex flow.

**Example: Alert Modal**

```swift
// In Coordinator
func showAlert() {
    let alertView = AlertView(
        title: "Alert",
        message: "This is an alert",
        onDismiss: { [weak self] in
            self?.dismiss()
        }
    )
    
    // Present simple modal
    present(alertView, configuration: .pageSheet)
}
```

### 3. ModalConfiguration Types

```swift
// Bottom sheet (can swipe down to dismiss)
present(view, configuration: .pageSheet)

// Full screen modal
present(view, configuration: .fullScreen)

// Form sheet (commonly used on iPad)
present(view, configuration: .formSheet)

// Custom configuration
let config = ModalConfiguration(
    presentationStyle: .pageSheet,
    transitionStyle: .flipHorizontal,
    isModalInPresentation: true // Prevent swipe down to dismiss
)
present(view, configuration: config)
```

### 4. Dismiss Modal

```swift
// In Coordinator
func closeModal() {
    dismiss() // Dismiss current modal
}

// Or in ViewModel (via delegate)
func dismissSettings() {
    navigationDelegate?.dismissSettings()
}

// In Coordinator conforming to delegate
func dismissSettings() {
    finish() // finish() will automatically dismiss if it's a modal
}
```

---

## When to Use Which Methods?

### 1. Child Coordinator Management

**When to use:**
- ✅ When creating a new **Child Coordinator** to manage a separate flow
- ✅ Must be used when creating any coordinator

**Methods:**
- `addChildCoordinator(_:)` - Add child coordinator
- `removeChildCoordinator(_:)` - Remove child coordinator
- `removeAllChildCoordinators()` - Remove all child coordinators
- `findChildCoordinator<T>(ofType:)` - Find child coordinator by type

**Example:**

```swift
func showDetail() {
    let detailCoordinator = DetailCoordinator(
        navigationController: navigationController,
        parentCoordinator: self
    )
    
    // ✅ MUST have this line
    addChildCoordinator(detailCoordinator)
    detailCoordinator.start()
}
```

**Notes:**
- ✅ **ALWAYS** call `addChildCoordinator()` when creating a new coordinator
- ✅ Child coordinator will automatically be removed when calling `finish()`

---

### 2. Navigation Methods (push/pop)

**When to use:**
- ✅ When navigating within **the same navigation stack**
- ✅ Push/pop screens within the same flow
- ✅ Screen is managed by the same `UINavigationController`

**Methods:**
- `push(_:animated:)` - Push view/viewController onto stack
- `pop(animated:)` - Pop to previous screen
- `popToRoot(animated:)` - Pop to first screen
- `replaceAll(with:animated:)` - Set root view controller

**Example:**

```swift
// Push Detail screen
override func start() {
    let viewModel = DetailViewModel(...)
    viewModel.navigationDelegate = self
    let detailView = DetailView(viewModel: viewModel)
    
    // ✅ Use push() because Detail is in the same navigation stack
    push(detailView)
}

// Set root view (Splash, Home)
override func start() {
    let viewModel = HomeViewModel()
    viewModel.navigationDelegate = self
    let homeView = HomeView(viewModel: viewModel)
    
    // ✅ Use replaceAll() to set root
    replaceAll(with: homeView, animated: true)
}
```

**When NOT to use:**
- ❌ When screen is a modal (use `present()` instead of `push()`)
- ❌ When screen has its own navigation controller (use `present()` with nav controller)

---

### 3. Modal Presentation Methods

**When to use:**
- ✅ When displaying screen as a **modal** (bottom sheet, full screen modal)
- ✅ When screen has its **own navigation controller**
- ✅ When you want to display screen **independently** from current navigation stack

**Methods:**
- `present(_:configuration:animated:completion:)` - Present view/viewController modally
- `dismiss(animated:completion:)` - Dismiss current modal

**Example:**

```swift
// Modal with separate navigation controller
func showSettings() {
    let settingsNavController = UINavigationController()
    let settingsCoordinator = SettingCoordinator(
        navigationController: settingsNavController,
        parentCoordinator: self
    )
    addChildCoordinator(settingsCoordinator)
    settingsCoordinator.start()
    
    // ✅ Use present() because Settings is a modal
    present(settingsNavController, configuration: .pageSheet)
}

// Simple modal
func showAlert() {
    let alertView = AlertView()
    
    // ✅ Use present() for simple modal
    present(alertView, configuration: .pageSheet)
}

// Dismiss modal
func closeModal() {
    dismiss() // ✅ Use dismiss() to close modal
}
```

---

## Summary: When to Use What?

| Scenario | Method | Example |
|----------|--------|---------|
| Create new coordinator | `addChildCoordinator()` | Whenever creating a coordinator |
| Screen in same stack | `push()` | Home → Detail |
| Set root view | `replaceAll()` | Splash, Home (root) |
| Screen is modal | `present()` | Home → Settings (modal) |
| Modal with own nav | `present()` with nav controller | Settings modal |
| Close modal | `dismiss()` | Close any modal |
| Back to previous screen | `pop()` | Detail → Home |
| Back to root | `popToRoot()` | To first screen |

---

## Checklist for Creating a New Screen

- [ ] Create View (SwiftUI)
- [ ] Create NavigationDelegate protocol
- [ ] Create ViewModel with `weak var navigationDelegate`
- [ ] Create Coordinator inheriting `BaseCoordinator` and conforming to NavigationDelegate
- [ ] In Coordinator `start()`: setup `viewModel.navigationDelegate = self`
- [ ] When creating new coordinator: always call `addChildCoordinator()`
- [ ] Screen in same stack? → Use `push()`
- [ ] Screen is modal? → Use `present()`
- [ ] Modal with own nav? → Create new `UINavigationController`

---

## Complete Examples

### Example 1: Simple Screen (Home → Detail)

**HomeCoordinator.swift**
```swift
final class HomeCoordinator: BaseCoordinator, HomeNavigationDelegate {
    override func start() {
        let viewModel = HomeViewModel()
        viewModel.navigationDelegate = self
        let homeView = HomeView(viewModel: viewModel)
        replaceAll(with: homeView, animated: true)
    }
    
    func showDetail(for item: Item) {
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            parentCoordinator: self,
            item: item
        )
        addChildCoordinator(detailCoordinator)
        detailCoordinator.start()
    }
}
```

**DetailCoordinator.swift**
```swift
final class DetailCoordinator: BaseCoordinator {
    private let item: Item
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinator?, item: Item) {
        self.item = item
        super.init(navigationController: navigationController, parentCoordinator: parentCoordinator)
    }
    
    override func start() {
        let viewModel = DetailViewModel(item: item)
        viewModel.navigationDelegate = self
        let detailView = DetailView(viewModel: viewModel)
        push(detailView)
    }
}
```

### Example 2: Modal with Separate Navigation (Settings)

**HomeCoordinator.swift**
```swift
func showSettings() {
    let settingsNavController = UINavigationController()
    let settingsCoordinator = SettingCoordinator(
        navigationController: settingsNavController,
        parentCoordinator: self
    )
    addChildCoordinator(settingsCoordinator)
    settingsCoordinator.start()
    present(settingsNavController, configuration: .pageSheet)
}
```

**SettingCoordinator.swift**
```swift
final class SettingCoordinator: BaseCoordinator, SettingNavigationDelegate {
    override func start() {
        let viewModel = SettingViewModel()
        viewModel.navigationDelegate = self
        let settingView = SettingView(viewModel: viewModel)
        replaceAll(with: settingView, animated: false)
    }
    
    func dismissSettings() {
        finish()
    }
    
    override func finish() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.removeAllChildCoordinators()
            self.parentCoordinator?.removeChildCoordinator(self)
        }
    }
}
```

---

## Best Practices

1. ✅ **Always** call `addChildCoordinator()` when creating a new coordinator
2. ✅ **Always** use `weak var` for navigationDelegate in ViewModel
3. ✅ **Do not** call Coordinator directly from View or ViewModel
4. ✅ **Use** protocol delegate pattern instead of closure callbacks
5. ✅ **Separate** navigation logic into Coordinator
6. ✅ **Use** `replaceAll()` for root view, `push()` for navigation stack
7. ✅ **Use** `present()` for modal, `dismiss()` to close

---

## Troubleshooting

### Issue: Coordinator not being removed, causing memory leak

**Solution:** Ensure you always call `addChildCoordinator()` and `finish()` correctly.

### Issue: Navigation not working

**Solution:** Check:
- Has ViewModel been set up with `navigationDelegate`?
- Does Coordinator conform to NavigationDelegate protocol?
- Are you calling the correct method (`push()` vs `present()`)?

### Issue: Modal not dismissing

**Solution:** Ensure you call `dismiss()` or `finish()` in Coordinator, not directly from View.

---

*This document is updated based on the current codebase. If there are changes in architecture, please update this document.*

