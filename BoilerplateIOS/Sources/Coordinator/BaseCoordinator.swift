import UIKit
import Core

/// Base class for all coordinators to reduce boilerplate
open class BaseCoordinator: Coordinator {
    
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    
    /// Parent coordinator reference
    public weak var parentCoordinator: Coordinator?
    
    public init(
        navigationController: UINavigationController,
        parentCoordinator: Coordinator? = nil
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    open func start() {
        fatalError("Start method should be implemented by subclass")
    }
    
    open func finish() {
        // Clean up children
        removeAllChildCoordinators()
        // Remove self from parent
        parentCoordinator?.removeChildCoordinator(self)
    }
}
