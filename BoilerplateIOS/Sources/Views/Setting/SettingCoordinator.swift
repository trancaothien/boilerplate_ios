import UIKit
import SwiftUI
import Core

/// Setting Coordinator manages settings screen flow
final class SettingCoordinator: BaseCoordinator, SettingNavigationDelegate {
    
    override func start() {
        let viewModel = SettingViewModel()
        
        // Setup navigation delegate
        viewModel.navigationDelegate = self
        
        let settingView = SettingView(viewModel: viewModel)
        
        // Since we are starting a new navigation stack (modal), we set it as root
        replaceAll(with: settingView, animated: false)
    }
    
    // MARK: - SettingNavigationDelegate
    
    func dismissSettings() {
        finish()
    }
    
    override func finish() {
        // Dismiss the presented navigation controller
        dismiss(animated: true) { [weak self] in
            // Remove self from parent after dismiss completes
            guard let self = self else { return }
            // Clean up children and remove from parent
            self.removeAllChildCoordinators()
            self.parentCoordinator?.removeChildCoordinator(self)
        }
    }
}
