import UIKit
import Core

/// Main App Coordinator manages the entire app flow
final class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init(navigationController: UINavigationController())
    }
    
    override func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // Initialize main app flow
        showMainFlow()
    }
    
    override func finish() {
        // Cleanup if needed
        super.finish()
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

