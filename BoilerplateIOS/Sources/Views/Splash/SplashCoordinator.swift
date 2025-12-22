import UIKit
import SwiftUI
import Core

/// Splash Coordinator manages splash screen flow
final class SplashCoordinator: BaseCoordinator {
    
    override func start() {
        let viewModel = SplashViewModel()
        viewModel.onFinish = { [weak self] in
            self?.showHome()
        }
        
        let splashView = SplashView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: splashView)
        hostingController.view.backgroundColor = .clear
        
        // Use replaceAll to set splash as root
        navigationController.setViewControllers([hostingController], animated: false)
    }
    
    // MARK: - Private Methods
    
    private func showHome() {
        let homeCoordinator = HomeCoordinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator
        )
        parentCoordinator?.addChildCoordinator(homeCoordinator)
        homeCoordinator.start()
        finish()
    }
}

