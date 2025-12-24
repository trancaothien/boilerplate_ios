import UIKit
import SwiftUI
import Core

/// Splash Coordinator manages splash screen flow
final class SplashCoordinator: BaseCoordinator, SplashNavigationDelegate {
    
    override func start() {
        let viewModel = SplashViewModel()
        
        // Setup navigation delegate
        viewModel.navigationDelegate = self
        
        let splashView = SplashView(viewModel: viewModel)
        
        // Use replaceAll to set splash as root
        replaceAll(with: splashView, animated: false)
    }
    
    // MARK: - SplashNavigationDelegate
    
    func onFinish() {
        showHome()
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

