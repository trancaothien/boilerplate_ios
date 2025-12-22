import UIKit
import SwiftUI
import Core

/// Home Coordinator manages home screen flow
final class HomeCoordinator: BaseCoordinator {
    
    override func start() {
        let viewModel = HomeViewModel()
        viewModel.coordinator = self
        let homeView = HomeView(viewModel: viewModel)
        
        // Replace all to set home as root
        navigationController.setViewControllers([UIHostingController(rootView: homeView)], animated: true)
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
        let settingsNavController = UINavigationController()
        
        let settingsCoordinator = SettingCoordinator(
            navigationController: settingsNavController,
            parentCoordinator: self
        )
        addChildCoordinator(settingsCoordinator)
        settingsCoordinator.start()
        
        settingsCoordinator.start()
        
        navigationController.present(settingsNavController, animated: true)
    }
    
    /// Show profile screen
    func showProfile() {
        let profileCoordinator = ProfileCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )
        addChildCoordinator(profileCoordinator)
        profileCoordinator.start()
    }
    
}

