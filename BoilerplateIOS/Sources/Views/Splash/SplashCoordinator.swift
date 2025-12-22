import UIKit
import SwiftUI
import Core

/// Splash Coordinator manages splash screen flow
final class SplashCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private weak var parentCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController, parentCoordinator: AppCoordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewModel = SplashViewModel()
        viewModel.onFinish = { [weak self] in
            self?.showHome()
        }
        
        let splashView = SplashView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: splashView)
        hostingController.view.backgroundColor = .clear
        
        // Use replaceAll to set splash as root
        replaceAll(with: hostingController, animated: false)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
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

