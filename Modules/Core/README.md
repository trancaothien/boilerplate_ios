# Core Module

The Core module contains basic and reusable components used throughout the application.

## Structure

### Base Classes
- **BaseViewController.swift**: Base class for all ViewControllers with loading indicator, error handling
- **BaseViewModel.swift**: Base class for all ViewModels with loading state, error handling

### Coordinator
- **Coordinator.swift**: Protocol and extension for Coordinator pattern with full navigation actions:
  - `push()` / `pop()` - Push/Pop view controllers
  - `popToRoot()` / `popTo()` - Pop to root or specific view controller
  - `replace()` / `replaceAll()` - Replace top or all view controllers
  - `present()` / `dismiss()` - Modal presentation
  - `presentNavigation()` - Present with separate navigation controller

### Extensions
- **UIView+Extensions.swift**: Extensions for UIView (addSubviews, shadow, border, corner radius)
- **String+Extensions.swift**: Extensions for String (email validation, localization, trimming)
- **Date+Extensions.swift**: Extensions for Date (formatting, date checks)
- **UIColor+Extensions.swift**: Extensions for UIColor (hex color support)

### Utilities
- **Logger.swift**: Logger utility using OSLog
- **Reusable.swift**: Protocol and extensions for reusable cells (UITableView, UICollectionView)
- **KeychainHelper.swift**: Helper to save and retrieve data from Keychain

### Constants
- **AppConstants.swift**: App constants (App info, UI constants, Network constants, Date formats)
- **Environment.swift**: Environment configuration and AppConfiguration

## Dependencies

No external dependencies, only uses built-in frameworks:
- UIKit
- Foundation
- Combine
- Security (for Keychain)
- OSLog

## Usage

In other modules, import the Core framework:

```swift
import Core
```

### Example: Using Base Classes

```swift
import Core
import UIKit

class MyViewController: BaseViewController {
    override func setupUI() {
        super.setupUI()
        // Setup UI
    }
    
    override func bindViewModel() {
        // Bind ViewModel
    }
}
```

### Example: Using Extensions

```swift
import Core

// UIView extensions
view.addSubviews(label, button)
view.addShadow()
view.setBorder(width: 1, color: .separator, cornerRadius: 8)

// String extensions
let email = "test@example.com"
if email.isValidEmail {
    // Valid email
}

// Date extensions
let date = Date()
let formatted = date.formatted(format: "yyyy-MM-dd")
```

### Example: Using Utilities

```swift
import Core

// Logger
Logger.info("Info message")
Logger.debug("Debug message")
Logger.error("Error message")

// Keychain
let keychain = KeychainHelper()
keychain.save("token", forKey: "auth_token")
let token = keychain.get(forKey: "auth_token")

// Reusable cells
tableView.register(MyCell.self)
let cell = tableView.dequeueReusableCell(MyCell.self, for: indexPath)
```

### Example: Using Constants

```swift
import Core

let appName = AppConstants.App.name
let version = AppConstants.App.version
let padding = AppConstants.UI.defaultPadding
let dateFormat = AppConstants.DateFormat.defaultFormat
```

### Example: Using Environment Configuration

```swift
import Core

// Check current environment
let env = Environment.current
print("Current environment: \(env.displayName)")

// Get configuration values
let config = AppConfiguration.shared
print("API URL: \(config.apiBaseURL)")
print("Version: \(config.fullVersionString)")
print("Is Debug: \(config.isDebug)")
```

### Example: Using Coordinator Navigation

```swift
import Core
import SwiftUI

class MyCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    // Push a SwiftUI view
    func showDetail() {
        let detailView = DetailView()
        push(detailView) // animated by default
    }
    
    // Push UIViewController
    func showSettings() {
        let settingsVC = SettingsViewController()
        push(settingsVC, animated: true)
    }
    
    // Pop navigation
    func goBack() {
        pop()
    }
    
    func goToRoot() {
        popToRoot()
    }
    
    // Replace current view
    func replaceWithProfile() {
        let profileView = ProfileView()
        replace(with: profileView)
    }
    
    // Replace all (set new root)
    func resetToLogin() {
        let loginView = LoginView()
        replaceAll(with: loginView)
    }
    
    // Present modal (various styles)
    func showModal() {
        let modalView = ModalView()
        present(modalView, configuration: .pageSheet)
    }
    
    func showFullScreenModal() {
        let view = FullScreenView()
        present(view, configuration: .fullScreen)
    }
    
    // Present with navigation
    func showModalWithNavigation() {
        let rootVC = SomeViewController()
        let navController = presentNavigation(
            rootViewController: rootVC,
            configuration: .pageSheet
        )
    }
    
    // Dismiss modal
    func closeModal() {
        dismiss()
    }
    
    // Navigation stack info
    func checkStack() {
        print("Stack count: \(stackCount)")
        print("Can pop: \(canPop)")
        print("Top VC: \(topViewController)")
    }
}
```
