import UIKit
import Core

/// Main App Coordinator manages the entire app flow
final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // Initialize main app flow
        showMainFlow()
    }
    
    func finish() {
        // Cleanup if needed
        removeAllChildCoordinators()
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

