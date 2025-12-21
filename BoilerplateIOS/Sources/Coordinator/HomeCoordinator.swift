import UIKit
import SwiftUI
import Core

/// Home Coordinator manages home screen flow
final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private weak var parentCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController, parentCoordinator: AppCoordinator?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewModel = HomeViewModel()
        viewModel.coordinator = self
        let homeView = HomeView(viewModel: viewModel)
        
        // Replace all to set home as root
        replaceAll(with: homeView, animated: true)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    // MARK: - Navigation Examples
    
    /// Push a detail screen
    func showDetail(for item: String) {
        // Example: Push a new SwiftUI view
        // let detailView = DetailView(item: item)
        // push(detailView)
    }
    
    /// Show settings screen modally
    func showSettings() {
        // Example: Present a modal with page sheet style
        // let settingsView = SettingsView()
        // present(settingsView, configuration: .pageSheet)
    }
    
    /// Show full screen modal
    func showFullScreenModal() {
        // Example: Present full screen modal
        // let modalView = SomeModalView()
        // present(modalView, configuration: .fullScreen)
    }
    
    /// Navigate back
    func goBack() {
        pop()
    }
    
    /// Navigate to root
    func goToRoot() {
        popToRoot()
    }
}

