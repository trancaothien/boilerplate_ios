import UIKit
import SwiftUI
import Core

final class SettingCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    // Parent coordinator to handle removal when finished
    private weak var parentCoordinator: HomeCoordinator?
    
    init(navigationController: UINavigationController, parentCoordinator: HomeCoordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewModel = SettingViewModel()
        viewModel.coordinator = self
        let settingView = SettingView(viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: settingView)
        hostingController.title = "Settings"
        
        // Since we are starting a new navigation stack (modal), we set it as root
        replaceAll(with: hostingController, animated: false)
    }
    
    func finish() {
        // Dismiss the presented navigation controller
        navigationController.dismiss(animated: true)
        // Remove self from parent
        parentCoordinator?.removeChildCoordinator(self)
    }
}
