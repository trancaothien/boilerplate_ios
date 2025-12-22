import UIKit
import SwiftUI
import Core

final class SettingCoordinator: BaseCoordinator {
    
    override func start() {
        let viewModel = SettingViewModel()
        viewModel.coordinator = self
        let settingView = SettingView(viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: settingView)
        hostingController.title = "Settings"
        
        // Since we are starting a new navigation stack (modal), we set it as root
        navigationController.setViewControllers([hostingController], animated: false)
    }
    
    override func finish() {
        // Dismiss the presented navigation controller
        navigationController.dismiss(animated: true)
        // Remove self from parent
        super.finish()
    }
}
